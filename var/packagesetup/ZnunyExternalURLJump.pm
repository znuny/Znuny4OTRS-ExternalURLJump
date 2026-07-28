# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::ZnunyExternalURLJump;

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::SysConfig',
);

=head1 NAME

var::packagesetup::ZnunyExternalURLJump - code to execute during package installation

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CodeObject = $Kernel::OM->Get('var::packagesetup::ZnunyExternalURLJump');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 CodeUpgrade()

dispatches to the code upgrade step matching the given Version, called from the sopm's
CodeUpgrade post block

    my $Result = $CodeObject->CodeUpgrade(
        Version => '7.3.3',
    );

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    my %VersionDispatch = (
        '7.3.3' => '_CodeUpgrade733',
    );

    my $Method = $VersionDispatch{ $Param{Version} // '' };
    return 1 if !$Method;

    return $Self->$Method(%Param);
}

=head2 _CodeUpgrade733()

restores values captured by the CodeUpgrade pre step (still inline in the sopm, since this module
is not installed yet at that point) onto the settings renamed in 7.3.2, fixing up any stale
C<Action=ExternalURLJump> references left over in Link values along the way

=cut

sub _CodeUpgrade733 {
    my ( $Self, %Param ) = @_;

    my $CacheObject     = $Kernel::OM->Get('Kernel::System::Cache');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my %ActionRename = (
        'Frontend::Navigation###AgentExternalURLJump###1'            => [ 'ExternalURLJump', 'AgentExternalURLJump' ],
        'CustomerFrontend::Navigation###CustomerExternalURLJump###1' =>
            [ 'ExternalURLJump', 'CustomerExternalURLJump' ],
    );

    my @NewSettingNames = (
        'Frontend::Module###AgentExternalURLJump',
        'Frontend::Navigation###AgentExternalURLJump###1',
        'CustomerFrontend::Module###CustomerExternalURLJump',
        'CustomerFrontend::Navigation###CustomerExternalURLJump###1',
    );

    my @NewSettings;

    NEWNAME:
    for my $NewName (@NewSettingNames) {
        my $Cached = $CacheObject->Get(
            Type => 'ZnunyExternalURLJumpUpgrade733',
            Key  => $NewName,
        );

        next NEWNAME if !$Cached;

        if ( $ActionRename{$NewName} && ref $Cached->{EffectiveValue} eq 'ARRAY' ) {
            my ( $OldAction, $NewAction ) = @{ $ActionRename{$NewName} };

            ITEM:
            for my $Item ( @{ $Cached->{EffectiveValue} } ) {
                next ITEM if ref $Item ne 'HASH';
                next ITEM if !$Item->{Link};

                $Item->{Link} =~ s{ \A Action=\Q$OldAction\E ; }{Action=$NewAction;}xms;
            }
        }

        push @NewSettings, {
            Name           => $NewName,
            EffectiveValue => $Cached->{EffectiveValue},
            IsValid        => $Cached->{IsValid},
        };

        $CacheObject->Delete(
            Type => 'ZnunyExternalURLJumpUpgrade733',
            Key  => $NewName,
        );
    }

    return 1 if !@NewSettings;

    return $SysConfigObject->SettingsSet(
        UserID   => 1,
        Comments => 'Znuny-ExternalURLJump - restored customized values after 7.3.2 setting rename.',
        Settings => \@NewSettings,
    );
}

1;

# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::ExternalURLJump;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Log',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $Interface = 'Agent';
    if ( index( $LayoutObject->{Baselink}, 'customer.pl' ) != -1 ) {
        $Interface = 'Customer';
    }

    my $ExtURL = $ParamObject->GetParam( Param => 'URL' );

    #
    # Check that only one of the configured links was given as parameter
    #
    my $URLEncodedExtURL = $LayoutObject->LinkEncode($ExtURL);

    my $FrontendNavigationConfig;
    if ( $Interface eq 'Agent' ) {
        $FrontendNavigationConfig = $ConfigObject->Get('Frontend::Navigation') // {};
    }
    else {
        $FrontendNavigationConfig = $ConfigObject->Get('CustomerFrontend::Navigation') // {};
    }

    my $URLIsConfigured;
    my $ExternalURLJumpConfigs = $FrontendNavigationConfig->{ExternalURLJump} // {};

    EXTERNALURLJUMPCONFIGKEY:
    for my $ExternalURLJumpConfigKey ( sort keys %{$ExternalURLJumpConfigs} ) {
        ELEMENT:
        for my $Element ( @{ $ExternalURLJumpConfigs->{$ExternalURLJumpConfigKey} // [] } ) {
            my $Link = $Element->{Link} // '';

            if ( $Link !~ m{\AAction=ExternalURLJump;URL=(.+)} ) {
                $LogObject->Log(
                    Priority => 'error',
                    Message =>
                        "Configured link for external URL jump has not the expected format (see configuration documentation): '$Link'"
                );
                next ELEMENT;
            }

            my $ConfiguredExtURL = $1;

            # Note: Might already be encoded, it's just to ensure checking all possible combinations.
            my $URLEncodedConfiguredExtUrl = $LayoutObject->LinkEncode($ConfiguredExtURL);
            if (
                $ConfiguredExtURL eq $ExtURL
                || $ConfiguredExtURL eq $URLEncodedExtURL
                || $URLEncodedConfiguredExtUrl eq $ExtURL
                || $URLEncodedConfiguredExtUrl eq $URLEncodedExtURL
                )
            {
                $URLIsConfigured = 1;
                last EXTERNALURLJUMPCONFIGKEY;
            }
        }
    }

    # Given URL is not a configured one: Redirect to overview
    if ( !$URLIsConfigured ) {
        if ( $Interface eq 'Agent' ) {
            return $LayoutObject->Redirect( OP => 'Action=AgentDashboard' );
        }
        else {
            return $LayoutObject->Redirect( OP => 'Action=CustomerTicketOverview' );
        }
    }

    #
    # Fill placeholders
    #
    my $UserAttributeRegex = qr/\AUser(.+)/;
    my @UserAttributes     = grep { $_ =~ m{$UserAttributeRegex} } sort keys %{$LayoutObject};

    USERATTRIBUTE:
    for my $UserAttribute (@UserAttributes) {

        next USERATTRIBUTE if $UserAttribute eq 'UserPw';
        next USERATTRIBUTE if $UserAttribute eq 'UserChallengeToken';

        my $UCUserAttribute = uc($UserAttribute);
        my $Value           = $LayoutObject->{$UserAttribute};

        $ExtURL =~ s{\_\Q$UCUserAttribute\E\_}{$Value}g;
    }

    return $LayoutObject->Redirect( ExtURL => $ExtURL );
}

1;

# --
# Kernel/Modules/ExternalURLJump.pm - jump to external URL
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::ExternalURLJump;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ExtURL = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'URL' );

    return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect( ExtURL => $ExtURL );
}

1;

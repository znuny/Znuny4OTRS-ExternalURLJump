# --
# Kernel/Modules/ExternalURLJump.pm - jump to external URL
# Copyright (C) 2015 Znuny, http://znuny.com/
# --

package Kernel::Modules::ExternalURLJump;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject TimeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ExtURL = $Self->{ParamObject}->GetParam( Param => 'URL' );

    return $Self->{LayoutObject}->Redirect( ExtURL => $ExtURL );
}

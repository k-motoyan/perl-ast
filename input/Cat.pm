package Cat;

use utf8;
use strict;
use warnings;

use base qw( Animal );
use Flayable;

sub legs {
    my $self = shift;
    return 4;
}

sub cry {
    warn "nya-n...\n";
}

1;

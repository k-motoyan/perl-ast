package Animal;

use utf8;
use strict;
use warnings;

sub new {
    bless {}, shift;
}

sub cry {
    warn "this method is abstraction.\n";
}

1;

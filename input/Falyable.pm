package Flayable;

use utf8;
use strict;
use warnings;
use base "Exporter";

@EXPORT = qw/ fly /;

$global_var = "OK";
%global_h = ();
my @arr = ();
my %h = ();

sub fly {
    my $self = shift;
    print "I am fling!!";
}

{
    package CustomFlyable;
    use Cat;
    sub high_speed {
        shift->{high_speed} = Cat->new;
    }
}

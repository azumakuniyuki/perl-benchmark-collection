#!/usr/bin/perl -w
# Regular Expression: (?:a|b|c) v.s. (a|b|c)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $X = 'From: MAILER-DAEMON <mailer-daemon@example.jp>';

sub docapture { 
    my $x = shift;
    my $y = '';
    if( $x =~ m/\A([-0-9A-Za-z]+?)[:][ ]*.+\z/ ) {
        $y = lc $1;
    }
    return $y;
}

sub usesplit {
    my $x = shift;
    my $y = lc [split( ':', $x, 2 )]->[0];
    return $y;
}

is( docapture($X), 'from' );
is( usesplit($X),  'from' );

cmpthese(300000, { 
    'Capture' => sub { &docapture($X) }, 
    'split()' => sub { &usesplit($X) }, 
});

__END__

Mac OS X 10.9.5/Perl 5.20.1
ok 1
ok 2
            Rate split() Capture
split() 357143/s      --    -45%
Capture 652174/s     83%      --

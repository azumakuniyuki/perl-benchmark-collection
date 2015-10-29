#!/usr/bin/perl
# <<, >> v.s. *, /
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub bitshift {
    my $x = shift;
    $x = $x << 1;
    $x = $x >> 1;
    $x = $x << 1;
    $x = $x << 1;
    $x = $x << 1;
    return $x;
}

sub mltpldiv {
    my $x = shift;
    $x *= 2;
    $x /= 2;
    $x *= 2;
    $x *= 2;
    $x *= 2;
    return $x;
}

is( bitshift(1), 8 );
is( mltpldiv(1), 8 );

cmpthese( 900000, { 
        '<<, >>' => sub { bitshift(1); },
        '*2, /2' => sub { mltpldiv(1); },
    }
);

__END__

* Mac OS X 10.9.5/Perl 5.20.1
            Rate *2, /2 <<, >>
*2, /2 2000000/s     --    -4%
<<, >> 2093023/s     5%     --

* MacBook Air/Mac OS X 10.7.5/Perl 5.14.2
            Rate *2, /2 <<, >>
*2, /2 1636364/s     --   -15%
<<, >> 1914894/s    17%     --

* MacBook Air/Mac OS X 10.7.5/Perl 5.12.3
            Rate *2, /2 <<, >>
*2, /2 1500000/s     --   -10%
<<, >> 1666667/s    11%     --

* OpenBSD 5.2/Perl 5.12.2
           Rate *2, /2 <<, >>
*2, /2 604027/s     --   -16%
<<, >> 720000/s    19%     --

* Ubuntu 10.04.4/Perl 5.12.4
           Rate *2, /2 <<, >>
*2, /2 882353/s     --    -8%
<<, >> 957447/s     9%     --

* Ubuntu 10.04.4/Perl 5.10.1
           Rate *2, /2 <<, >>
*2, /2 652174/s     --   -27%
<<, >> 891089/s    37%     --


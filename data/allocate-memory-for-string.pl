#!/usr/bin/perl
# Allocation v.s. Expansion
use strict;
use warnings;
use Benchmark ':all';

my $STRING = '.' x ( 1 << 16 );

cmpthese(800000, { 
    'Allocation1' => sub { my $v = ' ' x ( 1 << 18 ); $v = $STRING; },
    'Allocation2' => sub { my $v = ' ' x ( 1 << 16 ); $v = $STRING; },
    'Allocation3' => sub { my $v = ' ' x ( 1 <<  8 ); $v = $STRING; },
    'Allocation4' => sub { my $v = ' ' x ( 1 <<  4 ); $v = $STRING; },
    'Allocation5' => sub { my $v = ' ' x ( 1 <<  1 ); $v = $STRING; },
    'Allocation6' => sub { my $v = ' ' x ( 1 <<  0 ); $v = $STRING; },
    'Expansion'   => sub { my $v = undef;             $v = $STRING; },
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
                 Rate Allocation1 Allocation2 Allocation3 Allocation5 Allocation6 Allocation4 Expansion
Allocation1   40465/s          --        -86%        -99%        -99%        -99%        -99%      -99%
Allocation2  282686/s        599%          --        -90%        -93%        -93%        -93%      -96%
Allocation3 2857143/s       6961%        911%          --        -29%        -32%        -32%      -57%
Allocation5 4000000/s       9785%       1315%         40%          --         -5%         -5%      -40%
Allocation6 4210526/s      10305%       1389%         47%          5%          --          0%      -37%
Allocation4 4210526/s      10305%       1389%         47%          5%          0%          --      -37%
Expansion   6666667/s      16375%       2258%        133%         67%         58%         58%        --

* Mac OS X 10.7.5/Perl 5.14.2
                Rate Allocation1 Allocation2 Allocation3 Allocation4 Allocation6 Allocation5 Expansion
Allocation1  25510/s          --        -75%        -91%        -91%        -91%        -91%      -91%
Allocation2 102564/s        302%          --        -64%        -65%        -65%        -65%      -66%
Allocation3 285714/s       1020%        179%          --         -1%         -1%         -1%       -4%
Allocation4 289855/s       1036%        183%          1%          --         -0%         -0%       -3%
Allocation6 289855/s       1036%        183%          1%          0%          --         -0%       -3%
Allocation5 289855/s       1036%        183%          1%          0%          0%          --       -3%
Expansion   298507/s       1070%        191%          4%          3%          3%          3%        --

* OpenBSD 5.2/Perl 5.12.2
               Rate Allocation1 Allocation2 Allocation3 Allocation6 Allocation4 Allocation5 Expansion
Allocation1  3549/s          --        -85%        -94%        -95%        -95%        -95%      -95%
Allocation2 23474/s        561%          --        -63%        -64%        -64%        -65%      -65%
Allocation3 64103/s       1706%        173%          --         -2%         -2%         -3%       -6%
Allocation6 65147/s       1736%        178%          2%          --          0%         -2%       -4%
Allocation4 65147/s       1736%        178%          2%          0%          --         -2%       -4%
Allocation5 66225/s       1766%        182%          3%          2%          2%          --       -3%
Expansion   68027/s       1817%        190%          6%          4%          4%          3%        --


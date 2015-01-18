#!/usr/bin/perl
# $# v.s. scalar()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @A = ();
my @B = ();
my @C = ();
sub dollsharp { push( @A, shift ); return $#A + 1; }
sub usescalar { push( @B, shift ); return scalar(@B); }
sub usereturn { push( @C, shift ); return @C; }

is( dollsharp(0), 1 );
is( usescalar(0), 1 );
is( usereturn(0), 1 );

my @Z = ( 1 .. 100 );
cmpthese( 70000, { 
    '($#A + 1)' => sub { &dollsharp($_) for @Z; },
    'scalar @B' => sub { &usescalar($_) for @Z; },
    'return @C' => sub { &usereturn($_) for @Z; },
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
             Rate ($#A + 1) scalar @B return @C
($#A + 1) 25641/s        --      -11%      -20%
scalar @B 28807/s       12%        --      -10%
return @C 31963/s       25%       11%        --

* PowerBookG5/perl 5.8.8
            Rate ($#A + 1) scalar @B return @C
($#A + 1) 5263/s        --      -14%      -23%
scalar @B 6098/s       16%        --      -10%
return @C 6803/s       29%       12%        --

* PowerBookG4/perl 5.10.0
            Rate ($#A + 1) scalar @B return @C
($#A + 1) 4098/s        --      -24%      -32%
scalar @B 5376/s       31%        --      -11%
return @C 6024/s       47%       12%        --

* PowerBookG4/perl 5.12.0
            Rate ($#A + 1) scalar @B return @C
($#A + 1) 4566/s        --      -13%      -21%
scalar @B 5236/s       15%        --      -10%
return @C 5814/s       27%       11%        --

* Ubuntu 8.04 LTS/perl 5.10.1
             Rate ($#A + 1) scalar @B return @C
($#A + 1)  9524/s        --      -19%      -26%
scalar @B 11765/s       24%        --       -8%
return @C 12821/s       35%        9%        --

* Mac OS X 10.7.5/Perl 5.14.2
             Rate ($#A + 1) scalar @B return @C
($#A + 1) 23569/s        --      -17%      -21%
scalar @B 28455/s       21%        --       -4%
return @C 29787/s       26%        5%        --

* OpenBSD 5.2/Perl 5.12.2
            Rate ($#A + 1) scalar @B return @C
($#A + 1) 7392/s        --      -10%      -20%
scalar @B 8178/s       11%        --      -12%
return @C 9284/s       26%       14%        --


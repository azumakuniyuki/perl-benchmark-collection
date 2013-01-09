#!/usr/bin/perl
# $# v.s. scalar()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @A = ();
my @B = ();
my @C = ();
sub dollsharp { push( @A, shift() ); return( $#A + 1 ); }
sub usescalar { push( @B, shift() ); return( scalar(@B) ); }
sub usereturn { push( @C, shift() ); return @C; }

is( dollsharp(0), 1 );
is( usescalar(0), 1 );
is( usereturn(0), 1 );

my @Z = ( 1 .. 100 );
cmpthese( 10000, { 
		'($#A + 1)' => sub{ &dollsharp($_) for @Z; },
		'scalar @B' => sub{ &usescalar($_) for @Z; },
		'return @C' => sub{ &usereturn($_) for @Z; },
	});

__END__

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


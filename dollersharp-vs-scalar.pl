#!/usr/bin/perl
# $# v.s. scalar()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @A = ();
my @B = ();
sub dollsharp { push( @A, shift() ); return( $#A + 1 ); }
sub usescalar { push( @B, shift() ); return( scalar(@B) ); }

is( dollsharp(0), 1 );
is( usescalar(0), 1 );

my @C = ( 1 .. 100 );
cmpthese( 10000, { 
		'($#A + 1)' => sub{ &dollsharp($_) for @C; },
		'scalar @B' => sub{ &usescalar($_) for @C; },
	});

__END__

* PowerBookG5/perl 5.8.8
            Rate ($#A + 1) scalar @B
($#A + 1) 5376/s        --      -13%
scalar @B 6211/s       16%        --

* PowerBookG4/perl 5.10.0
            Rate ($#A + 1) scalar @B
($#A + 1) 4082/s        --      -26%
scalar @B 5495/s       35%        --

* PowerBookG4/perl 5.12.0
            Rate ($#A + 1) scalar @B
($#A + 1) 4545/s        --      -13%
scalar @B 5208/s       15%        --


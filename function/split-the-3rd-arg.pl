#!/usr/bin/perl -w
# split(':',@x) vs. split(':',@x,5)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $L = [ 0..9 ];
my $S = join( ':', @$L );

sub use3rd { 
    my @x = split( ':', $S, 5 );
	return scalar @x;
}

sub twoarg {
	my @x = split( ':', $S );
	return scalar @x;
}

is( twoarg(), 10 );
is( use3rd(), 5 );

cmpthese( 900000, { 
	'split(":",@x)' => sub { twoarg() }, 
	'split(":",@x,5)' => sub { use3rd() }, 
});

__END__

* Mac OS X 10.9.4/Perl 5.14.2
                    Rate   split(":",@x) split(":",@x,5)
split(":",@x)   255682/s              --            -43%
split(":",@x,5) 445545/s             74%              --


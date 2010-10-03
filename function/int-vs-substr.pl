#!/usr/bin/perl
# Check number/ int() vs. substr() vs. regular expression
use Benchmark qw(:all);
use Test::More 'no_plan';

my $N = 511;
sub asinteger { return 5 if( int($N / 100) == 5 ); }
sub usesubstr { return 5 if( substr($N,0,1) == 5 ); }
sub withregex { return 5 if( $N =~ m{\A5} ); }

is( asinteger, 5 );
is( usesubstr, 5 );
is( withregex, 5 );

cmpthese(400000, { 
	'as integer' => sub { asinteger() },
	'with regex' => sub { withregex() },
	'use substr' => sub { usesubstr() },
});

__END__
* PowerBookG5/perl 5.8.8
               Rate with regex as integer use substr
with regex 800000/s         --       -10%       -12%
as integer 888889/s        11%         --        -2%
use substr 909091/s        14%         2%         --

* PowerBookG4/perl 5.10.0
               Rate with regex as integer use substr
with regex 625000/s         --        -3%        -8%
as integer 645161/s         3%         --        -5%
use substr 677966/s         8%         5%         --

* PowerBookG4/perl 5.12.0
               Rate with regex as integer use substr
with regex 606061/s         --        -9%       -15%
as integer 666667/s        10%         --        -7%
use substr 714286/s        18%         7%         --


#!/usr/bin/perl
# Check number/ int() vs. substr() vs. regular expression
use Benchmark qw(:all);
use Test::More 'no_plan';

my $N = 511;
sub asinteger
{
	foreach my $n ( 1..9 )
	{
		return $n if( int($N / 100) == $n );
	}
}

sub usesubstr
{
	foreach my $n ( 1..9 )
	{
		return $n if( substr($N,0,1) == $n );
	}
}

sub withregex
{
	foreach my $n ( 1..9 )
	{
		return $n if( $N =~ m{\A$n} );
	}
}

is( asinteger, 5 );
is( usesubstr, 5 );
is( withregex, 5 );

cmpthese(100000, { 
	'as integer' => sub { asinteger() },
	'with regex' => sub { withregex() },
	'use substr' => sub { usesubstr() },
});

__END__
* PowerBookG5/perl 5.8.8
               Rate with regex use substr as integer
with regex  20080/s         --       -91%       -91%
use substr 222222/s      1007%         --        -0%
as integer 222222/s      1007%         0%         --

* PowerBookG4/perl 5.10.0
               Rate with regex as integer use substr
with regex  11274/s         --       -93%       -93%
as integer 161290/s      1331%         --        -3%
use substr 166667/s      1378%         3%         --

* PowerBookG4/perl 5.12.0
               Rate with regex use substr as integer
with regex  18868/s         --       -89%       -89%
use substr 166667/s       783%         --        -2%
as integer 169492/s       798%         2%         --


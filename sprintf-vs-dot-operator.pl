#!/usr/bin/perl
# sprintf() v.s. . (dot operator)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub sprintffunc
{
	my $x = shift();
	my $y = shift();
	my $z = shift();
	return sprintf( "1st: %s, 2nd: %d, and 3rd: %s", $x, $y, $z );
}

sub dotoperator
{
	my $x = shift();
	my $y = shift();
	my $z = shift();
	return '1st: '.$x.', 2nd: '.$y.', and 3rd: '.$z;
}

is( sprintffunc('One',2,'III'), '1st: One, 2nd: 2, and 3rd: III' );
is( dotoperator('One',2,'III'), '1st: One, 2nd: 2, and 3rd: III' );

cmpthese( 200000, { 
		'sprintf()' => sub { sprintffunc('One',2,'III'); },
		'.operator' => sub { dotoperator('One',2,'III'); },
	}
);

__END__

* PowerBookG5/perl 5.8.8
              Rate .operator sprintf()
.operator 333333/s        --       -2%
sprintf() 338983/s        2%        --

* PowerBookG4/perl 5.10.0
              Rate sprintf() .operator
sprintf() 232558/s        --      -14%
.operator 270270/s       16%        --

* PowerBookG4/perl 5.12.0
              Rate sprintf() .operator
sprintf() 285714/s        --       -1%
.operator 289855/s        1%        --


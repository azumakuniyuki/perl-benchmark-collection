#!/usr/bin/perl
# switch() v.s. if()-else() v.s. Ternary
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Switch 'Perl5','Perl6';

sub switchcase
{
	my $x = shift() || 0;
	switch($x)
	{
		case 0 { return(0); }
		case 1 { return(1); }
		case 2 { return(2); }
		case 3 { return(3); }
		case 4 { return(4); }
		case 5 { return(5); }
		case 6 { return(6); }
		case 7 { return(7); }
		case 8 { return(8); }
		case 9 { return(9); }
		else { return(-1); }
	}
}

sub givenwhen
{
	my $x = shift() || 0;
	given($x)
	{
		when(0){ return(0); }
		when(1){ return(1); }
		when(2){ return(2); }
		when(3){ return(3); }
		when(4){ return(4); }
		when(5){ return(5); }
		when(6){ return(6); }
		when(7){ return(7); }
		when(8){ return(8); }
		when(9){ return(9); }
		default{ return(-1); }
	}
}

sub ifelsifelse
{
	my $x = shift() || 0;
	if( $x == 0 ){ return(0); }
	elsif( $x == 1 ){ return(1); }
	elsif( $x == 2 ){ return(2); }
	elsif( $x == 3 ){ return(3); }
	elsif( $x == 4 ){ return(4); }
	elsif( $x == 5 ){ return(5); }
	elsif( $x == 6 ){ return(6); }
	elsif( $x == 7 ){ return(7); }
	elsif( $x == 8 ){ return(8); }
	elsif( $x == 9 ){ return(9); }
	else{ return(-1); }
}

sub ternary
{
	my $x = shift() || 0;
	return(
		$x == 0 ? 0 :
		$x == 1 ? 1 :
		$x == 2 ? 2 :
		$x == 3 ? 3 :
		$x == 4 ? 4 :
		$x == 5 ? 5 :
		$x == 6 ? 6 :
		$x == 7 ? 7 :
		$x == 8 ? 8 :
		$x == 9 ? 9 : -1
	);
}

my $test = { 'switchcase' => 0, 'givenwhen' => 0, 'ifelsifelse' => 0, 'ternary' => 0 };
my $summ = 45;
map { $test->{'switchcase'} += switchcase($_) } 0..9;
# map { $test->{'givenwhen'} += givenwhen($_) } 0..9;
map { $test->{'ifelsifelse'} += ifelsifelse($_) } 0..9;
map { $test->{'ternary'} += ternary($_) } 0..9;

is( $test->{'switchcase'}, $summ );
# is( $test->{'givenwhen'}, $summ );
is( $test->{'ifelsifelse'}, $summ );
is( $test->{'ternary'}, $summ );

cmpthese( 20000, { 
		'switch-case' => sub { map { switchcase($_) } 0..9 },
		# 'given-when' => sub { map { givenwhen($_) } 0..9 },
		'if-elsif-else' => sub { map { ifelsifelse($_) } 0..9 },
		'ternary ? 1 : 0' => sub { map { ternary($_) } 0..9 },
	}
);

__END__
* PowerBookG5/perl 5.8.8
                   Rate     switch-case ternary ? 1 : 0   if-elsif-else
switch-case      1479/s              --            -96%            -96%
ternary ? 1 : 0 39216/s           2551%              --             -4%
if-elsif-else   40816/s           2659%              4%              --


* PowerBookG4/perl 5.10.0
                   Rate     switch-case ternary ? 1 : 0   if-elsif-else
switch-case       885/s              --            -97%            -97%
ternary ? 1 : 0 31746/s           3489%              --             -0%
if-elsif-else   31746/s           3489%              0%              --

* PowerBookG4/perl 5.12.0
Switch will be removed from the Perl core distribution in the next major release. Please install it from CPAN. It is being used at ifelse-vs-switch.pl, line 7.
                   Rate     switch-case ternary ? 1 : 0   if-elsif-else
switch-case      1337/s              --            -96%            -96%
ternary ? 1 : 0 31250/s           2237%              --             -0%
if-elsif-else   31250/s           2237%              0%              --




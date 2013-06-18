#!/usr/bin/perl -w
# [ @list ] vs. \@list
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @list1 = ( 0 .. 1023 );
my @list2 = ( 0 .. 1023 );

sub squarebracket { 
	my $x = [ @list1 ]; 
	my $y = [ @list2 ];
	my $z = shift || int rand scalar @list1;

	return $x->[ $z ] + $y->[ $z ];
}

sub listbackslash {
	my $x = \@list1; 
	my $y = \@list2;
	my $z = shift || int rand scalar @list1;
	return $x->[ $z ] + $y->[ $z ];
}

my %hash1 = ( 'neko1' => 'kijitora', 'neko2' => 'mikeneko', 'neko3' => 'sabatora' );
my %hash2 = ( 'neko1' => 'kijitora', 'neko2' => 'mikeneko', 'neko3' => 'sabatora' );

sub curlybrackets {
	my $x = { %hash1 };
	my $y = { %hash2 };
	my $z = shift || int(rand(3)) + 1;
	return $x->{'neko'.$z}.$y->{'neko'.$z};
}

sub hashbackslash {
	my $x = \%hash1;
	my $y = \%hash2;
	my $z = shift || int(rand(3)) + 1;
	return $x->{'neko'.$z}.$y->{'neko'.$z};
}

is( squarebracket(512), 1024 );
is( listbackslash(512), 1024 );
is( curlybrackets(1), 'kijitorakijitora' );
is( hashbackslash(2), 'mikenekomikeneko' );

cmpthese( 800000, { 
	'[ @list ]' => \&squarebracket,
	' \@list  ' => \&listbackslash,
});

cmpthese( 800000, { 
	'{ %hash }' => \&curlybrackets,
	' \%hash  ' => \&hashbackslash,
});

__END__

* Mac OS X 10.7.5/Perl 5.14.2
               Rate [ @list ]  \@list  
[ @list ]   13385/s        --      -99%
 \@list   1269841/s     9387%        --

              Rate { %hash }  \%hash  
{ %hash } 206718/s        --      -79%
 \%hash   987654/s      378%        --

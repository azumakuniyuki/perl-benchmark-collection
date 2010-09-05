#!/usr/bin/perl -w
# Regular Expression: (?:a|b|c) v.s. (a|b|c)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $X = 'example.jp';
my $Y = 'example.int';

sub docapture
{ 
	my $x = shift();
	my $r = qr{\Aexample[.](com|net|org|int|jp)\z};
	return(1) if( $x =~ $r );
}

sub grouponly
{
	my $x = shift();
	my $r = qr{\Aexample[.](?:com|net|org|int|jp)\z};
	return(1) if( $x =~ $r );
}

ok( docapture($X) );
ok( grouponly($X) );

cmpthese(200000, { 
	'Do Capture' => sub { &docapture($Y) }, 
	'Group Only' => sub { &grouponly($Y) }, 
});

__END__

* PowerBookG4/perl 5.8.8
               Rate Do Capture Group Only
Do Capture 158730/s         --        -5%
Group Only 166667/s         5%         --

* PowerBookG4/perl 5.10.0
              Rate Do Capture Group Only
Do Capture 56180/s         --        -5%
Group Only 59347/s         6%         --

* PowerBookG4/perl 5.12.0
              Rate Do Capture Group Only
Do Capture 92166/s         --        -7%
Group Only 99010/s         7%         --

* Ubuntu 8.04 LTS/perl 5.10.1
               Rate Do Capture Group Only
Do Capture 152672/s         --       -11%
Group Only 172414/s        13%         --


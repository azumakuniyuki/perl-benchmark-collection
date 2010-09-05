#!/usr/bin/perl -w
# $x{a} v.s. $x{'a'}
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $X = { 'a' => 1, 'b' => 2, 'c' => 3 };
my $A = 'a';
my $B = 'b';
my $C = 'c';

sub usesq { return $X->{'a'} + $X->{'b'} + $X->{'c'}; }
sub notsq { return $X->{a} + $X->{b} + $X->{c}; }
sub usesv { return $X->{$A} + $X->{$B} + $X->{$C}; }

is( usesq(), 6 );
is( notsq(), 6 );
is( usesv(), 6 );

cmpthese(500000, { 
	'Use single quote' => sub { usesq(); },
	'Not single quote' => sub { notsq(); },
	'Use scalar value' => sub { usesv(); },
});

__END__

* PowerBookG4/perl 5.8.8
                     Rate Use scalar value Not single quote Use single quote
Use scalar value 574713/s               --              -0%              -3%
Not single quote 574713/s               0%               --              -3%
Use single quote 595238/s               4%               4%               --

* PowerBookG4/perl 5.10.0
                     Rate Use single quote Use scalar value Not single quote
Use single quote 431034/s               --              -0%              -3%
Use scalar value 431034/s               0%               --              -3%
Not single quote 442478/s               3%               3%               --

* PowerBookG4/perl 5.12.0
                     Rate Use scalar value Use single quote Not single quote
Use scalar value 458716/s               --              -4%              -5%
Use single quote 476190/s               4%               --              -1%
Not single quote 480769/s               5%               1%               --

* Ubuntu 8.04 LTS/perl 5.10.1
                      Rate Use single quote Use scalar value Not single quote
Use single quote  847458/s               --              -7%             -25%
Use scalar value  909091/s               7%               --             -20%
Not single quote 1136364/s              34%              25%               --


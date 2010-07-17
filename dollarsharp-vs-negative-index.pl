#!/usr/bin/perl -w
# $_[$#}] v.s. $_[-1]
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @ARRAY = ( 0..99 );
sub dollarsharp { return $ARRAY[ $#ARRAY ]; }
sub negativeidx { return $ARRAY[-1]; }

is( dollarsharp(), 99 );
is( negativeidx(), 99 );

cmpthese(1000000, { 
	'$x[$#x]' => sub { &dollarsharp() }, 
	'$x[-1]' => sub { negativeidx() }, 
});

__END__

* PowerBookG4/perl 5.8.8
             Rate $x[$#x]  $x[-1]
$x[$#x]  961538/s      --    -26%
$x[-1]  1298701/s     35%      --

* PowerBookG4/perl 5.10.0
             Rate $x[$#x]  $x[-1]
$x[$#x]  735294/s      --    -34%
$x[-1]  1111111/s     51%      --

* PowerBookG4/perl 5.12.0
             Rate $x[$#x]  $x[-1]
$x[$#x]  781250/s      --    -26%
$x[-1]  1052632/s     35%      --


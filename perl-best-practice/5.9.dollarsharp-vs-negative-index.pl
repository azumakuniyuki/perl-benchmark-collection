#!/usr/bin/perl -w
# $_[$#}] v.s. $_[-1]
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @Data = ( 0..99 );
sub dollarsharp { return $Data[ $#Data ] + $Data[ $#Data - 1 ]; }
sub negativeidx { return $Data[-1] + $Data[-2]; }

is( dollarsharp(), 197 );
is( negativeidx(), 197 );

cmpthese(1000000, { 
	'$x[$#x]' => sub { &dollarsharp() }, 
	'$x[-1]' => sub { negativeidx() }, 
});

__END__

* PowerBookG4/perl 5.8.8
            Rate $x[$#x]  $x[-1]
$x[$#x] 558659/s      --    -42%
$x[-1]  961538/s     72%      --

* PowerBookG4/perl 5.10.0
            Rate $x[$#x]  $x[-1]
$x[$#x] 374532/s      --    -49%
$x[-1]  729927/s     95%      --

* PowerBookG4/perl 5.12.0
            Rate $x[$#x]  $x[-1]
$x[$#x] 448430/s      --    -39%
$x[-1]  735294/s     64%      --


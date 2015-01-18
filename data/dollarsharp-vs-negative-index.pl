#!/usr/bin/perl -w
# $_[$#}] v.s. $_[-1]
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $L = [ 0 .. 1023 ];
sub dollarsharp { return $L->[ $#$L ] + $L->[ $#$L - 1 ]; }
sub negativeidx { return $L->[-1] + $L->[-2]; }

is( dollarsharp(), 2045 );
is( negativeidx(), 2045 );

cmpthese(2000000, { 
    '$x->[$#x]' => sub { dollarsharp() }, 
    '$x->[-1]' => sub { negativeidx() }, 
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
               Rate $x->[$#x]  $x->[-1]
$x->[$#x] 2040816/s        --      -39%
$x->[-1]  3333333/s       63%        --

* Mac OS X 10.7.5/Perl 5.14.2
               Rate $x->[$#x]  $x->[-1]
$x->[$#x] 1834862/s        --      -43%
$x->[-1]  3225806/s       76%        --

* OpenBSD 5.2/Perl 5.12.2
               Rate $x->[$#x]  $x->[-1]
$x->[$#x]  729927/s        --      -37%
$x->[-1]  1156069/s       58%        --

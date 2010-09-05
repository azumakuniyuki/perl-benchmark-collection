#!/usr/bin/perl -w
# qw(a b c) v.s. ( 'a', 'b', 'c' )
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub useqw { return join('.',qw(a b c d e f g)); }
sub usesq { return join('.','a','b','c','d','e','f','g'); }

is( useqw(), 'a.b.c.d.e.f.g' );
is( usesq(), 'a.b.c.d.e.f.g' );

cmpthese(500000, { 
	'qw(a b c d)' => sub { &useqw() }, 
	"'a','b','c'" => sub { &usesq() }, 
});

__END__

* PowerBookG4/Perl 5.8.8
                Rate qw(a b c d) 'a','b','c'
qw(a b c d) 438596/s          --         -3%
'a','b','c' 450450/s          3%          --

* PowerBookG4/Perl 5.10.0
                Rate qw(a b c d) 'a','b','c'
qw(a b c d) 340136/s          --         -1%
'a','b','c' 344828/s          1%          --

* PowerBookG4/Perl 5.12.0
                Rate qw(a b c d) 'a','b','c'
qw(a b c d) 403226/s          --         -1%
'a','b','c' 406504/s          1%          --

* Ubuntu 8.04 LTS/perl 5.10.1
                Rate qw(a b c d) 'a','b','c'
qw(a b c d) 694444/s          --         -1%
'a','b','c' 704225/s          1%          --


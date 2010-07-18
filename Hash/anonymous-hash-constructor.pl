#!/usr/bin/perl -w
# +{} v.s. {}
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub plusbrace { my $x = shift; my $y = +{ 'x' => $x }; my $z = +{ 'z' => $y->{x} }; return +{ 'y' => ($y->{x} + $z->{z}) }; }
sub braceonly { my $x = shift; my $y =  { 'x' => $x }; my $z =  { 'z' => $y->{x} }; return  { 'y' => ($y->{x} + $z->{z}) }; }

isa_ok( plusbrace(1), q|HASH| );
isa_ok( braceonly(1), q|HASH| );

cmpthese(500000, { 
	'+{}' => sub { &plusbrace(1) }, 
	' {}' => sub { &braceonly(1) }, 
});

__END__

* PowerBookG4/perl 5.8.8
        Rate +{}  {}
+{} 314465/s  -- -4%
 {} 328947/s  5%  --

* PowerBookG4/perl 5.10.0
        Rate  {} +{}
 {} 226244/s  -- -1%
+{} 228311/s  1%  --

* PowerBookG4/perl 5.12.0
        Rate  {} +{}
 {} 282486/s  -- -2%
+{} 289017/s  2%  --

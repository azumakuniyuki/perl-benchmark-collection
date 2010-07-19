#!/usr/bin/perl -w
# Create: for v.s. map
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use List::Util;

my $Data = [ 0..99 ];
sub createbyforloop
{
	my $x = shift();
	my $y = [];
	for my $z ( @$x ){ push( @$y, int sqrt $z ); }
	return $y;
}

sub createbymapfunc
{
	my $x = shift();
	my $y = [ map { int sqrt($_) } @$x ];
}

sub createbyluapply
{
	my $x = shift();
	my $y = [ List::Util::apply { int sqrt($_) } @$x ];
}

my $f = createbyforloop($Data);
my $m = createbymapfunc($Data);
my $a = createbyluapply($Data);
is( $f->[-1], 9 );
is( $m->[-1], 9 );
is( $a->[-1], 9 );

cmpthese(10000, { 
	'for()' => sub { &createbyforloop($Data) }, 
	'map{}' => sub { &createbymapfunc($Data) }, 
	'apply' => sub { &createbyluapply($Data) }, 
});

__END__

* PowerBookG4/perl 5.8.8
         Rate for() map{}
for()  9091/s    --  -12%
map{} 10309/s   13%    --

* PowerBookG4/perl 5.10.0
        Rate for() map{}
for() 6579/s    --  -12%
map{} 7519/s   14%    --

* PowerBookG4/perl 5.12.0
        Rate for() map{}
for() 7752/s    --   -5%
map{} 8130/s    5%    --


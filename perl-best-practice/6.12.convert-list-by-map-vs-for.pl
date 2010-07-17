#!/usr/bin/perl -w
# Convert: for v.s. map
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @Data = ( 0..99 );
sub convertbyforloop
{
	my $x = shift();
	for my $y ( @$x ){ $y = int sqrt($y); }
}

sub convertbymapfunc
{
	my $x = shift();
	@$x = map { int sqrt($_) } @$x;
}

my @X = @Data; convertbyforloop(\@X);
my @Y = @Data; convertbymapfunc(\@Y);
is( $X[-1], 9 ); @X = @Data;
is( $Y[-1], 9 ); @Y = @Data;

cmpthese(10000, { 
	'for()' => sub { &convertbyforloop(\@X) }, 
	'map{}' => sub { &convertbymapfunc(\@Y) }, 
});

__END__

* PowerBookG4/perl 5.8.8
         Rate map{} for()
map{}  8197/s    --  -50%
for() 16393/s  100%    --

* PowerBookG4/perl 5.10.0
         Rate map{} for()
map{}  5618/s    --  -54%
for() 12195/s  117%    --

* PowerBookG4/perl 5.12.0
         Rate map{} for()
map{}  6410/s    --  -53%
for() 13514/s  111%    --

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

sub convertbymapitself
{
	my $x = shift();
	map { $_ = int sqrt($_) } @$x;
}

my @X = @Data; convertbyforloop(\@X);
my @Y = @Data; convertbymapfunc(\@Y);
my @Z = @Data; convertbymapitself(\@Z);
is( $X[-1], 9 ); @X = @Data;
is( $Y[-1], 9 ); @Y = @Data;
is( $Z[-1], 9 ); @Z = @Data;

cmpthese(10000, { 
	'for my $x(..)' => sub { &convertbyforloop(\@X) }, 
	'@x = map{...}' => sub { &convertbymapfunc(\@Y) }, 
	'map{$_ = ...}' => sub { &convertbymapitself(\@Z) }, 
});

__END__

* PowerBookG4/perl 5.8.8
                 Rate @x = map{...} map{$_ = ...} for my $x(..)
@x = map{...}  7937/s            --           -9%          -52%
map{$_ = ...}  8696/s           10%            --          -48%
for my $x(..) 16667/s          110%           92%            --

* PowerBookG4/perl 5.10.0
                 Rate @x = map{...} map{$_ = ...} for my $x(..)
@x = map{...}  5650/s            --          -10%          -53%
map{$_ = ...}  6250/s           11%            --          -47%
for my $x(..) 11905/s          111%           90%            --

* PowerBookG4/perl 5.12.0
                 Rate @x = map{...} map{$_ = ...} for my $x(..)
@x = map{...}  6329/s            --           -4%          -53%
map{$_ = ...}  6579/s            4%            --          -51%
for my $x(..) 13514/s          114%          105%            --


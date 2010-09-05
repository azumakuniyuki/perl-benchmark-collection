#!/usr/bin/perl -w
# Convert: for v.s. map
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @Data = ( 0..99 );
sub convertbyforeach
{
	my $x = shift();
	foreach my $y ( @$x ){ $y = int sqrt($y); }
}

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

my @W = @Data; convertbyforeach(\@W);
my @X = @Data; convertbyforloop(\@X);
my @Y = @Data; convertbymapfunc(\@Y);
my @Z = @Data; convertbymapitself(\@Z);
is( $W[-1], 9 ); @W = @Data;
is( $X[-1], 9 ); @X = @Data;
is( $Y[-1], 9 ); @Y = @Data;
is( $Z[-1], 9 ); @Z = @Data;

cmpthese(10000, { 
	'foreach my $x' => sub { &convertbyforeach(\@W) },
	'for my $x(..)' => sub { &convertbyforloop(\@X) }, 
	'@x = map{...}' => sub { &convertbymapfunc(\@Y) }, 
	'map{$_ = ...}' => sub { &convertbymapitself(\@Z) }, 
});

__END__

* PowerBookG4/perl 5.8.8
                 Rate @x = map{...} map{$_ = ...} for my $x(..) foreach my $x
@x = map{...}  7692/s            --          -11%          -53%          -53%
map{$_ = ...}  8621/s           12%            --          -47%          -47%
for my $x(..) 16393/s          113%           90%            --            0%
foreach my $x 16393/s          113%           90%            0%            --

* PowerBookG4/perl 5.10.0
                 Rate @x = map{...} map{$_ = ...} for my $x(..) foreach my $x
@x = map{...}  5848/s            --           -9%          -49%          -51%
map{$_ = ...}  6452/s           10%            --          -44%          -46%
for my $x(..) 11494/s           97%           78%            --           -5%
foreach my $x 12048/s          106%           87%            5%            --

* PowerBookG4/perl 5.12.0
                 Rate @x = map{...} map{$_ = ...} for my $x(..) foreach my $x
@x = map{...}  6369/s            --           -4%          -53%          -54%
map{$_ = ...}  6667/s            5%            --          -51%          -51%
for my $x(..) 13514/s          112%          103%            --           -1%
foreach my $x 13699/s          115%          105%            1%            --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
            (warning: too few iterations for a reliable count)
                 Rate map{$_ = ...} @x = map{...} for my $x(..) foreach my $x
map{$_ = ...} 15152/s            --           -2%          -61%          -61%
@x = map{...} 15385/s            2%            --          -60%          -60%
for my $x(..) 38462/s          154%          150%            --            0%
foreach my $x 38462/s          154%          150%            0%            --


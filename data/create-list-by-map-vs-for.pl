#!/usr/bin/perl -w
# Create: for v.s. map
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub useforloop {
    my $x = shift;
    my $y = [];

    for my $z ( @$x ) { 
        push @$y, int sqrt $z; 
    }
    return $y;
}

sub usemapfunc1 {
    my $x = shift;
    my $y = [];
    $y = [ map { int sqrt($_) } @$x ];
    return $y;
}

sub usemapfunc2 {
    my $x = shift;
    my $y = [];
    map { push @$y, int sqrt($_) } @$x;
    return $y;
}

my $L = [ 0..99 ];
my $R = [];

$R = useforloop($L);  is( $R->[-1], 9 );
$R = usemapfunc1($L); is( $R->[-1], 9 );
$R = usemapfunc2($L); is( $R->[-1], 9 );

cmpthese(90000, { 
    'for(){ push @x .. }' => sub { &useforloop($L) }, 
    '$x = [ map {...;} ]' => sub { &usemapfunc1($L) }, 
    'map { push @x ... }' => sub { &usemapfunc2($L) }, 
});

__END__


* Mac OS X 10.9.5/Perl 5.20.1
                       Rate for(){ push @x .. } map { push @x ... } $x = [ map {...;} ]
for(){ push @x .. } 39130/s                  --                 -4%                 -6%
map { push @x ... } 40909/s                  5%                  --                 -1%
$x = [ map {...;} ] 41475/s                  6%                  1%                  --

* Mac OS X 10.7.5/Perl 5.14.2
                       Rate map { push @x ... } $x = [ map {...;} ] for(){ push @x .. }
map { push @x ... } 45918/s                  --                 -1%                 -2%
$x = [ map {...;} ] 46154/s                  1%                  --                 -2%
for(){ push @x .. } 46875/s                  2%                  2%                  --

* OpenBSD 5.2/Perl 5.12.2
                       Rate for(){ push @x .. } map { push @x ... } $x = [ map {...;} ]
for(){ push @x .. } 15280/s                  --                 -3%                -15%
map { push @x ... } 15679/s                  3%                  --                -12%
$x = [ map {...;} ] 17893/s                 17%                 14%                  --


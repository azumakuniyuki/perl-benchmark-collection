#!/usr/bin/perl -w
# Regular Expression: (a|b|c) v.s. 3 Times
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $S = join( q{}, ( 'a'..'z' ) );
my $H = q{From: hoge@example.jp}."\n".q{Return-Path: <postmaster@example.jp>}."\n".q{Reply-To: fuga@example.jp}."\n";

sub usepipes1
{ 
	my $x = 0;
	$x = 1 if( $S =~ m{(?:dns|ntp|xyz|)} );
	return($x);
}

sub usepipes2
{
	my $y = $H;
	$y =~ s{^(From|Return-Path|Reply-To):[ ].+$}{$1: ****@*****}gim;
	return($y);
}

sub do3times1
{
	my $x = 0;
	$x = 1 if( $S =~ m{dns} );
	$x = 1 if( $S =~ m{ntp} );
	$x = 1 if( $S =~ m{xyz} );
	return($x);
}

sub do3times2
{
	my $y = $H;
	$y =~ s{^(From):[ ].+$}{$1: ****@*****}gim;
	$y =~ s{^(Return-Path):[ ].+$}{$1: ****@*****}gim;
	$y =~ s{^(Reply-To):[ ].+$}{$1: ****@*****}gim;
	return($y);
}

ok( usepipes1() );
ok( do3times1() );
ok( usepipes2() );
ok( do3times2() );

cmpthese(200000, { 
	'UsePipe(m//)' => sub { &usepipes1() }, 
	'3 Times(m//)' => sub { &do3times1() }, 
});

cmpthese(200000, { 
	'UsePipe(s//)' => sub { &usepipes2() }, 
	'3 Times(s//)' => sub { &do3times2() }, 
});

__END__

* PowerBookG4/perl 5.10.0

                 Rate 3 Times(m//) UsePipe(m//)
3 Times(m//) 357143/s           --         -23%
UsePipe(m//) 465116/s          30%           --

                Rate 3 Times(s//) UsePipe(s//)
3 Times(s//) 23229/s           --         -25%
UsePipe(s//) 30864/s          33%           --


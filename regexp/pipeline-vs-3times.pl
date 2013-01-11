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
	$x = 1 if $S =~ m{(?:dns|ntp|xyz|)};
	return $x;
}

sub usepipes2
{
	my $y = $H;
	$y =~ s{^(From|Return-Path|Reply-To):[ ].+$}{$1: ****@*****}gim;
	return $y;
}

sub do3times1
{
	my $x = 0;
	$x = 1 if $S =~ m{dns};
	$x = 1 if $S =~ m{ntp};
	$x = 1 if $S =~ m{xyz};
	return $x;
}

sub do3times2
{
	my $y = $H;
	$y =~ s{^(From):[ ].+$}{$1: ****@*****}gim;
	$y =~ s{^(Return-Path):[ ].+$}{$1: ****@*****}gim;
	$y =~ s{^(Reply-To):[ ].+$}{$1: ****@*****}gim;
	return $y;
}

ok( usepipes1() );
ok( do3times1() );
ok( usepipes2() );
ok( do3times2() );

cmpthese(800000, { 
	'UsePipe(m//)' => sub { &usepipes1() }, 
	'3 Times(m//)' => sub { &do3times1() }, 
});
print "\n";
cmpthese(800000, { 
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


* PowerBookG4/perl 5.12.0
                 Rate 3 Times(m//) UsePipe(m//)
3 Times(m//) 363636/s           --         -20%
UsePipe(m//) 454545/s          25%           --

                Rate 3 Times(s//) UsePipe(s//)
3 Times(s//) 31746/s           --         -39%
UsePipe(s//) 51948/s          64%           --


* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
            (warning: too few iterations for a reliable count)
                  Rate 3 Times(m//) UsePipe(m//)
3 Times(m//)  740741/s           --         -26%
UsePipe(m//) 1000000/s          35%           --

                Rate 3 Times(s//) UsePipe(s//)
3 Times(s//) 65789/s           --         -30%
UsePipe(s//) 93897/s          43%           --


* Mac OS X 10.7.5/Perl 5.14.2
                  Rate 3 Times(m//) UsePipe(m//)
3 Times(m//) 1379310/s           --         -21%
UsePipe(m//) 1739130/s          26%           --

                 Rate 3 Times(s//) UsePipe(s//)
3 Times(s//) 104439/s           --         -27%
UsePipe(s//) 143113/s          37%           --


* OpenBSD 5.2/Perl 5.12.2
                 Rate 3 Times(m//) UsePipe(m//)
3 Times(m//) 606061/s           --         -18%
UsePipe(m//) 740741/s          22%           --

                Rate 3 Times(s//) UsePipe(s//)
3 Times(s//) 34159/s           --         -37%
UsePipe(s//) 53836/s          58%           --

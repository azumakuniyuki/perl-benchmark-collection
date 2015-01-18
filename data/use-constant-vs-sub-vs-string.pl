#!/usr/bin/perl -w
# $var v.s. use constant v.s. sub {} v.s. 'string'
use Benchmark qw(:all);
use Test::More 'no_plan';

my $W = 'STRING';
use constant X => 'STRING';
sub Y() { 'STRING' };

sub variable__ { my $w = shift; return $w.$W.$W.$w; }
sub constant__ { my $x = shift; return $x.X.X.$x; }
sub subroutine { my $y = shift; return $y.Y.Y.$y; }
sub stringtext { my $z = shift; return $z.'STRINGSTRING'.$z; }

is( variable__(1), '1STRINGSTRING1' );
is( constant__(1), '1STRINGSTRING1' );
is( subroutine(1), '1STRINGSTRING1' );
is( stringtext(1), '1STRINGSTRING1' );

cmpthese(1200000, { 
    'my $variable' => sub { &variable__(2) }, 
    'use constant' => sub { &constant__(2) }, 
    'subroutine()' => sub { &subroutine(2) }, 
    'stringstring' => sub { &subroutine(2) }, 
});

__END__


* Mac OS X 10.9.5/Perl 5.20.1
                  Rate stringstring use constant subroutine() my $variable
stringstring 2448980/s           --          -0%          -2%          -4%
use constant 2448980/s           0%           --          -2%          -4%
subroutine() 2500000/s           2%           2%           --          -2%
my $variable 2553191/s           4%           4%           2%           --

* PowerBookG4/Perl 5.8.8
                 Rate use constant my $variable subroutine() stringstring
use constant 595238/s           --          -2%          -2%          -2%
my $variable 609756/s           2%           --           0%           0%
subroutine() 609756/s           2%           0%           --           0%
stringstring 609756/s           2%           0%           0%           --

* PowerBookG4/Perl 5.10.0
                 Rate my $variable stringstring subroutine() use constant
my $variable 431034/s           --          -4%          -6%          -7%
stringstring 450450/s           5%           --          -2%          -3%
subroutine() 458716/s           6%           2%           --          -1%
use constant 462963/s           7%           3%           1%           --

* PowerBookG4/Perl 5.12.0
                 Rate use constant my $variable stringstring subroutine()
use constant 431034/s           --          -2%          -7%          -8%
my $variable 438596/s           2%           --          -5%          -6%
stringstring 462963/s           7%           6%           --          -1%
subroutine() 467290/s           8%           7%           1%           --

* Ubuntu 8.04 LTS/perl 5.10.1
                 Rate my $variable subroutine() stringstring use constant
my $variable 781250/s           --         -11%         -13%         -16%
subroutine() 877193/s          12%           --          -2%          -5%
stringstring 892857/s          14%           2%           --          -4%
use constant 925926/s          19%           6%           4%           --

* Mac OS X 10.7.5/Perl 5.14.2
                  Rate stringstring subroutine() use constant my $variable
stringstring 1764706/s           --          -8%         -14%         -18%
subroutine() 1914894/s           9%           --          -6%         -11%
use constant 2045455/s          16%           7%           --          -5%
my $variable 2142857/s          21%          12%           5%           --

* OpenBSD 5.2/Perl 5.12.2
                 Rate my $variable use constant stringstring subroutine()
my $variable 708661/s           --          -2%          -6%          -7%
use constant 720000/s           2%           --          -4%          -6%
stringstring 750000/s           6%           4%           --          -2%
subroutine() 762712/s           8%           6%           2%           --

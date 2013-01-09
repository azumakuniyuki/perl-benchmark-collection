#!/usr/bin/perl -w
# ! v.s. 0
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub exclamation { my $x = shift; return 1 if ! $x; }
sub isequalsto0 { my $x = shift; return 1 if $x == 0; }

ok( exclamation(0) );
ok( isequalsto0(0) );

cmpthese(1500000, { 
	'! $x' =>  sub { exclamation(0) }, 
	'$x==0' => sub { isequalsto0(0) }, 
});

__END__

* PowerBookG4/perl 5.8.8
          Rate $x==0  ! $x
$x==0 862069/s    --   -3%
! $x  892857/s    4%    --

* PowerBookG4/perl 5.10.0
          Rate $x==0  ! $x
$x==0 704225/s    --   -3%
! $x  724638/s    3%    --

* PowerBookG4/perl 5.12.0
          Rate  ! $x $x==0
! $x  666667/s    --   -0%
$x==0 666667/s    0%    --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
            (warning: too few iterations for a reliable count)
           Rate $x==0  ! $x
$x==0 1851852/s    --   -4%
! $x  1923077/s    4%    --

* Mac OS X 10.7.5/Perl 5.14.2
           Rate  ! $x $x==0
! $x  2542373/s    --   -7%
$x==0 2727273/s    7%    --

* OpenBSD 5.2/Perl 5.12.2
           Rate $x==0  ! $x
$x==0 1119403/s    --   -5%
! $x  1181102/s    6%    --


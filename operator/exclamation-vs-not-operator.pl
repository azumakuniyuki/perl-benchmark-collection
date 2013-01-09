#!/usr/bin/perl -w
# ! v.s. not operator
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub exclamation { my $x = shift; return 1 if ! $x; }
sub notoperator { my $x = shift; return 1 if not $x; }

ok( exclamation(0) );
ok( notoperator(0) );

cmpthese(1500000, { 
	'! $_' => sub { &exclamation(0) }, 
	'not $_' => sub { &notoperator(0) }, 
});

__END__

* PowerBookG4/perl 5.8.8
           Rate not $_   ! $_
not $_ 877193/s     --    -2%
! $_   892857/s     2%     --

* PowerBookG4/perl 5.10.0
           Rate not $_   ! $_
not $_ 724638/s     --    -4%
! $_   757576/s     5%     --

* PowerBookG4/perl 5.12.0
           Rate not $_   ! $_
not $_ 675676/s     --    -3%
! $_   694444/s     3%     --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
            (warning: too few iterations for a reliable count)
            Rate not $_   ! $_
not $_ 1470588/s     --    -9%
! $_   1612903/s    10%     --

* Mac OS X 10.7.5/Perl 5.14.2
            Rate not $_   ! $_
not $_ 2884615/s     --    -8%
! $_   3125000/s     8%     --

* OpenBSD 5.2/Perl 5.12.2
            Rate not $_   ! $_
not $_ 1079137/s     --    -2%
! $_   1102941/s     2%     --

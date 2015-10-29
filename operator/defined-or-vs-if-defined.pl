#!/usr/bin/perl
# //= v.s. ||=
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub definedor {
    my( $x, $y ) = @_;
    my $z = $x // $y;
    return 1 if $z == 0;
}

sub ifdefined {
    my( $x, $y ) = @_;
    my $z = defined $x ? $x : $y;
    return 1 if $z == 0;
}

ok( definedor(0,1) );
ok( ifdefined(0,1) );

cmpthese( 1200000, { 
    'defined-or' => sub { definedor(0,1) },
    'if-defined' => sub { ifdefined(0,1) },
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
                Rate if-defined defined-or
if-defined 1935484/s         --        -6%
defined-or 2068966/s         7%         --

* MacBook Air/perl 5.14.2
                Rate if-defined defined-or
if-defined 1666667/s         --       -11%
defined-or 1875000/s        12%         --

* Ubuntu/Perl 5.12.3
                Rate if-defined defined-or
if-defined 1153846/s         --        -9%
defined-or 1267606/s        10%         --

* OpenBSD 5.2/Perl 5.12.2
               Rate if-defined defined-or
if-defined 743802/s         --        -2%
defined-or 756303/s         2%         --

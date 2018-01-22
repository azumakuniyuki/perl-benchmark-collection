#!/usr/bin/perl -w
# m/Fwd?/i vs. m/[Ff][Ww][Dd]?/
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $v = 'NekoNyaan';

sub eqoperator {
    return 1 if $v eq 'NekoNyaan';
}

sub regularexp { 
    return 1 if $v =~ /\ANekoNyaan\z/;
}

is( eqoperator(), 1 );
is( regularexp(), 1 );

cmpthese(4000000, { 
    '$v eq "......."' => sub { &eqoperator() }, 
    '$v =~ /\A...\z/' => sub { &regularexp() }, 
});

__END__

ok 1
ok 2
                     Rate $v =~ /\A...\z/ $v eq "......."
$v =~ /\A...\z/ 3076923/s              --            -48%
$v eq "......." 5970149/s             94%              --
1..2
perl regexp-with-az-vs-eq-operator.pl  4.83s user 0.02s system 99% cpu 4.865 total

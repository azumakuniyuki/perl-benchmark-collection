#!/usr/bin/perl -w
# m/Fwd?/i vs. m/[Ff][Ww][Dd]?/
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $v = 'NekoNyaan';

sub index1 { return 1 if index($v, 'NekoNyaan') == 0 }
sub regex1 { return 1 if $v =~ /\ANekoNyaan\z/ }

is( index1(), 1 );
is( regex1(), 1 );

cmpthese(4000000, { 
    'index(NekoNyaan)'     => sub { &index1 },
    'regex/\ANekoNyaan\z/' => sub { &regex1 },
});

sub index2 { return 1 if index($v, 'Neko') == 0 }
sub regex2 { return 1 if $v =~ /\ANeko/ }

is( index2(), 1 );
is( regex2(), 1 );

cmpthese(4000000, { 
    'index(Neko)'   => sub { &index2 },
    'regex/\ANeko/' => sub { &regex2 },
});

__END__

ok 1
ok 2
                     Rate $v =~ /\A...\z/ $v eq "......."
$v =~ /\A...\z/ 3076923/s              --            -48%
$v eq "......." 5970149/s             94%              --
1..2
perl regexp-with-az-vs-eq-operator.pl  4.83s user 0.02s system 99% cpu 4.865 total

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
                          Rate regex/\ANekoNyaan\z/     index(NekoNyaan)
regex/\ANekoNyaan\z/ 2684564/s                   --                 -44%
index(NekoNyaan)     4761905/s                  77%                   --
ok 3
ok 4
                   Rate regex/\ANeko/   index(Neko)
regex/\ANeko/ 2877698/s            --          -40%
index(Neko)   4819277/s           67%            --
1..4
perl regexp/regexp-vs-index.pl  10.75s user 0.07s system 99% cpu 10.908 total

#!/usr/bin/perl -w
# m/Fwd?/i vs. m/[Ff][Ww][Dd]?/
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $v = 'NekoNyaan';
printf("%s\n", $^V);

sub index0 { return 1 if index($v, 'NekoNyaan') == 0 }
sub indexr { return 1 if rindex($v, 'NekoNyaan', 0) == 0 }
is( index0(), 1 );
is( indexr(), 1 );
cmpthese(4000000, { 
    'index(NekoNyaan)'     => sub { &index0 },
    'rindex(NekoNyaan)'    => sub { &indexr },
});


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

sub index3 { return 1 if rindex($v, 'NekoNyaan', 0) == 0 }
sub regex3 { return 1 if $v =~ /\ANekoNyaan\z/ }
is( index3(), 1 );
is( regex3(), 1 );
cmpthese(4000000, { 
    'rindex(NekoNyaan)'    => sub { &index3 },
    'regex/\ANekoNyaan\z/' => sub { &regex3 },
});

sub index4 { return 1 if rindex($v, 'Neko', 0) == 0 }
sub regex4 { return 1 if $v =~ /\ANeko/ }
is( index4(), 1 );
is( regex4(), 1 );
cmpthese(4000000, { 
    'rindex(Neko)'  => sub { &index4 },
    'regex/\ANeko/' => sub { &regex4 },
});

__END__
v5.22.1
ok 1
ok 2
                       Rate  index(NekoNyaan) rindex(NekoNyaan)
index(NekoNyaan)  4819277/s                --               -7%
rindex(NekoNyaan) 5194805/s                8%                --
ok 3
ok 4
                          Rate regex/\ANekoNyaan\z/     index(NekoNyaan)
regex/\ANekoNyaan\z/ 2614379/s                   --                 -49%
index(NekoNyaan)     5128205/s                  96%                   --
ok 5
ok 6
                   Rate regex/\ANeko/   index(Neko)
regex/\ANeko/ 2898551/s            --          -46%
index(Neko)   5333333/s           84%            --
ok 7
ok 8
                          Rate regex/\ANekoNyaan\z/    rindex(NekoNyaan)
regex/\ANekoNyaan\z/ 2649007/s                   --                 -46%
rindex(NekoNyaan)    4938272/s                  86%                   --
ok 9
ok 10
                   Rate regex/\ANeko/  rindex(Neko)
regex/\ANeko/ 2721088/s            --          -50%
rindex(Neko)  5479452/s          101%            --
1..10


v5.26.0
ok 1
ok 2
                       Rate  index(NekoNyaan) rindex(NekoNyaan)
index(NekoNyaan)  5882353/s                --              -15%
rindex(NekoNyaan) 6896552/s               17%                --
ok 3
ok 4
                          Rate regex/\ANekoNyaan\z/     index(NekoNyaan)
regex/\ANekoNyaan\z/ 3174603/s                   --                 -51%
index(NekoNyaan)     6451613/s                 103%                   --
ok 5
ok 6
                   Rate regex/\ANeko/   index(Neko)
regex/\ANeko/ 3478261/s            --          -44%
index(Neko)   6250000/s           80%            --
ok 7
ok 8
                          Rate regex/\ANekoNyaan\z/    rindex(NekoNyaan)
regex/\ANekoNyaan\z/ 3125000/s                   --                 -59%
rindex(NekoNyaan)    7692308/s                 146%                   --
ok 9
ok 10
                   Rate regex/\ANeko/  rindex(Neko)
regex/\ANeko/ 3252033/s            --          -50%
rindex(Neko)  6557377/s          102%            --
1..10
/opt/bin/perl regexp/regexp-vs-index.pl  19.32s user 0.12s system 99% cpu 19.572 total


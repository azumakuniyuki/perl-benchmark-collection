#!/usr/bin/perl -w
# m/Fwd?/i vs. m/[Ff][Ww][Dd]?/
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $v = 'NekoNyaan';

sub eqoperator { return 1 if( $v eq 'NekoChan' || $v eq 'NoraNyaan' ); return 0 }
sub regularexp { return 1 if $v =~ /\A(?:NekoChan|NoraNyaan)\z/; return 0 }

is( eqoperator(), 0 );
is( regularexp(), 0 );

cmpthese(4000000, { 
    '$v eq ... || $v eq ...' => sub { &regularexp() }, 
    '$v =~ /\A(...|...)\z/'  => sub { &regularexp() }, 
});

__END__

ok 1
ok 2
                            Rate  $v =~ /\A(...|...)\z/ $v eq ... || $v eq ...
$v =~ /\A(...|...)\z/  3053435/s                     --                    -2%
$v eq ... || $v eq ... 3100775/s                     2%                     --
1..2
perl regexp/grouped-regexp-vs-eq-or-eq.pl  5.50s user 0.02s system 99% cpu 5.550 total

#!/usr/bin/perl -w
# $_[$#}] v.s. $_[-1]
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub useblock {
    my $x = shift;
    my $v = undef;
    BLOCK: {
        my $y = 'neko';
        my $z = 'nyan';
        $v = sprintf( "%s-%s-%s", $x, $y, $z );
    }
    return $v;
}

sub notblock {
    my $x = shift;
    my $v = undef;

    my $y = 'neko';
    my $z = 'nyan';
    $v = sprintf( "%s-%s-%s", $x, $y, $z );
    return $v;
}

is( useblock('22'), '22-neko-nyan' );
is( notblock('22'), '22-neko-nyan' );

cmpthese(2000000, { 
    'use block' => sub { useblock(2) }, 
    'not block' => sub { notblock(2) }, 
});

__END__
* Mac OS X 10.9.5/Perl 5.20.1
ok 1
ok 2
               Rate use block not block
use block  921659/s        --      -12%
not block 1052632/s       14%        --
1..2
perl data/block-or-no-block.pl  5.75s user 0.02s system 99% cpu 5.818 total

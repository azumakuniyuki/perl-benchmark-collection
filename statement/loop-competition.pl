#!/usr/bin/perl
# Loop Competition/ for, foreach, while
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @W = ( 1 .. (1<<10) );
my @X = ( 1 .. (1<<10) );
my @Y = ( 1 .. (1<<10) );
my @Z = ( 1 .. (1<<10) );
my $R = 146;

sub usegrep {
    my $x = 0;
    $x = grep { $_ % 7 == 0 } @W;
    return $x;
}

sub useforloop {
    my $x = 0;
    my $n = scalar @X;

    for( my $y = 0; $y < $n; $y++ ) {
        $x++ unless $X[$y] % 7;
    }
    return $x;
}

sub useforeach {
    my $x = 0;

    foreach my $y ( @Y ) {
        $x++ unless $y % 7;
    }
    return $x;
}

sub usewhile {
    my $x = 0;

    while( my $y = shift @Z ) {
        $x++ unless $y % 7;
    }
    return $x;
}

is( usegrep(), $R, 'grep {}' );
is( useforloop(), $R, 'for()' );
is( useforeach(), $R, 'foreach()' );
is( usewhile(), $R, 'while()' );

cmpthese( 180000, {
    'grep {}' => \&usegrep,
    'for()' => \&useforloop,
    'foreach()' => \&useforeach,
    'while()' => \&usewhile,
});

__END__


* Mac OS X 10.9.5/Perl 5.20.1
            (warning: too few iterations for a reliable count)
               Rate     for()   grep {} foreach()   while()
for()        6550/s        --      -36%      -37%     -100%
grep {}     10303/s       57%        --       -1%      -99%
foreach()   10363/s       58%        1%        --      -99%
while()   2000000/s    30433%    19311%    19200%        --

* Mac OS X 10.7.5/Perl 5.14.2
            (warning: too few iterations for a reliable count)
               Rate     for()   grep {} foreach()   while()
for()        6089/s        --      -39%      -42%     -100%
grep {}      9939/s       63%        --       -6%     -100%
foreach()   10582/s       74%        6%        --     -100%
while()   3600000/s    59020%    36120%    33920%        --

* OpenBSD 5.2/Perl 5.12.2
            (warning: too few iterations for a reliable count)
               Rate     for()   grep {} foreach()   while()
for()        2360/s        --       -7%      -36%     -100%
grep {}      2548/s        8%        --      -31%     -100%
foreach()    3676/s       56%       44%        --     -100%
while()   1384615/s    58562%    54231%    37569%        --


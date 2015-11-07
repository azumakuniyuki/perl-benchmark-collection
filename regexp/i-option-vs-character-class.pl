#!/usr/bin/perl -w
# m/Fwd?/i vs. m/[Ff][Ww][Dd]?/
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $X = 'Fwd: Neko nyaaaaan!!! ShiroNeko Nyanko Nyan Nyan Nyaaaan';

sub ignore_case { 
    my $x = shift;
    my $y = 0;

    $y++ if $x =~ m/\A\s*Fwd?:/i;
    $y++ if $x =~ m/Neko Nyaaaaa/i;
    $y++ if $x =~ m/shironeko nyanko/i;
    return $y;
}

sub char_class {
    my $x = shift;
    my $y = 0;

    $y++ if $x =~ m/\A\s*[Ff][Ww][Dd]?:/;
    $y++ if $x =~ m/[Nn]eko [Nn]yaaaaa/;
    $y++ if $x =~ m/[Ss]hiro[Nn]eko [Nn]yanko/;
    return $y;
}

is( ignore_case($X), 3 );
is( char_class($X),  3 );

cmpthese(900000, { 
    'm/Fwd?:/i' => sub { &ignore_case($X) }, 
    'm/[Ff][Ww]/' => sub { &char_class($X) }, 
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
ok 1
ok 2
                Rate m/[Ff][Ww]/   m/Fwd?:/i
m/[Ff][Ww]/ 535714/s          --        -12%
m/Fwd?:/i   612245/s         14%          --

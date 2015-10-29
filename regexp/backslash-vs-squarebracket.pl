#!/usr/bin/perl -w
# Regular Expression: [.] vs. \.
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $X = 'postmaster@test.of.sub.domain.example.jp';

sub backslash { 
    my $x = shift;
    my $r = qr/\Apostmaster\@test\.of\.sub\.domain\.example\.jp\z/;
    return 1 if $x =~ $r;
}

sub squarebracket {
    my $x = shift;
    my $r = qr/\Apostmaster[@]test[.]of[.]sub[.]domain[.]example[.]jp\z/;
    return 1 if $x =~ $r;
}

ok( backslash($X) );
ok( squarebracket($X) );

cmpthese(200000, { 
    'Backslash(\.)' => sub { &backslash($X) }, 
    'Square Bracket[.]' => sub { &squarebracket($X) }, 
});

__END__

* PowerBookG4/perl 5.8.8
                      Rate Square Bracket[.]     Backslash(\.)
Square Bracket[.] 162602/s                --               -7%
Backslash(\.)     173913/s                7%                --

* PowerBookG4/perl 5.10.0
                     Rate     Backslash(\.) Square Bracket[.]
Backslash(\.)     67568/s                --               -2%
Square Bracket[.] 68966/s                2%                --

* PowerBookG4/perl 5.12.0
                      Rate     Backslash(\.) Square Bracket[.]
Backslash(\.)     112360/s                --               -5%
Square Bracket[.] 118343/s                5%                --

* Ubuntu 10.04 LTS/perl 5.12.2
                      Rate     Backslash(\.) Square Bracket[.]
Backslash(\.)     350877/s                --               -4%
Square Bracket[.] 363636/s                4%                --

* Mac OS X 10.7.5/Perl 5.14.2
                      Rate     Backslash(\.) Square Bracket[.]
Backslash(\.)     370370/s                --               -4%
Square Bracket[.] 384615/s                4%                --

* OpenBSD 5.2/Perl 5.12.2
                      Rate     Backslash(\.) Square Bracket[.]
Backslash(\.)     147059/s                --               -1%
Square Bracket[.] 148148/s                1%                --

* Mac OS X 10.9.5/Perl 5.20.1
                      Rate     Backslash(\.) Square Bracket[.]
Backslash(\.)     370370/s                --               -6%
Square Bracket[.] 392157/s                6%                --
1..2

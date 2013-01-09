#!/usr/bin/perl -w
# $x{a} vs. $x{'a'} vs. $x{"a"} vs. $x{$a}
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $X = { 'a' => 1, 'b' => 2, 'c' => 3 };
my $A = 'a';
my $B = 'b';
my $C = 'c';
my $D = 'd';

sub usesq { return $X->{'a'} + $X->{'b'} + $X->{'c'}; }
sub notsq { return $X->{a} + $X->{b} + $X->{c}; }
sub usesv { return $X->{ $A } + $X->{ $B } + $X->{ $C }; }
sub usedq { return $X->{"a"} + $X->{"b"} + $X->{"c"}; }

is( usesq(), 6 );
is( notsq(), 6 );
is( usesv(), 6 );
is( usedq(), 6 );

cmpthese(2000000, { 
	q|Single quote/$x->{'y'}| => sub { usesq(); },
	q|Single quote/$x->{ y }| => sub { notsq(); },
	q|Scalar value/$x->{$Y }| => sub { usesv(); },
	q|Double quote/$x->{"y"}| => sub { usedq(); },
});

__END__

* PowerBookG4/perl 5.8.8
                     Rate Use double quote Use single quote Not single quote Use scalar value
Use double quote 526316/s               --              -0%              -1%              -7%
Use single quote 526316/s               0%               --              -1%              -7%
Not single quote 531915/s               1%               1%               --              -6%
Use scalar value 568182/s               8%               8%               7%               --

* PowerBookG4/perl 5.10.0
                     Rate Use scalar value Not single quote Use double quote Use single quote
Use scalar value 431034/s               --              -2%              -4%              -4%
Not single quote 438596/s               2%               --              -3%              -3%
Use double quote 450450/s               5%               3%               --              -0%
Use single quote 450450/s               5%               3%               0%               --

* PowerBookG4/perl 5.12.0
                     Rate Use scalar value Use single quote Use double quote Not single quote
Use scalar value 458716/s               --              -4%              -6%              -6%
Use single quote 476190/s               4%               --              -2%              -2%
Use double quote 485437/s               6%               2%               --               0%
Not single quote 485437/s               6%               2%               0%               --

* Ubuntu 8.04 LTS/perl 5.10.1
                      Rate Use double quote Use single quote Not single quote Use scalar value
Use double quote  980392/s               --              -0%              -2%              -8%
Use single quote  980392/s               0%               --              -2%              -8%
Not single quote 1000000/s               2%               2%               --              -6%
Use scalar value 1063830/s               9%               9%               6%               --

* Mac OS X 10.7.5/Perl 5.14.2
                            Rate Scalar value/$x->{$Y } Single quote/$x->{'y'} Single quote/$x->{ y } Double quote/$x->{"y"}
Scalar value/$x->{$Y } 2040816/s                     --                    -4%                    -7%                    -8%
Single quote/$x->{'y'} 2127660/s                     4%                     --                    -3%                    -4%
Single quote/$x->{ y } 2197802/s                     8%                     3%                     --                    -1%
Double quote/$x->{"y"} 2222222/s                     9%                     4%                     1%                     --

* OpenBSD 5.2/Perl 5.12.2
                           Rate Scalar value/$x->{$Y } Single quote/$x->{ y } Single quote/$x->{'y'} Double quote/$x->{"y"}
Scalar value/$x->{$Y } 727273/s                     --                   -16%                   -17%                   -18%
Single quote/$x->{ y } 862069/s                    19%                     --                    -1%                    -3%
Single quote/$x->{'y'} 873362/s                    20%                     1%                     --                    -1%
Double quote/$x->{"y"} 884956/s                    22%                     3%                     1%                     --

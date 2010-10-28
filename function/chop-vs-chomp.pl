#!/usr/bin/perl -w
# chop() vs. chomp() vs. others
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $string = qq|text\n|;
sub usechop  { my $x = shift; chop $x; return $x; }
sub usechomp { my $x = shift; chomp $x; return $x; }
sub usesubst { my $x = shift; $x =~ s{\n\z}{}; return $x; }
sub usetrans { my $x = shift; $x =~ y{\n}{}d; return $x; }

is( usechop($string), 'text' );
is( usechomp($string),'text' );
is( usesubst($string),'text' );
is( usetrans($string),'text' );

cmpthese(500000, { 
	'chop()' => sub { &usechop($string) }, 
	'chomp()' => sub { &usechomp($string) }, 
	's///' => sub { &usesubst($string) }, 
	'y///' => sub { &usetrans($string) }, 
});

__END__

* PowerBookG4/perl 5.8.8
            Rate    s///    y/// chomp()  chop()
s///    505051/s      --    -24%    -35%    -35%
y///    666667/s     32%      --    -15%    -15%
chomp() 781250/s     55%     17%      --      0%
chop()  781250/s     55%     17%      0%      --

* PowerBookG4/perl 5.10.0
            Rate    s/// chomp()    y///  chop()
s///    318471/s      --    -39%    -39%    -46%
chomp() 520833/s     64%      --     -1%    -12%
y///    526316/s     65%      1%      --    -12%
chop()  595238/s     87%     14%     13%      --

* PowerBookG4/perl 5.12.0
            Rate    s///    y/// chomp()  chop()
s///    354610/s      --    -30%    -40%    -40%
y///    510204/s     44%      --    -14%    -14%
chomp() 595238/s     68%     17%      --      0%
chop()  595238/s     68%     17%      0%      --

* Ubuntu 8.04 LTS/perl 5.10.1
             Rate    s///    y///  chop() chomp()
s///     531915/s      --    -36%    -37%    -53%
y///     833333/s     57%      --     -2%    -27%
chop()   847458/s     59%      2%      --    -25%
chomp() 1136364/s    114%     36%     34%      --


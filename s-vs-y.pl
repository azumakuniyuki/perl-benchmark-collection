#!/usr/bin/perl -w
# s///g v.s. y///d
use Benchmark qw(:all);
use Test::More 'no_plan';

my $V = 'perl 5.8.8';
my $E = '<postmaster@example.jp>';

sub ss { my $x = shift(); my $y = shift(); $x =~ s{\D}{}g; $y =~ s{[<>]}{}g; return($x.$y); }
sub yy { my $x = shift(); my $y = shift(); $x =~ y{[0-9]}{}cd; $y =~ y{[<>]}{}d; return($x.$y); }

is( ss($V,$E), '588postmaster@example.jp' );
is( yy($V,$E), '588postmaster@example.jp' );

cmpthese(500000, { 
	's///g' => sub { &ss($V,$E) }, 
	'y///d' => sub { &yy($V,$E) }, 
});

__END__

* PowerBookG4/Perl 5.8.8
          Rate s///g y///d
s///g 169492/s    --  -54%
y///d 370370/s  119%    --

* PowerBookG4/Perl 5.10.0
          Rate s///g y///d
s///g 103950/s    --  -63%
y///d 282486/s  172%    --

* PowerBookG4/Perl 5.12.0
          Rate s///g y///d
s///g  77519/s    --  -71%
y///d 264550/s  241%    --


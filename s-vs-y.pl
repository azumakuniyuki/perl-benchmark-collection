#!/usr/bin/perl -w
# s///g v.s. y///d
use Benchmark qw(:all);
use Test::More 'no_plan';

my $V = 'perl 5.8.8';
my $E = '<postmaster@example.jp>';

sub ss { my $x = shift(); my $y = shift(); $x =~ s{\D}{}g; $y =~ s{[<>]}{}g; $y =~ s{x}{X}g; return($x.$y); }
sub yy { my $x = shift(); my $y = shift(); $x =~ y{[0-9]}{}cd; $y =~ y{[<>]}{}d; $y =~ y{x}{X}; return($x.$y); }

is( ss($V,$E), '588postmaster@eXample.jp' );
is( yy($V,$E), '588postmaster@eXample.jp' );

cmpthese(500000, { 
	's///g' => sub { &ss($V,$E) }, 
	'y///d' => sub { &yy($V,$E) }, 
});

__END__

* PowerBookG4/Perl 5.8.8
          Rate s///g y///d
s///g 137363/s    --  -56%
y///d 314465/s  129%    --

* PowerBookG4/Perl 5.10.0
          Rate s///g y///d
s///g  83056/s    --  -66%
y///d 247525/s  198%    --

* PowerBookG4/Perl 5.12.0
          Rate s///g y///d
s///g  65531/s    --  -72%
y///d 230415/s  252%    --


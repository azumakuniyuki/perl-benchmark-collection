#!/usr/bin/perl -w
# s///g v.s. y///d
use Benchmark qw(:all);
use Test::More 'no_plan';

my $V = 'perl 5.8.8';
my $E = '<postmaster@example.jp>';
my $M = 'Some::Module::Name::Of::Perl';

sub s1 { my $x = shift(); $x =~ s{\D}{}g; return($x); }
sub s2 { my $x = shift(); $x =~ s{[<>]}{}g; return($x); }
sub s3 { my $x = shift(); $x =~ s{::}{/}g; $x .= '.pm'; return($x); }

sub y1 { my $x = shift(); $x =~ y{0-9}{}cd; return($x); }
sub y2 { my $x = shift(); $x =~ y{<>}{}d; return($x); }
sub y3 { my $x = shift(); $x =~ y{:}{/}s; $x .= '.pm'; return($x); }

is( s1($V), '588' );
is( s2($E), 'postmaster@example.jp' );
is( s3($M), 'Some/Module/Name/Of/Perl.pm' );

is( y1($V), '588' );
is( y2($E), 'postmaster@example.jp' );
is( y3($M), 'Some/Module/Name/Of/Perl.pm' );

cmpthese(500000, { 
	's{\D}{}g' => sub { &s1($V) }, 
	'y{0-9}{}cd' => sub { &y1($V) }, 
});
print "\n";
cmpthese(500000, { 
	's{[<>]}{}g' => sub { &s2($E) }, 
	'y{<>}{}d' => sub { &y2($E) }, 
});
print "\n";
cmpthese(500000, { 
	's{::}{/}g' => sub { &s3($M) }, 
	'y{:}{/}s' => sub { &y3($M) }, 
});

__END__

* PowerBookG4/Perl 5.8.8
               Rate   s{\D}{}g y{0-9}{}cd
s{\D}{}g   263158/s         --       -59%
y{0-9}{}cd 649351/s       147%         --

               Rate s{[<>]}{}g   y{<>}{}d
s{[<>]}{}g 384615/s         --       -38%
y{<>}{}d   625000/s        63%         --

              Rate s{::}{/}g  y{:}{/}s
s{::}{/}g 240385/s        --      -54%
y{:}{/}s  526316/s      119%        --


* PowerBookG4/Perl 5.10.0
               Rate   s{\D}{}g y{0-9}{}cd
s{\D}{}g   157233/s         --       -70%
y{0-9}{}cd 526316/s       235%         --

               Rate s{[<>]}{}g   y{<>}{}d
s{[<>]}{}g 263158/s         --       -51%
y{<>}{}d   537634/s       104%         --

              Rate s{::}{/}g  y{:}{/}s
s{::}{/}g 142045/s        --      -67%
y{:}{/}s  431034/s      203%        --


* PowerBookG4/Perl 5.12.0
               Rate   s{\D}{}g y{0-9}{}cd
s{\D}{}g   107296/s         --       -79%
y{0-9}{}cd 515464/s       380%         --

               Rate s{[<>]}{}g   y{<>}{}d
s{[<>]}{}g 239234/s         --       -52%
y{<>}{}d   500000/s       109%         --

              Rate s{::}{/}g  y{:}{/}s
s{::}{/}g 123762/s        --      -62%
y{:}{/}s  324675/s      162%        --


* Ubuntu 8.04 LTS/perl 5.10.1
               Rate   s{\D}{}g y{0-9}{}cd
s{\D}{}g   306748/s         --       -68%
y{0-9}{}cd 961538/s       213%         --

               Rate s{[<>]}{}g   y{<>}{}d
s{[<>]}{}g 438596/s         --       -45%
y{<>}{}d   793651/s        81%         --

              Rate s{::}{/}g  y{:}{/}s
s{::}{/}g 246305/s        --      -66%
y{:}{/}s  714286/s      190%        --


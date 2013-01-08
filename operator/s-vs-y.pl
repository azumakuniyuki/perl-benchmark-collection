#!/usr/bin/perl -w
# s///g v.s. y///d
use Benchmark qw(:all);
use Test::More 'no_plan';

my $V = 'perl 5.8.8';
my $E = '<postmaster@example.jp>';
my $M = 'Some::Module::Name::Of::Perl';

sub s1 { my $x = shift(); $x =~ s{\D}{}g; return($x); }
sub s2 { my $x = shift(); $x =~ s{[<>]}{}g; return($x); }
sub s3 { my $x = shift(); $x =~ s{:}{/}g; $x =~ y{/}{}s; $x .= '.pm'; return($x); }

sub y1 { my $x = shift(); $x =~ y{0-9}{}cd; return($x); }
sub y2 { my $x = shift(); $x =~ y{<>}{}d; return($x); }
sub y3 { my $x = shift(); $x =~ y{:}{/};  $x =~ y{/}{}s; $x .= '.pm'; return($x); }

is( s1($V), '588' );
is( s2($E), 'postmaster@example.jp' );
is( s3($M), 'Some/Module/Name/Of/Perl.pm' );

is( y1($V), '588' );
is( y2($E), 'postmaster@example.jp' );
is( y3($M), 'Some/Module/Name/Of/Perl.pm' );

cmpthese(1200000, { 
	's{\D}{}g' => sub { &s1($V) }, 
	'y{0-9}{}cd' => sub { &y1($V) }, 
});
print "\n";
cmpthese(900000, { 
	's{[<>]}{}g' => sub { &s2($E) }, 
	'y{<>}{}d' => sub { &y2($E) }, 
});
print "\n";
cmpthese(900000, { 
	's{:}{/}g' => sub { &s3($M) }, 
	'y{:}{/}' => sub { &y3($M) }, 
});

__END__

* MacBook Air/Mac OS X 10.7.5/Perl 5.14.2
                Rate   s{\D}{}g y{0-9}{}cd
s{\D}{}g    459770/s         --       -79%
y{0-9}{}cd 2222222/s       383%         --

                Rate s{[<>]}{}g   y{<>}{}d
s{[<>]}{}g  841121/s         --       -58%
y{<>}{}d   2000000/s       138%         --

              Rate s{:}{/}g  y{:}{/}
s{:}{/}g  290323/s       --     -80%
y{:}{/}  1475410/s     408%       --


* OpenBSD 5.2/Perl 5.12.2
               Rate   s{\D}{}g y{0-9}{}cd
s{\D}{}g   145808/s         --       -83%
y{0-9}{}cd 851064/s       484%         --

               Rate s{[<>]}{}g   y{<>}{}d
s{[<>]}{}g 368852/s         --       -55%
y{<>}{}d   825688/s       124%         --

             Rate s{:}{/}g  y{:}{/}
s{:}{/}g 106132/s       --     -68%
y{:}{/}  334572/s     215%       --


* Ubuntu 10.04.4 LTS/perl 5.12.4
                Rate   s{\D}{}g y{0-9}{}cd
s{\D}{}g    262009/s         --       -79%
y{0-9}{}cd 1263158/s       382%         --

                Rate s{[<>]}{}g   y{<>}{}d
s{[<>]}{}g  514286/s         --       -59%
y{<>}{}d   1250000/s       143%         --

             Rate s{:}{/}g  y{:}{/}
s{:}{/}g 161290/s       --     -77%
y{:}{/}  697674/s     333%       --


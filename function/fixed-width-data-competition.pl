#!/usr/bin/perl -w
# Fixed width data: substr() v.s. regular expression v.s. unpack()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Data = '68b329da9893e34099c7d8ad5cb9c940';
my $Text =         '9893e34099c7d8ad';
sub usesubstr { return substr( $Data, 8, 16 ); }
sub useregexp { return $1 if $Data =~ m{\A.{8}(.{16}).{8}\z}; }
sub useunpack { return [unpack( 'A8 A16 A8', $Data )]->[1]; }

is( usesubstr(), $Text );
is( useregexp(), $Text );
is( useunpack(), $Text );

cmpthese(1600000, { 
	'substr' => sub { usesubstr() }, 
	'regexp' => sub { useregexp() }, 
	'unpack' => sub { useunpack() }, 
});

__END__

* PowerBookG4/perl 5.8.8
            Rate unpack regexp substr
unpack  190840/s     --   -60%   -83%
regexp  476190/s   150%     --   -58%
substr 1136364/s   495%   139%     --

* PowerBookG4/perl 5.10.0
           Rate unpack regexp substr
unpack 128205/s     --   -66%   -86%
regexp 373134/s   191%     --   -60%
substr 943396/s   636%   153%     --

* PowerBookG4/perl 5.12.0
           Rate unpack regexp substr
unpack 133690/s     --   -66%   -85%
regexp 396825/s   197%     --   -55%
substr 877193/s   556%   121%     --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
            Rate unpack regexp substr
unpack  328947/s     --   -62%   -82%
regexp  862069/s   162%     --   -53%
substr 1851852/s   463%   115%     --

* Mac OS X 10.7.5/Perl 5.14.2
            Rate unpack regexp substr
unpack  459770/s     --   -64%   -88%
regexp 1269841/s   176%     --   -66%
substr 3720930/s   709%   193%     --

* OpenBSD 5.2/Perl 5.12.2
            Rate unpack regexp substr
unpack  205656/s     --   -62%   -86%
regexp  535117/s   160%     --   -64%
substr 1467890/s   614%   174%     --

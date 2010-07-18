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

cmpthese(500000, { 
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


#!/usr/bin/perl
# -f $x v.s. -f _
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $X = '/etc/hosts';
my $Y = '/etc/resolv.conf';

sub filename   { return 1 if( -f $X && -T $X && -s $X && -r $X ); }
sub underscore { return 1 if( -f $Y && -T _ && -s _ && -r _ ); }

ok( filename() );
ok( underscore() );

cmpthese( 40000, { 
	'underscore' => sub{ underscore(); },
	'filename' => sub{ filename(); },
});

__END__

* PowerBookG4/perl 5.8.8
              Rate   filename underscore
filename   15625/s         --        -9%
underscore 17241/s        10%         --

* PowerBookG4/perl 5.10.0
                    Rate filename: -f $fn underscore: -f _
filename: -f $fn 13699/s               --              -7%
underscore: -f _ 14706/s               7%               --

* PowerBookG4/perl 5.12.0
              Rate   filename underscore
filename   14286/s         --       -10%
underscore 15873/s        11%         --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
            (warning: too few iterations for a reliable count)
              Rate   filename underscore
filename   43478/s         --       -26%
underscore 58824/s        35%         --

* Mac OS X 10.7.5/Perl 5.14.2
              Rate   filename underscore
filename   44944/s         --       -10%
underscore 50000/s        11%         --

* OpenBSD 5.2/Perl 5.12.2
              Rate   filename underscore
filename   23392/s         --       -23%
underscore 30303/s        30%         --

#!/usr/bin/perl -w
# List::Util::reduce v.s. map
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use List::Util;

my $Data = [ 0 .. 99 ];
sub listutilreduce { return List::Util::reduce { $a + $b } @$Data; }
sub mapfunction { my $x = 0; map { $x += $_ } @$Data; return $x; }

is( listutilreduce(), 4950 );
is( mapfunction(), 4950 );

cmpthese(50000, { 
	'reduce' => sub { listutilreduce() }, 
	'map {}' => sub { mapfunction() }, 
});

__END__

* PowerBookG4/perl 5.8.8
          Rate reduce map {}
reduce 10917/s     --   -63%
map {} 29762/s   173%     --

* PowerBookG4/perl 5.10.0
          Rate reduce map {}
reduce  9208/s     --   -59%
map {} 22422/s   143%     --

* PowerBookG4/perl 5.12.0
          Rate map {} reduce
map {} 20000/s     --   -10%
reduce 22321/s    12%     --


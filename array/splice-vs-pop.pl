#!/usr/bin/perl -w
# pop() vs. splice()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @Data = ( 0..99 );
sub popthearray { my @a = @Data; my $x = pop(@a); $x += pop(@a); return $x; }
sub splicearray { my @a = @Data; my $x = splice(@a,-1); $x += splice(@a,-1); return $x; }

is( popthearray(), 197 );
is( splicearray(), 197 );

cmpthese(1000000, { 
	'pop' => sub { popthearray() }, 
	'splice' => sub { splicearray() }, 
});

__END__

* PowerBookG4/perl 5.8.8
          Rate splice    pop
splice 46275/s     --    -1%
pop    46707/s     1%     --

* PowerBookG4/perl 5.10.0
          Rate splice    pop
splice 34400/s     --    -3%
pop    35348/s     3%     --

* PowerBookG4/perl 5.12.0
          Rate splice    pop
splice 39062/s     --    -1%
pop    39417/s     1%     --

* Ubuntu 8.04 LTS/perl 5.10.1
           Rate splice    pop
splice  98912/s     --    -2%
pop    100705/s     2%     --


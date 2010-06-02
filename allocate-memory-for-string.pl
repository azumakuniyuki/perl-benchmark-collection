#!/usr/bin/perl
# Allocation v.s. Expansion
use strict;
use warnings;
use Benchmark ':all';

my $S = '.' x (1 << 8);
cmpthese(1000000, { 
	'Allocation1' => sub { my $v = q{ } x (1<<9); $v = $S; },
	'Allocation2' => sub { my $v = q{ } x (1<<8); $v = $S; },
	'Allocation3' => sub { my $v = q{ } x (1<<5); $v = $S; },
	'Expansion'   => sub { my $v = undef(); $v = $S; },
});

__END__

* PowerBookG4/perl 5.10.0

                 Rate Allocation1 Allocation2 Allocation3   Expansion
Allocation1  578035/s          --        -23%        -39%        -66%
Allocation2  746269/s         29%          --        -22%        -56%
Allocation3  952381/s         65%         28%          --        -44%
Expansion   1694915/s        193%        127%         78%          --


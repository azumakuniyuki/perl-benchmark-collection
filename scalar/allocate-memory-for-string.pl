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

* PowerBookG4/perl 5.8.8
                 Rate Allocation1 Allocation2 Allocation3   Expansion
Allocation1  729927/s          --        -23%        -45%        -67%
Allocation2  943396/s         29%          --        -29%        -58%
Allocation3 1333333/s         83%         41%          --        -40%
Expansion   2222222/s        204%        136%         67%          --

* PowerBookG4/perl 5.10.0
                 Rate Allocation1 Allocation2 Allocation3   Expansion
Allocation1  578035/s          --        -23%        -39%        -66%
Allocation2  746269/s         29%          --        -22%        -56%
Allocation3  952381/s         65%         28%          --        -44%
Expansion   1694915/s        193%        127%         78%          --

* PowerBookG4/perl 5.12.0
                 Rate Allocation2 Allocation1 Allocation3   Expansion
Allocation2  990099/s          --         -0%         -8%        -42%
Allocation1  990099/s          0%          --         -8%        -42%
Allocation3 1075269/s          9%          9%          --        -37%
Expansion   1694915/s         71%         71%         58%          --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
                 Rate Allocation1 Allocation2 Allocation3   Expansion
Allocation1  847458/s          --        -24%        -39%        -69%
Allocation2 1111111/s         31%          --        -20%        -59%
Allocation3 1388889/s         64%         25%          --        -49%
Expansion   2702703/s        219%        143%         95%          --


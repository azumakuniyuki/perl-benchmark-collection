#!/usr/bin/perl
# ~~ Smart match operator v.s. grep()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @x = ( 'a' .. 'z' );
sub g1 { return(1) if( grep('e', @x) ); }
sub g2 { return(1) if( grep { $_ eq 'e' } @x ); }
sub sm { return(1) if( 'e' ~~ @x ); }

ok( sm() );
ok( g1() );
ok( g2() );

cmpthese( 600000, { 
		'grep1' => sub { &g1 },
		'grep2' => sub { &g2 },
		'~~ op' => sub { &sm },
	});

__END__

* PowerBookG4/perl 5.10.0
          Rate grep2 grep1 ~~ op
grep2  99668/s    --  -41%  -81%
grep1 169492/s   70%    --  -67%
~~ op 512821/s  415%  203%    --


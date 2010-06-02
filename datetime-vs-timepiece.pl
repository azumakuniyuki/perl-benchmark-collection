#!/usr/bin/perl -w
# DateTime v.s. Time::Piece
use strict;
use warnings;

{
	package DateT;
	use DateTime;
	sub make { 
		my $c = shift();
		my $s = shift();
		my $o = DateTime->from_epoch( 'epoch' => $s, 'time_zone' => 'local' ); 
		return($o);
	}
}

{
	package TimeP;
	use Time::Piece;
	sub make {
		my $c = shift();
		my $s = shift();
		my $o = Time::Piece->new(localtime($s));
		return($o);
	}
}

package main;
use Benchmark qw(:all);
use Test::More 'no_plan';

isa_ok( DateT->make(1), q|DateTime| );
isa_ok( TimeP->make(1), q|Time::Piece| );

cmpthese(10000, { 
	'DateTime' =>    sub { TimeP->make( int(rand(1<<24) ); },
	'Time::Piece' => sub { DateT->make( int(rand(1<<24) ); },
});


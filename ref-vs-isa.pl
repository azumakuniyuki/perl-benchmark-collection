#!/usr/bin/perl -w
# ref() v.s. isa()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Time::Piece;

sub useref { my $o = shift; return(1) if( ref($o) eq q|Time::Piece| ); }
sub useisa { my $o = shift; return(1) if( $o->isa(q|Time::Piece|) ); }

my $obj = Time::Piece->new();

ok( useref($obj) );
ok( useisa($obj) );

cmpthese(500000, { 
	'ref()' => sub { &useref($obj) }, 
	'isa()' => sub { &useisa($obj) }, 
});

__END__

* PowerBookG4/perl 5.10.0
          Rate isa() ref()
isa() 352113/s    --  -29%
ref() 495050/s   41%    --

* PowerBookG4/perl 5.12.0
          Rate isa() ref()
isa() 413223/s    --  -21%
ref() 520833/s   26%    --


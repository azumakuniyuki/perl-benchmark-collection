#!/usr/bin/perl
# shift() v.s. @_ in arguments
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub shiftit
{ 
	my $x = shift();
	my $y = shift();
	my $z = shift();
	return( join( '.', $x, $y, $z ) );
}

sub atmark_
{
	my ( $x, $y, $z ) = @_;
	return( join( '.', $x, $y, $z ) );
}

sub nocopy
{
	return( join( '.', $_[0], $_[1], $_[2] ) );
}

is( shiftit(qw{x y z}), 'x.y.z' );
is( atmark_(qw{x y z}), 'x.y.z' );
is( nocopy(qw{x y z}), 'x.y.z' );

cmpthese( 300000, { 
		'shift' => sub{ &shiftit( qw{x y z} ); },
		'@_' => sub{ &atmark_( qw{x y z} ); },
		'nocopy' => sub{ &nocopy( qw{x y z} ); },
	});

__END__

* PowerBookG4/perl 5.10.0
           Rate     @_  shift nocopy
@_     144928/s     --   -48%   -71%
shift  277778/s    92%     --   -45%
nocopy 508475/s   251%    83%     --


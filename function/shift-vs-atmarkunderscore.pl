#!/usr/bin/perl
# shift() v.s. @_ in arguments
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub shiftit
{ 
	my $x = shift;
	my $y = shift;
	my $z = shift;
	return join( '.', $x, $y, $z );
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

cmpthese( 1400000, { 
	'shift' => sub{ &shiftit( qw{x y z} ); },
	'@_' => sub{ &atmark_( qw{x y z} ); },
	'nocopy' => sub{ &nocopy( qw{x y z} ); },
});

__END__

* PowerBookG4/perl 5.8.8
config_args='-ds -e -Dprefix=/usr -Dccflags=-g  -pipe  -Dldflags= -Dman3ext=3pm -Duseithreads -Duseshrplib'
           Rate  shift     @_ nocopy
shift  370370/s     --   -14%   -40%
@_     428571/s    16%     --   -30%
nocopy 612245/s    65%    43%     --


* PowerBookG4/perl 5.10.0
config_args='-Dprefix=/usr/local -Dusethreads -Duseithreads -des -Dldflags=-Dman3ext=3pm'
           Rate     @_  shift nocopy
@_     144928/s     --   -48%   -71%
shift  277778/s    92%     --   -45%
nocopy 508475/s   251%    83%     --

* PowerBookG4/perl 5.12.0
config_args='-des -Dprefix=/opt'
           Rate  shift     @_ nocopy
shift  291262/s     --   -15%   -45%
@_     340909/s    17%     --   -35%
nocopy 526316/s    81%    54%     --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
           Rate     @_  shift nocopy
@_     483871/s     --    -6%   -42%
shift  517241/s     7%     --   -38%
nocopy 833333/s    72%    61%     --

* Mac OS X 10.7.5/Perl 5.14.2
            Rate     @_  shift nocopy
@_     1308411/s     --    -4%   -44%
shift  1359223/s     4%     --   -42%
nocopy 2333333/s    78%    72%     --

* OpenBSD 5.2/Perl 5.12.2
           Rate  shift     @_ nocopy
shift  441640/s     --    -7%   -45%
@_     476190/s     8%     --   -40%
nocopy 800000/s    81%    68%     --


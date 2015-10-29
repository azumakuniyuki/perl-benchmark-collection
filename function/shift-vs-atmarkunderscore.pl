#!/usr/bin/perl
# shift() v.s. @_ in arguments
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub shiftit { 
    my $x = shift;
    my $y = shift;
    return join( '.', $x, $y );
}

sub atmark_1 {
    my ( $x, $y ) = @_;
    return( join( '.', $x, $y ) );
}

sub atmark_2 {
    my $x = $_[0];
    my $y = $_[1];
    return join( '.', $x, $y );
}

sub nocopy {
    return( join( '.', $_[0], $_[1] ) );
}

is( shiftit( qw|x y| ), 'x.y' );
is( atmark_1( qw|x y| ), 'x.y' );
is( atmark_2( qw|x y| ), 'x.y' );
is( nocopy( qw|x y| ), 'x.y' );

cmpthese( 1400000, { 
    'shift'  => sub { &shiftit( qw|x y| ); },
    '@_'     => sub { &atmark_1( qw|x y| ); },
    '$_[0]'  => sub { &atmark_2( qw|x y| ); },
    'nocopy' => sub { &nocopy( qw|x y| ); },
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
            Rate  $_[0]  shift     @_ nocopy
$_[0]  1818182/s     --    -5%    -5%   -38%
shift  1917808/s     5%     --    -0%   -34%
@_     1917808/s     5%     0%     --   -34%
nocopy 2916667/s    60%    52%    52%     --

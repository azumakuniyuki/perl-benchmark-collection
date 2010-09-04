#!/usr/bin/perl
# split() v.s. Regular expression
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $email = 'postmaster@example.jp';

sub gethostbysplit
{
	my $x = shift();
	return [split( '@', $x )]->[1];
}

sub gethostbyregex
{
	my $x = shift();
	return $1 if( $x =~ m{[@](.+)\z} );
}

is( gethostbysplit($email), 'example.jp' );
is( gethostbyregex($email), 'example.jp' );

cmpthese(500000, { 
	'split' => sub { gethostbysplit($email); }, 
	'regex' => sub { gethostbyregex($email); }, 
});


__END__

* PowerBookG5/perl 5.8.8
          Rate split regex
split 215517/s    --  -49%
regex 420168/s   95%    --

* PowerBookG4/perl 5.10.0
          Rate split regex
split 136612/s    --  -41%
regex 230415/s   69%    --

* PowerBookG4/perl 5.12.0
          Rate split regex
split 162338/s    --  -47%
regex 304878/s   88%    --

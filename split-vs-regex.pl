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
	my @y = split( '@', $x );
	return $y[1];
}

sub gethostbyregex
{
	my $x = shift();
	( my $y = $x ) =~ s{\A.+[@]}{};
	return $y;
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
split 208333/s    --  -37%
regex 333333/s   60%    --

* PowerBookG4/perl 5.10.0
          Rate split regex
split 138504/s    --  -52%
regex 289017/s  109%    --

* PowerBookG4/perl 5.12.0
          Rate split regex
split 177936/s    --  -45%
regex 322581/s   81%    --


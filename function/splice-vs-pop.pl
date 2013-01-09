#!/usr/bin/perl -w
# pop() vs. splice()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $L = [ 0..1023 ];
sub usepopfunc
{ 
	my @x = @$L;
	my $y = pop @x;
	$y += pop @x;
	return $y;
}

sub splicefunc
{ 
	my @x = @$L;
	my $y = splice(@x,-1);
	$y += splice(@x,-1); 
	return $y;
}

is( usepopfunc(), 2045 );
is( splicefunc(), 2045 );

cmpthese(100000, { 
	'pop @x' => sub { usepopfunc() }, 
	'splice' => sub { splicefunc() }, 
});

__END__

* Mac OS X 10.7.5/Perl 5.14.2
          Rate pop @x splice
pop @x 20661/s     --    -0%
splice 20704/s     0%     --

* OpenBSD 5.2/Perl 5.12.2
         Rate splice pop @x
splice 3726/s     --     0%
pop @x 3726/s     0%     --


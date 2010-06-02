#!/usr/bin/perl
# Loop Competition/ for, foreach, while
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @A = ( 1 .. (1<<10) );
my @B = ( 1 .. (1<<10) );
my @C = ( 1 .. (1<<10) );
my $R = 146;

sub useforloop
{
	my $a = 0;
	for( my $x = 0; $x < scalar(@A); $x++ )
	{
		$a++ unless( $A[$x] % 7 );
	}
	return($a);
}

sub useforeach
{
	my $a = 0;
	foreach my $x ( @B )
	{
		$a++ unless( $x % 7 );
	}
	return($a);
}

sub usewhile
{
	my $a = 0;
	while( my $x = shift @C )
	{
		$a++ unless( $x % 7 );
	}
	return($a);
}

is( useforloop(), $R, 'for()' );
is( useforeach(), $R, 'foreach()' );
is( usewhile(), $R, 'while()' );

cmpthese( 5000, {
		"for()"	=> \&useforloop,
		"foreach()" => \&useforeach,
		"while()" => \&usewhile,
	});

__END__

* PowerBookG4/perl 5.10.0
            (warning: too few iterations for a reliable count)
              Rate     for() foreach()   while()
for()        906/s        --      -51%     -100%
foreach()   1859/s      105%        --     -100%
while()   500000/s    55100%    26800%        --


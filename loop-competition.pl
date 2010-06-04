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

cmpthese( 10000, {
		"for()"	=> \&useforloop,
		"foreach()" => \&useforeach,
		"while()" => \&usewhile,
	});

__END__

* PowerBookG5/perl 5.8.8
            (warning: too few iterations for a reliable count)
               Rate     for() foreach()   while()
for()        1238/s        --      -48%     -100%
foreach()    2398/s       94%        --     -100%
while()   1000000/s    80700%    41600%        --

* PowerBookG4/perl 5.10.0
            (warning: too few iterations for a reliable count)
              Rate     for() foreach()   while()
for()        876/s        --      -49%     -100%
foreach()   1704/s       94%        --     -100%
while()   500000/s    56950%    29250%        --

* PowerBookG4/perl 5.12.0
            (warning: too few iterations for a reliable count)
               Rate     for() foreach()   while()
for()         932/s        --      -49%     -100%
foreach()    1835/s       97%        --     -100%
while()   1000000/s   107200%    54400%        --


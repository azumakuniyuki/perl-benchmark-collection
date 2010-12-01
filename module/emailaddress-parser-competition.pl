#!/usr/bin/perl -w
# Mail::Address vs. Email::AddressParser vs. Email::Address
#
package Email::Reperire; # Experimental implementation
use strict;
use warnings;
sub parse {
	my $class = shift();
	my $input = shift();

	return q() unless defined $input;
	return q() if ref $input;

	my $canon = q();
	my $token = [ reverse split( q{ }, $input ) ];

	if( scalar(@$token) == 1 )
	{
		$canon = shift @$token;
	}
	else
	{
		foreach my $e ( @$token )
		{
			chomp($e);
			next() unless( $e =~ m{\A[<]?.+[@].+[.][a-z]{2,}[>]?\z} );
			$canon = $e;
			last();
		}
	}

	$canon =~ y{<>[]():;}{}d;	# Remove brackets, colons
	$canon =~ y/{}'"`//d;		# Remove brackets, quotations
	return $canon;
}
1;

package main;
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Devel::Size qw(size total_size);
use Mail::Address;
use Email::AddressParser;
use Email::Address;

my $A = [];
my $E = 'abuse@z100.example.org';

foreach my $n ( 1..100 )
{
	map { push( @$A, 'postmaster@'.$_.$n.'.example.jp' ) } 'a'..'z';
	map { push( @$A, '"Abuse, RFC2142" <abuse@'.$_.$n.'.example.org> (Postmaster)') } 'a'..'z';
}

sub mad {
	my $x = undef();
	my $y = q();
	my $z = 0;

	foreach my $e ( @$A )
	{
		$x  = [ Mail::Address->parse( $e ) ];
		$y  = $x->[0];
		$z += Devel::Size::total_size($x);
	}

	return [ $x, $y, $z ];
}

sub ead {
	my $x = undef();
	my $y = q();
	my $z = 0;

	foreach my $e ( @$A )
	{
		$x  = [ Email::Address->parse( $e ) ];
		$y  = $x->[0];
		$z += Devel::Size::total_size($x);
	}

	return [ $x, $y, $z ];
}

sub eap {
	my $x = undef();
	my $y = q();
	my $z = 0;

	foreach my $e ( @$A )
	{
		$x  = [ Email::AddressParser->parse( $e ) ];
		$y  = $x->[0];
		$z += Devel::Size::total_size($x);
	}

	return [ $x, $y, $z ];
}

sub erp {
	my $x = undef();
	my $y = q();
	my $z = 0;

	foreach my $e ( @$A )
	{
		$x  = Email::Reperire->parse( $e );
		$y  = $x;
		$z += Devel::Size::total_size($x);
	}

	return [ $x, $y, $z ];
}

my $mad = mad();
my $ead = ead();
my $eap = eap();
my $erp = erp();

ok( $mad->[1], $E );
ok( $ead->[1], $E );
ok( $eap->[1], $E );
ok( $erp->[1], $E );
ok( $mad->[2], 'Mail::Address = '.$mad->[2] );
ok( $ead->[2], 'Email::Address = '.$ead->[2] );
ok( $eap->[2], 'Email::AddressParser = '.$eap->[2] );
ok( $erp->[2], 'Email::Reperire = '.$erp->[2] );

cmpthese( 10, { 
	'Mail::Address' => \&mad,
	'Email::Address' => \&ead,
	'Email::AddressParser' => \&eap,
	'Email::Reperire' => \&erp, } );

__END__

ok 5 - Mail::Address = 1830400
ok 6 - Email::Address = 3680768
ok 7 - Email::AddressParser = 1705600
ok 8 - Email::Reperire = 301600

* PowerBookG4/perl 5.10.0
                        Rate Mail::Address Email::Address Email::AddressParser Email::Reperire
Mail::Address        0.729/s            --           -72%                 -77%            -88%
Email::Address        2.56/s          252%             --                 -20%            -59%
Email::AddressParser  3.21/s          339%            25%                   --            -49%
Email::Reperire       6.33/s          768%           147%                  97%              --

* Ubuntu 10.04 LTS/perl 5.12.2
            (warning: too few iterations for a reliable count)
                       Rate Mail::Address Email::Address Email::AddressParser Email::Reperire
Mail::Address        2.24/s            --           -80%                 -83%            -91%
Email::Address       11.0/s          391%             --                 -16%            -55%
Email::AddressParser 13.2/s          488%            20%                   --            -46%
Email::Reperire      24.4/s          990%           122%                  85%              --


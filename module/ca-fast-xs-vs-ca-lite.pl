#!/usr/local/bin/perl -w
# Class::Accessor::Fast::XS vs. Class::Accessor::Lite
{
	# Class::Accessor::Fast::XS is up to date. (0.04)
	package CAF;
	use strict;
	use warnings;
	use base 'Class::Accessor::Fast::XS';
	__PACKAGE__->mk_accessors( qw/id name kind age/ );
	sub new { 
		my $class = shift;
		my $argvs = { @_ };
		return bless $argvs ,__PACKAGE__;
	}
	1;
}

{
	# Class::Accessor::Lite is up to date. (0.05)
	package CAL;
	use strict;
	use warnings;
	use Class::Accessor::Lite (
		'new' => 1,
		'rw'  => [ qw/id name kind age/ ],
	);
	1;
}

package main;
use Benchmark qw(:all);
use Test::More 'no_plan';

my $caf = CAF->new( 'id' => 1, 'name' => 'torachan', 'kind' => 'kijitora' );
my $cal = CAL->new( 'id' => 2, 'name' => 'sabataro', 'kind' => 'sabatora' );

isa_ok( $caf, 'CAF' );
isa_ok( $cal, 'CAL' );
is( $caf->id, 1 );
is( $cal->id, 2 );
is( $caf->name, 'torachan', $caf->name );
is( $cal->name, 'sabataro', $cal->name );
is( $caf->kind, 'kijitora', $caf->kind );
is( $cal->kind, 'sabatora', $cal->kind );

cmpthese( 200000, {
	'C::A::Fast::XS->new' => sub { 
		CAF->new( 'id' => 1, 'name' => 'torachan', 'kind' => 'kijitora' );
	},
	'C::A::Lite->new' => sub {
		CAL->new( 'id' => 2, 'name' => 'sabataro', 'kind' => 'sabatora' );
	} } );

cmpthese( 2400000, {
	'C::A::Fast::XS->get' => sub { 
		my $x = join( ',', $caf->id, $caf->name, $caf->kind );
	},
	'C::A::Lite->get' => sub {
		my $x = join( ',', $cal->id, $cal->name, $cal->kind );
	} } );

cmpthese( 2400000, {
	'C::A::Fast::XS->set' => sub { 
		$caf->age(1);
	},
	'C::A::Lite->set' => sub {
		$caf->age(1);
	} } );

__END__

* Mac OS X 10.7.5/Perl 5.14.2
                        Rate C::A::Fast::XS->new     C::A::Lite->new
C::A::Fast::XS->new 444444/s                  --                 -4%
C::A::Lite->new     465116/s                  5%                  --
                         Rate     C::A::Lite->get C::A::Fast::XS->get
C::A::Lite->get      394737/s                  --                -75%
C::A::Fast::XS->get 1578947/s                300%                  --
                         Rate C::A::Fast::XS->set     C::A::Lite->set
C::A::Fast::XS->set 5714286/s                  --                 -2%
C::A::Lite->set     5853659/s                  2%                  --
1..8
perl ca-fast-xs-vs-ca-lite.pl  13.17s user 0.02s system 99% cpu 13.190 total

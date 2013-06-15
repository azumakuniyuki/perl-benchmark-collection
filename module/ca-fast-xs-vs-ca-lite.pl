#!/usr/local/bin/perl -w
# Class::Accessor::Fast::XS vs. Class::Accessor::Lite
{
	#Class::Accessor::Fast is up to date. (0.34) 
	package CAF;
	use strict;
	use warnings;
	use base 'Class::Accessor::Fast';
	__PACKAGE__->mk_accessors( qw/id name kind age/ );
	sub new { 
		my $class = shift;
		my $argvs = { @_ };
		return bless $argvs ,__PACKAGE__;
	}
	1;
}

{
	# Class::Accessor::Fast::XS is up to date. (0.04)
	package CAX;
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
my $cax = CAX->new( 'id' => 3, 'name' => 'mikachan', 'kind' => 'mikeneko' );

isa_ok( $caf, 'CAF' );
isa_ok( $cal, 'CAL' );
isa_ok( $cax, 'CAX' );
is( $caf->id, 1 );
is( $cal->id, 2 );
is( $cax->id, 3 );
is( $caf->name, 'torachan', $caf->name );
is( $cal->name, 'sabataro', $cal->name );
is( $cax->name, 'mikachan', $cax->name );
is( $caf->kind, 'kijitora', $caf->kind );
is( $cal->kind, 'sabatora', $cal->kind );
is( $cax->kind, 'mikeneko', $cax->kind );

cmpthese( 200000, {
	'C::A::Fast->new' => sub { 
		CAF->new( 'id' => 1, 'name' => 'torachan', 'kind' => 'kijitora' );
	},
	'C::A::Lite->new' => sub {
		CAL->new( 'id' => 2, 'name' => 'sabataro', 'kind' => 'sabatora' );
	},
	'C::A::Fast::XS->new' => sub { 
		CAF->new( 'id' => 3, 'name' => 'mikachan', 'kind' => 'mikeneko' );
	},
} );

cmpthese( 2400000, {
	'C::A::Fast->get' => sub { 
		my $x = join( ',', $caf->id, $caf->name, $caf->kind );
	},
	'C::A::Lite->get' => sub {
		my $x = join( ',', $cal->id, $cal->name, $cal->kind );
	},
	'C::A::Fast::XS->get' => sub { 
		my $x = join( ',', $cax->id, $cax->name, $cax->kind );
	},
} );

cmpthese( 2400000, {
	'C::A::Fast->set' => sub { 
		$caf->age(1);
	},
	'C::A::Lite->set' => sub {
		$cal->age(1);
	},
	'C::A::Fast::XS->set' => sub { 
		$cax->age(1);
	},
} );

__END__

* Mac OS X 10.7.5/Perl 5.14.2
                        Rate C::A::Fast::XS->new C::A::Fast->new C::A::Lite->new
C::A::Fast::XS->new 434783/s                  --             -0%             -9%
C::A::Fast->new     434783/s                  0%              --             -9%
C::A::Lite->new     476190/s                 10%             10%              --
                         Rate C::A::Fast->get C::A::Lite->get C::A::Fast::XS->get
C::A::Fast->get      424779/s              --             -1%                -73%
C::A::Lite->get      427807/s              1%              --                -73%
C::A::Fast::XS->get 1600000/s            277%            274%                  --
                         Rate C::A::Fast->set C::A::Lite->set C::A::Fast::XS->set
C::A::Fast->set     1702128/s              --             -6%                -70%
C::A::Lite->set     1804511/s              6%              --                -68%
C::A::Fast::XS->set 5581395/s            228%            209%                  --
1..12
perl module/ca-fast-xs-vs-ca-lite.pl  22.95s user 0.02s system 99% cpu 22.979 total

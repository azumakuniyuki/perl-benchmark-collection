#!/usr/bin/perl -w
# Mail::Address vs. Email::AddressParser
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Devel::Size qw(size total_size);
use Data::Dumper;
use Mail::Address;
use Email::AddressParser;

my $a = q{postmaster@example.jp};
my $b = q{"Abuse, RFC2142" <abuse@example.org> (Postmaster)};

sub ma {
	my $x = Mail::Address->new( q{}, $a ); 
	my $y = [ Mail::Address->parse( $b ) ];
	return [ $x, $y->[0] ];
}

sub ea {
	my $x = Email::AddressParser->new( $a );
	my $y = [ Email::AddressParser->parse( $b ) ];
	return [ $x, $y->[0] ];
}

my $ma = ma();
my $ea = ea();

isa_ok( $ma->[0], q|Mail::Address| );
isa_ok( $ma->[1], q|Mail::Address| );
isa_ok( $ea->[0], q|Email::AddressParser| );
isa_ok( $ea->[1], q|Email::AddressParser| );
ok( Devel::Size::total_size($ma), 'Mail::Address = '.Devel::Size::total_size($ma) );
ok( Devel::Size::total_size($ea), 'Email::AddressParser = '.Devel::Size::total_size($ea) );

printf( "Mail::Address: %s", Data::Dumper::Dumper $ma );
printf( "Email::AddressParser: %s", Data::Dumper::Dumper $ea );

cmpthese( 50000, { 
	'Mail::Address' => \&ma,
	'Email::AddressParser' => \&ea } );

__END__

* PowerBookG4/perl 5.10.0
Mail::Address: $VAR1 = [
          bless( [
                   '',
                   'postmaster@example.jp'
                 ], 'Mail::Address' ),
          bless( [
                   '"Abuse, RFC2142"',
                   'abuse@example.org',
                   '(Postmaster)'
                 ], 'Mail::Address' )
        ];
Email::AddressParser: $VAR1 = [
          bless( {
                   'email' => undef,
                   'original' => undef,
                   'comment' => undef,
                   'personal' => 'postmaster@example.jp'
                 }, 'Email::AddressParser' ),
          bless( {
                   'email' => 'abuse@example.org',
                   'personal' => 'Abuse, RFC2142'
                 }, 'Email::AddressParser' )
        ];

                        Rate        Mail::Address Email::AddressParser
Mail::Address         4429/s                   --                 -81%
Email::AddressParser 23585/s                 433%                   --


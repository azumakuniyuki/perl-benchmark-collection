#!/usr/bin/perl -w
# List(@) vs. Hash(%) at Class::Struct
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Class::Struct;
use Devel::Size qw(size total_size);

struct ByList => [
	'name' => '$',
	'age'  => '$',
	'home' => '$',
	'cats' => '@',
	'lang' => '@',
	'item' => '%'
];

struct ByHash => {
	'name' => '$',
	'age'  => '$',
	'home' => '$',
	'cats' => '@',
	'lang' => '@',
	'item' => '%'
};

sub constructor
{
	my $t = shift;
	return new $t;
}

sub set
{
	my $s = shift;
	$s->name('azumakuniyuki');
	$s->age(9);
	$s->home('Kyoto');
	$s->cats(0,'Lui');
	$s->cats(1,'Mei');
	$s->cats(2,'Aoi');
	$s->cats(3,'Mari');
	$s->lang(0,'ja');
	$s->lang(1,'en');
	$s->lang(2,'perl');
	$s->item('pc' => 'PowerBook');
	$s->item('car' => 'Chrysler');
	return $s;
}

sub get
{
	my $s = shift;
	return join( ':', $s->name(), $s->age(), $s->cats(0), $s->cats(1), $s->cats(2), $s->cats(3), 
			$s->lang(0), $s->lang(1), $s->lang(2), $s->item('pc'), $s->item('car') );
}

my $list = constructor('ByList');
my $hash = constructor('ByHash');

isa_ok( set($list), 'ByList', 'set() ByList' );
isa_ok( set($hash), 'ByHash', 'set() ByHash' );
ok( get($list), get($list) );
ok( get($hash), get($hash) );
ok( Devel::Size::total_size($list), 'Class::Struct(@) = '.Devel::Size::total_size($list) );
ok( Devel::Size::total_size($hash), 'Class::Struct(%) = '.Devel::Size::total_size($hash) );

cmpthese(160000, { 
	'Class::Struct(@)->new' => sub { constructor('ByList'); },
	'Class::Struct(%)->new' => sub { constructor('ByHash'); },
});

$list = constructor('ByList');
$hash = constructor('ByHash');

cmpthese(90000, { 
	'Class::Struct(@)->set' => sub { set($list); },
	'Class::Struct(%)->set' => sub { set($hash); },
});

cmpthese(90000, { 
	'Class::Struct(@)->get' => sub { get($list); },
	'Class::Struct(%)->get' => sub { get($hash); },
});

__END__

* Mac OS X 10.7.5/Perl 5.14.2
ok 5 - Class::Struct(@) = 1257
ok 6 - Class::Struct(%) = 1684
                          Rate Class::Struct(@)->new Class::Struct(%)->new
Class::Struct(@)->new 222222/s                    --                  -11%
Class::Struct(%)->new 250000/s                   13%                    --
                         Rate Class::Struct(%)->set Class::Struct(@)->set
Class::Struct(%)->set 80357/s                    --                  -12%
Class::Struct(@)->set 91837/s                   14%                    --
                         Rate Class::Struct(@)->get Class::Struct(%)->get
Class::Struct(@)->get 73171/s                    --                   -1%
Class::Struct(%)->get 73770/s                    1%                    --


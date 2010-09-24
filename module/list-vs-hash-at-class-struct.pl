#!/usr/bin/perl -w
# List(@) vs. Hash(%) at Class::Struct
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
#use Devel::Size qw(size total_size);
use Class::Struct;

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
	my $t = shift();
	return new $t;
}

sub set
{
	my $s = shift();
	$s->name('hoge');
	$s->age(22);
	$s->home('Kyoto');
	$s->cats(0,'mi-chan');
	$s->cats(1,'tama');
	$s->lang(0,'ja');
	$s->lang(1,'en');
	$s->item('pc' => 'PowerBook');
	$s->item('car' => 'Chrysler');
	return $s;
}

sub get
{
	my $s = shift();
	return join(':',
		$s->name(),$s->age(),$s->cats(0),$s->cats(1),
		$s->lang(0),$s->lang(1),$s->item('pc'),$s->item('car') );
}

my $lstr = constructor('ByList');
my $hstr = constructor('ByHash');

isa_ok( set($lstr), q|ByList|, 'set() ByList' );
isa_ok( set($hstr), q|ByHash|, 'set() ByHash' );
ok( get($lstr), get($lstr) );
ok( get($hstr), get($hstr) );
#ok( Devel::Size::total_size($lstr), 'Class::Struct(@) = '.Devel::Size::total_size($lstr) );
#ok( Devel::Size::total_size($hstr), 'Class::Struct(%) = '.Devel::Size::total_size($hstr) );

cmpthese(50000, { 
	'Class::Struct(@)->new' => sub { constructor('ByList'); },
	'Class::Struct(%)->new' => sub { constructor('ByHash'); },
});

$lstr = constructor('ByList');
$hstr = constructor('ByHash');

cmpthese(50000, { 
	'Class::Struct(@)->set' => sub { set($lstr); },
	'Class::Struct(%)->set' => sub { set($hstr); },
});

cmpthese(50000, { 
	'Class::Struct(@)->get' => sub { get($lstr); },
	'Class::Struct(%)->get' => sub { get($hstr); },
});

__END__

* PowerBookG4/perl 5.8.8
                         Rate Class::Struct(%)->new Class::Struct(@)->new
Class::Struct(%)->new 69444/s                    --                   -6%
Class::Struct(@)->new 73529/s                    6%                    --
                         Rate Class::Struct(%)->set Class::Struct(@)->set
Class::Struct(%)->set 34483/s                    --                   -4%
Class::Struct(@)->set 35971/s                    4%                    --
                         Rate Class::Struct(%)->get Class::Struct(@)->get
Class::Struct(%)->get 30303/s                    --                   -4%
Class::Struct(@)->get 31646/s                    4%                    --


* PowerBookG4/perl 5.10.0
                         Rate Class::Struct(%)->new Class::Struct(@)->new
Class::Struct(%)->new 46729/s                    --                   -2%
Class::Struct(@)->new 47619/s                    2%                    --
                         Rate Class::Struct(%)->set Class::Struct(@)->set
Class::Struct(%)->set 27624/s                    --                   -5%
Class::Struct(@)->set 29070/s                    5%                    --
                         Rate Class::Struct(%)->get Class::Struct(@)->get
Class::Struct(%)->get 22422/s                    --                   -3%
Class::Struct(@)->get 23041/s                    3%                    --


* PowerBookG4/perl 5.12.0
                         Rate Class::Struct(@)->new Class::Struct(%)->new
Class::Struct(@)->new 60976/s                    --                   -1%
Class::Struct(%)->new 61728/s                    1%                    --
                         Rate Class::Struct(%)->set Class::Struct(@)->set
Class::Struct(%)->set 28736/s                    --                   -1%
Class::Struct(@)->set 28902/s                    1%                    --
                         Rate Class::Struct(@)->get Class::Struct(%)->get
Class::Struct(@)->get 26455/s                    --                   -1%
Class::Struct(%)->get 26596/s                    1%                    --


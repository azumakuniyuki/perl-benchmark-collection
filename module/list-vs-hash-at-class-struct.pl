#!/usr/bin/perl -w
# Class::Struct
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
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

my $lstr = new ByList;
my $hstr = new ByHash;

isa_ok( set($lstr), q|ByList|, 'set() ByList' );
isa_ok( set($hstr), q|ByHash|, 'set() ByHash' );
ok( get($lstr), get($lstr) );
ok( get($hstr), get($hstr) );

$lstr = new ByList;
$hstr = new ByHash;

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
                         Rate Class::Struct(%)->set Class::Struct(@)->set
Class::Struct(%)->set 35211/s                    --                   -5%
Class::Struct(@)->set 37037/s                    5%                    --
                         Rate Class::Struct(%)->get Class::Struct(@)->get
Class::Struct(%)->get 30488/s                    --                   -4%
Class::Struct(@)->get 31847/s                    4%                    --


* PowerBookG4/perl 5.10.0
                         Rate Class::Struct(%)->set Class::Struct(@)->set
Class::Struct(%)->set 27624/s                    --                   -4%
Class::Struct(@)->set 28736/s                    4%                    --
                         Rate Class::Struct(%)->get Class::Struct(@)->get
Class::Struct(%)->get 22422/s                    --                   -4%
Class::Struct(@)->get 23256/s                    4%                    --


* PowerBookG4/perl 5.12.0
                         Rate Class::Struct(%)->set Class::Struct(@)->set
Class::Struct(%)->set 28736/s                    --                   -2%
Class::Struct(@)->set 29240/s                    2%                    --
                         Rate Class::Struct(%)->get Class::Struct(@)->get
Class::Struct(%)->get 26316/s                    --                   -2%
Class::Struct(@)->get 26738/s                    2%                    --


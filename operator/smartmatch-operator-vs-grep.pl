#!/usr/bin/perl
# ~~ Smart match operator v.s. grep(), ~~ v.s. ==
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $domains = [ 'mail.com', 'hotmail.com', 'yahoo.com', 'gmail.com',
		'googlemail.com', 'hotmail.co.jp', 'yahoo.co.jp' ];
my $numeral = [ 1..55 ];

sub grepeq { 
	my $x = shift;
	return 1 if grep { $x eq $_ } @$domains;
}

sub grepee {
	my $x = shift;
	return 1 if grep { $x == $_ } @$numeral;
}

sub smart1 {
	my $x = shift;
	return 1 if $x ~~ @$domains;
}

sub smart2 {
	my $x = shift;
	return 1 if $x ~~ @$numeral;
}

ok( grepeq('gmail.com') );
ok( smart1('gmail.com') );

cmpthese( 900000, { 
		'grep eq' => sub { grepeq('gmail.com') },
		'smart~~' => sub { smart1('gmail.com') },
	});

ok( grepee(36) );
ok( smart2(36) );

cmpthese( 900000, { 
		'grep ==' => sub { grepee(36) },
		'smart~~' => sub { smart2(36) },
	});

__END__

* MacBook Air/perl 5.14.2
             Rate grep eq smart~~
grep eq 1011236/s      --    -28%
smart~~ 1406250/s     39%      --

            Rate grep == smart~~
grep == 286624/s      --    -45%
smart~~ 523256/s     83%      --


* Ubuntu/Perl 5.12.3
            Rate grep eq smart~~
grep eq 666667/s      --    -30%
smart~~ 957447/s     44%      --

            Rate grep == smart~~
grep == 187110/s      --    -55%
smart~~ 412844/s    121%      --


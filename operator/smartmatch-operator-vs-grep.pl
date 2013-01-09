#!/usr/bin/perl
# ~~ Smart match operator v.s. grep(), ~~ v.s. ==
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $domains = [ 'mail.com', 'hotmail.com', 'yahoo.com', 'gmail.com',
		'googlemail.com', 'hotmail.co.jp', 'yahoo.co.jp' ];
my $numeral = [ 1..1024 ];

sub grepeq { 
	my $x = shift;
	return 1 if grep { $x eq $_ } @$domains;
}

sub grepee {
	my $x = shift;
	return 1 if grep { $x == $_ } @$numeral;
}

sub equals {
	my $x = shift;
	return 1 if $x % 5 == 0;
}

sub smart1 {
	my $x = shift;
	return 1 if $x ~~ @$domains;
}

sub smart2 {
	my $x = shift;
	return 1 if $x ~~ @$numeral;
}

sub smart3 {
	my $x = shift;
	return 1 if $x % 5 ~~ 0;
}

ok( grepeq('gmail.com') );
ok( smart1('gmail.com') );

cmpthese( 900000, { 
		'grep eq' => sub { grepeq('gmail.com') },
		'smart~~' => sub { smart1('gmail.com') },
	});

ok( grepee(512) );
ok( smart2(512) );

cmpthese( 900000, { 
		'grep ==' => sub { grepee(768) },
		'smart~~' => sub { smart2(768) },
	});

ok( equals(25) );
ok( smart3(25) );

cmpthese( 2000000, { 
		'==' => sub { equals(25) },
		'~~' => sub { smart3(25) },
	});

__END__

* MacBook Air/perl 5.14.2
             Rate grep eq smart~~
grep eq 1011236/s      --    -28%
smart~~ 1406250/s     39%      --

            Rate grep == smart~~
grep == 286624/s      --    -45%
smart~~ 523256/s     83%      --

        Rate   ~~   ==
~~ 2083333/s   -- -11%
== 2352941/s  13%   --


* Ubuntu/Perl 5.12.3
            Rate grep eq smart~~
grep eq 666667/s      --    -30%
smart~~ 957447/s     44%      --

            Rate grep == smart~~
grep == 187110/s      --    -55%
smart~~ 412844/s    121%      --

        Rate  ==  ~~
== 1503759/s  -- -2%
~~ 1526718/s  2%  --


* OpenBSD 5.2/Perl 5.12.2
grep eq 322581/s      --    -40%
smart~~ 540541/s     68%      --

           Rate grep == smart~~
grep ==  3867/s      --    -79%
smart~~ 18248/s    372%      --

       Rate  ~~  ==
~~ 869565/s  -- -3%
== 898876/s  3%  --



% perl -v |head -2
This is perl 5, version 14, subversion 2 (v5.14.2) built for darwin-2level

% perl -MO=Concise -lE 'print 1 if grep { q(gmail.com) eq $_ } ( qw|hotmail.com yahoo.com gmail.com| )'g  <@> leave[1 ref] vKP/REFC ->(end)
1     <0> enter ->2
2     <;> nextstate(main 48 -e:1) v:%,{,2048 ->3
-     <1> null vK/1 ->g
c        <|> and(other->d) vK/1 ->g
8           <|> grepwhile(other->9)[t1] sK ->c
7              <@> grepstart sK* ->8
3                 <0> pushmark s ->4
-                 <1> null lK/1 ->4
-                    <1> null sK/1 ->8
-                       <@> scope sK ->8
-                          <0> ex-nextstate v ->9
b                          <2> seq sK/2 ->-
9                             <$> const(PV "gmail.com") s ->a
-                             <1> ex-rv2sv sK/1 ->b
a                                <$> gvsv(*_) s ->b
4                 <$> const(PV "hotmail.com") sM ->5
5                 <$> const(PV "yahoo.com") sM ->6
6                 <$> const(PV "gmail.com") sM ->7
f           <@> print vK ->g
d              <0> pushmark s ->e
e              <$> const(IV 1) s ->f
-e syntax OK

% perl -MO=Concise -lE 'print 1 if grep { q(gmail.com) ~~ $_ } ( qw|hotmail.com yahoo.com gmail.com| )'
g  <@> leave[1 ref] vKP/REFC ->(end)
1     <0> enter ->2
2     <;> nextstate(main 48 -e:1) v:%,{,2048 ->3
-     <1> null vK/1 ->g
c        <|> and(other->d) vK/1 ->g
8           <|> grepwhile(other->9)[t1] sK ->c
7              <@> grepstart sK* ->8
3                 <0> pushmark s ->4
-                 <1> null lK/1 ->4
-                    <1> null sK/1 ->8
-                       <@> scope sK ->8
-                          <0> ex-nextstate v ->9
b                          <2> smartmatch sK/2 ->-
9                             <$> const(PV "gmail.com") s ->a
-                             <1> ex-rv2sv sK/1 ->b
a                                <$> gvsv(*_) s ->b
4                 <$> const(PV "hotmail.com") sM ->5
5                 <$> const(PV "yahoo.com") sM ->6
6                 <$> const(PV "gmail.com") sM ->7
f           <@> print vK ->g
d              <0> pushmark s ->e
e              <$> const(IV 1) s ->f
-e syntax OK

% perl -MO=Concise,-exec -lE 'print 1 if $ARGV[0] ~~ $ARGV[1]' 1 2
1  <0> enter 
2  <;> nextstate(main 47 -e:1) v:%,{,2048
3  <$> aelemfast(*ARGV) s
4  <$> aelemfast(*ARGV) s/1
5  <2> smartmatch sK/2
6  <|> and(other->7) vK/1
7      <0> pushmark s
8      <$> const(IV 1) s
9      <@> print vK
a  <@> leave[1 ref] vKP/REFC
-e syntax OK

% perl -MO=Concise,-exec -lE 'print 1 if $ARGV[0] == $ARGV[1]' 1 2
1  <0> enter 
2  <;> nextstate(main 47 -e:1) v:%,{,2048
3  <$> aelemfast(*ARGV) s
4  <$> aelemfast(*ARGV) s/1
5  <2> eq sK/2
6  <|> and(other->7) vK/1
7      <0> pushmark s
8      <$> const(IV 1) s
9      <@> print vK
a  <@> leave[1 ref] vKP/REFC
-e syntax OK

% perl -MO=Concise,-exec -lE 'print 1 if $ARGV[0] eq $ARGV[1]' 1 2
1  <0> enter 
2  <;> nextstate(main 47 -e:1) v:%,{,2048
3  <$> aelemfast(*ARGV) s
4  <$> aelemfast(*ARGV) s/1
5  <2> seq sK/2
6  <|> and(other->7) vK/1
7      <0> pushmark s
8      <$> const(IV 1) s
9      <@> print vK
a  <@> leave[1 ref] vKP/REFC
-e syntax OK



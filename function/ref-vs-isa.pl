#!/usr/bin/perl -w
# ref() v.s. isa()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use CPAN;

sub useref { my $o = shift; return 1 if ref($o) eq 'CPAN'; }
sub useisa { my $o = shift; return 1 if $o->isa('CPAN'); }

my $obj = new CPAN;

ok( useref($obj) );
ok( useisa($obj) );

cmpthese(1500000, { 
	'ref()' => sub { &useref($obj) }, 
	'isa()' => sub { &useisa($obj) }, 
});

__END__

* PowerBookG4/perl 5.8.8
          Rate isa() ref()
isa() 434783/s    --  -32%
ref() 641026/s   47%    --

* PowerBookG4/perl 5.10.0
          Rate isa() ref()
isa() 359712/s    --  -35%
ref() 549451/s   53%    --

* PowerBookG4/perl 5.12.0
          Rate isa() ref()
isa() 409836/s    --  -20%
ref() 515464/s   26%    --

* Ubuntu 8.04 LTS/perl 5.10.1
           Rate isa() ref()
isa()  980392/s    --  -12%
ref() 1111111/s   13%    --

* Mac OS X 10.7.5/Perl 5.14.2
           Rate isa() ref()
isa() 1948052/s    --  -22%
ref() 2500000/s   28%    --

* OpenBSD 5.2/Perl 5.12.2
          Rate isa() ref()
isa() 672646/s    --  -20%
ref() 837989/s   25%    --

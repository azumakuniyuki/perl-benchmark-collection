#!/usr/bin/perl -w
# m/Fwd?/i vs. m/[Ff][Ww][Dd]?/
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $U = 'Arrival-Date: Wed, 29 Apr 2009 16:03:18 +0900';
my $V = 'Status: 5.1.1';
my $W = 'Received-From-MTA: DNS; x1x2x3x4.dhcp.example.ne.jp';
my $X = 'Final-Recipient: RFC822; userunknown@example.jp';
my $Y = 'X-Actual-Recipient: RFC822; kijitora@example.co.jp';
my $Z = 'Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown';

sub ignore_case { 
    my $v = 0;

    $v++ if $U =~ m/\AArrival-Date:[ ]*.+\z/i;
    $v++ if $V =~ m/\AStatus: \d[.]\d[.]\d\z/i;
    $v++ if $W =~ m/\AReceived-From-MTA:[ ]*DNS;[ ]*.+\z/i;
    $v++ if $X =~ m/\AFinal-Recipient:[ ]*RFC822;[ ]*[^ ]+\z/i;
    $v++ if $Y =~ m/\AX-Actual-Recipient:[ ]*RFC822;[ ]*[^ ]+\z/i;
    $v++ if $Z =~ m/\ADiagnostic-Code:[ ]*.+?;[ ]*.+\z/i;
    return $v;
}

sub char_class {
    my $v = 0;

    $v++ if $U =~ m/\A[Aa]rrival-[Dd]ate:[ ]*.+\z/;
    $v++ if $V =~ m/\A[Ss]tatus: \d[.]\d[.]\d\z/;
    $v++ if $W =~ m/\A[Rr]eceived-[Ff]rom-MTA:[ ]*(?:DNS|dns);[ ]*.+\z/;
    $v++ if $X =~ m/\A[Ff]inal-[Rr]ecipient:[ ]*(?:RFC|rfc)822;[ ]*[^ ]+\z/;
    $v++ if $Y =~ m/\A[Xx]-[Aa]ctual-[Rr]ecipient:[ ]*(?:RFC|rfc)822;[ ]*[^ ]+\z/;
    $v++ if $Z =~ m/\A[Dd]iagnostic-[Cc]ode:[ ]*.+?;[ ]*.+\z/;
    return $v;
}

is( ignore_case(), 6 );
is( char_class(),  6 );

cmpthese(2200000, { 
    'm/Pattern/i  ' => sub { &ignore_case() }, 
    'm/[Pp]attern/' => sub { &char_class() }, 
});

__END__

ok 1
ok 2
                  Rate m/[Pp]attern/ m/Pattern/i  
m/[Pp]attern/ 235798/s            --          -11%
m/Pattern/i   265060/s           12%            --
1..2
perl regexp/i-option-vs-character-class.pl  19.48s user 0.02s system 99% cpu 19.532 total


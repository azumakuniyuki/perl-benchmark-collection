#!/usr/bin/perl -w
# .. vs $
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Rx = {
    'start' => qr/\A[-]+[ ]+Error Message[ ]+[-]+\z/,
    'rfc822'=> qr|\AContent-Type:[ ]*message/rfc822\z|,
    'endof' => qr/\A__END_OF_MESSAGE__\z/,
};
my $Em = <<'EOM';
From: nekochan@example.jp
To: nyaaan@example.org
Subject: Nyaaaaaaaaaaaaaaan

nyan
--- Error Message ---
Reason: mailboxfull

Content-Type: message/rfc822

Received: from mx450.example.co.jp ([192.0.2.231]) by 
    smtp-gw6.example.com (Lotus SMTP MTA v4.6.1
    (569.2 2-6-1999)) with SMTP id 00000000.00000000;
    Thu, 29 Apr 1999 23:45:00 +0900
From: shironeko@example.com
Date: Thu, 29 Apr 1999 23:45:00 +0900
Message-Id: <0000000000.0000000@mx12.example.or.jp>
To: shironeko@example.com
Subject: Nyaaaan

Nyaan
__END_OF_MESSAGE__

EOM

sub rop {
    # Range oprator
    my @v = split( "\n", $Em );
    my $r = undef;
    my $s = undef;

    for my $e ( @v ) {
        next unless length $e;
        if( ( $e =~ $Rx->{'rfc822'} ) .. ( $e =~ $Rx->{'endof'} ) ) {
            $s = $1 if $e =~ m/\ASubject:[ ]*(.+)\z/;
        } else {
            next unless ( $e =~ $Rx->{'start'} ) .. ( $e =~ $Rx->{'rfc822'} );
            $r = $1 if $e =~ m/\AReason:[ ]*(.+)\z/;
        }
    } continue {
        $e = '';
    }
    return { 'reason' => $r, 'subject' => $s };
}

sub pv0 {
    # Position varaibles
    my @v = split( "\n", $Em );
    my $r = undef;
    my $s = undef;
    my $p = 0;
    my $t = {
        'deliverystatus' => ( 1 << 1 ),
        'message-rfc822' => ( 1 << 2 ),
    };

    for my $e ( @v ) {
        next unless length $e;
        $p |= $t->{'deliverystatus'} if $e =~ $Rx->{'start'};
        $p |= $t->{'message-rfc822'} if $e =~ $Rx->{'rfc822'};

        if( $p & $t->{'message-rfc822'} ) {
            $s = $1 if $e =~ m/\ASubject:[ ]*(.+)\z/;
        } else {
            next unless $p & $t->{'deliverystatus'};
            $r = $1 if $e =~ m/\AReason:[ ]*(.+)\z/;
        }
    } continue {
        $e = '';
    }
    return { 'reason' => $r, 'subject' => $s };
}

sub pv1 {
    # Position varaibles
    my @v = split( "\n", $Em );
    my $r = undef;
    my $s = undef;
    my $p = 0;
    my $t = {
        'deliverystatus' => ( 1 << 1 ),
        'message-rfc822' => ( 1 << 2 ),
    };

    for my $e ( @v ) {
        next unless length $e;
        unless( $p ) {
            $p |= $t->{'deliverystatus'} if $e =~ $Rx->{'start'};
        }
        unless( $p & $t->{'message-rfc822'} ) {
            $p |= $t->{'message-rfc822'} if $e =~ $Rx->{'rfc822'};
        }

        if( $p & $t->{'message-rfc822'} ) {
            $s = $1 if $e =~ m/\ASubject:[ ]*(.+)\z/;
        } else {
            next unless $p & $t->{'deliverystatus'};
            $r = $1 if $e =~ m/\AReason:[ ]*(.+)\z/;
        }
    } continue {
        $e = '';
    }
    return { 'reason' => $r, 'subject' => $s };
}

my $x = rop();
my $y = pv0();
my $z = pv1();

is( $x->{'reason'}, 'mailboxfull' );
is( $x->{'subject'}, 'Nyaaaan' );
is( $y->{'reason'}, 'mailboxfull' );
is( $y->{'subject'}, 'Nyaaaan' );
is( $z->{'reason'}, 'mailboxfull' );
is( $z->{'subject'}, 'Nyaaaan' );

cmpthese( 100000, { 
    'Range operator(..)' => sub { &rop() },
    'Position variable0' => sub { &pv0() },
    'Position variable1' => sub { &pv1() },
} );

__END__

Mac OS X 10.9/Perl 5.20.1
                      Rate Position variable0 Range operator(..) Position variable1
Position variable0 17212/s                 --               -21%               -24%
Range operator(..) 21739/s                26%                 --                -4%
Position variable1 22727/s                32%                 5%                 --
1..6

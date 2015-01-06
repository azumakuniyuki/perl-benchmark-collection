#!/usr/bin/perl -w
# Regular Expression: (?:a|b|c) v.s. grep
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $RxPipe2 = qr/\A(?:From|Return-Path):/;
my $RxList2 = [ qr/\AFrom:/, qr/\AReturn-Path:/ ];
my $RxPipe3 = qr/\A(?:From|Return-Path|Reply-To):/;
my $RxList3 = [ qr/\AFrom:/, qr/\AReturn-Path:/, qr/Reply-To:/ ];
my $RxPipe4 = qr/\A(?:From|Return-Path|Reply-To|Errors-To):/;
my $RxList4 = [ qr/\AFrom:/, qr/\AReturn-Path:/, qr/\AReply-To:/, qr/\AErrors-To:/ ];
my $String0 = 'From: shironeko@example.jp'."\n".
              'Return-Path: <MAILER-DAEMON>'."\n".
              'Reply-To: kijitora@example.org'."\n".
              'Errors-To: neko@example.co.jp'."\n";

sub rxpipe2 { return 1 if $String0 =~ $RxPipe2 }
sub rxlist2 { return 1 if grep { $String0 =~ $_ } @{ $RxList2 } }
sub rxpipe3 { return 1 if $String0 =~ $RxPipe3 }
sub rxlist3 { return 1 if grep { $String0 =~ $_ } @{ $RxList3 } }
sub rxpipe4 { return 1 if $String0 =~ $RxPipe4 }
sub rxlist4 { return 1 if grep { $String0 =~ $_ } @{ $RxList4 } }

ok( rxpipe2() );
ok( rxlist2() );
ok( rxpipe3() );
ok( rxlist3() );
ok( rxpipe4() );
ok( rxlist4() );

cmpthese(1200000, { 
    'Pipe2(m/(?:.../)' => sub { &rxpipe2() }, 
    'List2(grep{...})' => sub { &rxlist2() }, 
});
print "\n";
cmpthese(1200000, { 
    'Pipe3(m/(?:.../)' => sub { &rxpipe3() }, 
    'List3(grep{...})' => sub { &rxlist3() }, 
});
print "\n";
cmpthese(1200000, { 
    'Pipe4(m/(?:.../)' => sub { &rxpipe4() }, 
    'List4(grep{...})' => sub { &rxlist4() }, 
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
                     Rate List2(grep{...}) Pipe2(m/(?:.../)
List2(grep{...}) 352941/s               --             -60%
Pipe2(m/(?:.../) 888889/s             152%               --

                     Rate List3(grep{...}) Pipe3(m/(?:.../)
List3(grep{...}) 242915/s               --             -72%
Pipe3(m/(?:.../) 857143/s             253%               --

                     Rate List4(grep{...}) Pipe4(m/(?:.../)
List4(grep{...}) 199667/s               --             -74%
Pipe4(m/(?:.../) 769231/s             285%               --


* OpenBSD 5.4/Perl 5.16.3
                     Rate List2(grep{...}) Pipe2(m/(?:.../)
List2(grep{...}) 115053/s               --             -70%
Pipe2(m/(?:.../) 377358/s             228%               --

                     Rate List3(grep{...}) Pipe3(m/(?:.../)
List3(grep{...})  87020/s               --             -79%
Pipe3(m/(?:.../) 409556/s             371%               --

                     Rate List4(grep{...}) Pipe4(m/(?:.../)
List4(grep{...})  80863/s               --             -80%
Pipe4(m/(?:.../) 401338/s             396%               --

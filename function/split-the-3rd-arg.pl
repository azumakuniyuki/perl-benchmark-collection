#!/usr/bin/perl -w
# split(':',@x) vs. split(':',@x,5)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @L = ( 0..99 );
my $S = join( ':', @L );

sub use3rd75 { 
    my @x = split( ':', $S, 75 );
    return scalar @x;
}

sub use3rd50 { 
    my @x = split( ':', $S, 50 );
    return scalar @x;
}

sub use3rd25 { 
    my @x = split( ':', $S, 25 );
    return scalar @x;
}

sub twoargvs {
    my @x = split( ':', $S );
    return scalar @x;
}

is( twoargvs(), 100 );
is( use3rd25(),  25 );
is( use3rd50(),  50 );
is( use3rd75(),  75 );

cmpthese( 900000, { 
    'split(":",$x)'     => sub { twoargvs() }, 
    'split(":",$x,25)'  => sub { use3rd25() }, 
    'split(":",$x,50)'  => sub { use3rd50() }, 
    'split(":",$x,75)'  => sub { use3rd75() }, 
});

__END__

* Mac OS X 10.9.5/Perl 5.20.1
                     Rate split(":",$x) split(":",$x,75) split(":",$x,50) split(":",$x,25)
split(":",$x)     32040/s            --             -24%             -46%             -75%
split(":",$x,75)  42393/s           32%               --             -29%             -67%
split(":",$x,50)  59840/s           87%              41%               --             -53%
split(":",$x,25) 128388/s          301%             203%             115%               --

* Mac OS X 10.9.4/Perl 5.14.2
                     Rate split(":",$x) split(":",$x,75) split(":",$x,50) split(":",$x,25)
split(":",$x)     30293/s            --             -25%             -51%             -74%
split(":",$x,75)  40614/s           34%               --             -34%             -66%
split(":",$x,50)  61983/s          105%              53%               --             -48%
split(":",$x,25) 118577/s          291%             192%              91%               --



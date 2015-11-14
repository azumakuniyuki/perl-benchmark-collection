#!/usr/bin/perl
# $# v.s. scalar()
use strict;
use warnings;
use Benchmark ':all';
use Devel::Size qw/size total_size/;
use Test::More 'no_plan';
use JSON;

my $data = { 'x' => [ 1..50 ], 'y' => 'neko' };

sub rs {
    my $j = JSON->new;
    my $v = $j->encode( $data );
    return $v;
}

sub rr {
    my $j = JSON->new;
    my $v = $j->encode( $data );
    return \$v;
}

my $rs = rs();
my $rr = rr();

ok $rs;
ok $rr;

cmpthese( 90000, { 
    'return $v ' => sub { rs() },
    'return \$v' => sub { rr(); },
});

print total_size(\$rs)."\n";
print total_size( $rr)."\n";

__END__

* Mac OS X 10.9.5/Perl 5.20.1
ok 1
ok 2
               Rate return $v  return \$v
return $v  169811/s         --        -2%
return \$v 173077/s         2%         --


#!/usr/bin/perl -w
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

printf("%s\n", $^V);
my $r = 'neko@nyaan.jp';
sub substring {
    my $v = '<neko@nyaan.jp>';
    substr($v,  0, 1, '') if substr($v,  0, 1) eq '<';
    substr($v, -1, 1, '') if substr($v, -1, 1) eq '>';
    return $v;
}

sub s2slashes {
    my $v = '<neko@nyaan.jp>';
    $v =~ s/\A[<]//;
    $v =~ s/[>]\z//;
    return $v;
}

is( substring(), $r );
is( s2slashes(), $r );

cmpthese(4000000, { 
    'substr($v, 0, 1, "")'  => sub { &substring() },
    '$v =~ s/\A.// s/.\z//' => sub { &s2slashes() },
});

__END__
v5.22.1
ok 1
ok 2
                           Rate $v =~ s/\A.// s/.\z//  substr($v, 0, 1, "")
$v =~ s/\A.// s/.\z//  729927/s                    --                  -55%
substr($v, 0, 1, "")  1606426/s                  120%                    --
1..2
perl regexp/s-vs-substr-with-4-args.pl  11.03s user 0.07s system 99% cpu 11.175 total

v5.26.0
ok 1
ok 2
                           Rate $v =~ s/\A.// s/.\z//  substr($v, 0, 1, "")
$v =~ s/\A.// s/.\z//  571429/s                    --                  -71%
substr($v, 0, 1, "")  1970443/s                  245%                    --
1..2
/opt/bin/perl regexp/s-vs-substr-with-4-args.pl  11.14s user 0.08s system 99% cpu 11.322 total

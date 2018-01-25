#!/usr/bin/perl -w
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

printf("%s\n", $^V);
my $r = 'NekoNyaan';
sub substring {
    my $v = '>NekoNyaan=';
    substr($v, 0, 1, '');
    substr($v, -1, 1, '');
    return $v;
}

sub s2slashes {
    my $v = '>NekoNyaan=';
    $v =~ s/\A.//;
    $v =~ s/.\z//;
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
$v =~ s/\A.// s/.\z//  776699/s                    --                  -70%
substr($v, 0, 1, "")  2631579/s                  239%                    --
1..2
perl regexp/s-vs-substr-with-4-args.pl  9.73s user 0.06s system 99% cpu 9.853 total

v5.26.0
ok 1
ok 2
                           Rate $v =~ s/\A.// s/.\z//  substr($v, 0, 1, "")
$v =~ s/\A.// s/.\z//  615385/s                    --                  -80%
substr($v, 0, 1, "")  3100775/s                  404%                    --
1..2
/opt/bin/perl regexp/s-vs-substr-with-4-args.pl  9.91s user 0.08s system 99% cpu 10.076 total


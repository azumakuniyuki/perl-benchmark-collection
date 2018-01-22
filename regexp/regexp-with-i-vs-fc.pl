#!/usr/bin/perl -w
use strict;
use warnings;
use v5.16;
use Benchmark ':all';
use Test::More 'no_plan';

printf("%s\n", $^V);
my $v1 = 'NEKO';
my $v2 = 'Neko';

sub fcfunc { return 1 if fc($v1) eq fc($v2) }
sub lcfunc { return 1 if lc($v1) eq lc($v2) }
sub regexp { return 1 if $v1 =~ /\Q$v2\E/i }

is( fcfunc(), 1);
is( lcfunc(), 1);
is( regexp(), 1);

cmpthese(6000000, { 
    'fc()'  => sub { &fcfunc() }, 
    'lc()'  => sub { &lcfunc() }, 
    '=~//i' => sub { &regexp() }, 
});

__END__

v5.22.1
ok 1
ok 2
ok 3
           Rate =~//i  fc()  lc()
=~//i 2166065/s    --  -40%  -51%
fc()  3592814/s   66%    --  -19%
lc()  4444444/s  105%   24%    --
1..3
perl regexp/regexp-with-i-vs-fc.pl  12.68s user 0.08s system 99% cpu 12.850 total

v5.26.0
ok 1
ok 2
ok 3
           Rate =~//i  fc()  lc()
=~//i 2542373/s    --  -54%  -56%
fc()  5555556/s  119%    --   -3%
lc()  5714286/s  125%    3%    --
1..3
/opt/bin/perl regexp/regexp-with-i-vs-fc.pl  9.44s user 0.06s system 99% cpu 9.552 total

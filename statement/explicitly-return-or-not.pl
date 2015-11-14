#!/usr/bin/perl -w
# { return 2; } vs. { 2; }
use Benchmark qw(:all);
use Test::More 'no_plan';

sub er { return '2'; }
sub nr { '2'; }

is( er(), 2 );
is( nr(), 2 );

cmpthese(3600000, { 
    '{ return 2; }' => sub { &er() }, 
    '{ 2;        }' => sub { &nr() }, 
});

__END__


* Mac OS X 10.9.5/Perl 5.20.1
ok 1
ok 2
                   Rate { 2;        } { return 2; }
{ 2;        } 6792453/s            --           -4%
{ return 2; } 7058824/s            4%            --
1..2
perl statement/explicitly-return-or-not.pl  4.17s user 0.01s system 99% cpu 4.186 total

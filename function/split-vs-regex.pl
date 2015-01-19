#!/usr/bin/perl
# split() v.s. Regular expression
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $email = 'postmaster@example.jp';

sub gethostbysplit1 {
    my $x = shift;
    return [ split( '@', $x ) ]->[1];
}

sub gethostbysplit2 {
    my $x = shift;
    my @y = split( '@', $x );
    return $y[-1];
}

sub gethostbyregex {
    my $x = shift;
    return $1 if $x =~ m{[@](.+)\z};
}

is( gethostbysplit1($email), 'example.jp' );
is( gethostbysplit2($email), 'example.jp' );
is( gethostbyregex($email), 'example.jp' );

cmpthese(500000, { 
    'split1' => sub { gethostbysplit1($email); }, 
    'split2' => sub { gethostbysplit2($email); }, 
    'regex' => sub { gethostbyregex($email); }, 
});


__END__

* Mac OS X 10.9.5/Perl 5.20.1
            Rate split1 split2  regex
split1  769231/s     --    -9%   -37%
split2  847458/s    10%     --   -31%
regex  1219512/s    59%    44%     --

* PowerBookG5/perl 5.8.8
          Rate split regex
split 215517/s    --  -49%
regex 420168/s   95%    --

* PowerBookG4/perl 5.10.0
          Rate split regex
split 136612/s    --  -41%
regex 230415/s   69%    --

* PowerBookG4/perl 5.12.0
          Rate split regex
split 162338/s    --  -47%
regex 304878/s   88%    --

* Mac OS X 10.7.5/Perl 5.14.2
          Rate split regex
split 568182/s    --  -40%
regex 943396/s   66%    --

* OpenBSD 5.2/Perl 5.12.2
          Rate split regex
split 250000/s    --  -49%
regex 490196/s   96%    --


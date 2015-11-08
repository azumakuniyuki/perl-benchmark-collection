#!/usr/bin/perl
# grep { $v eq $_ } (...)
use Benchmark qw(:all);
use Test::More 'no_plan';

my $X = [ 'X-Cat', 'From', 'X-Nekochan', 'X-Cat', 'To', 'Received',
          'Subject', 'X-Cat', 'Date', 'Reply-To', 'X-Stray-Cat',
          'X-Nekochan', 'Message-Id',
]; 

sub greplist {
    my $v = [];
    for my $e ( @$X ) {
        my $q = lc $e;
        next if grep { $q eq $_ } @$v;
        push @$v, $q;
    }
    return $v;
}

sub hashkeys {
    my $v = {};
    for my $e ( @$X ) {
        my $q = lc $e;
        $v->{ $q } = 1;
    }
    return [ keys %$v ];
}

is( scalar @{ greplist() }, 10 );
is( scalar @{ hashkeys() }, 10 );

cmpthese(1500000, { 
    'grep list' => sub { greplist() },
    'hash keys' => sub { hashkeys() },
});

__END__

Mac OS X 10.9.5/Perl 5.20.1
ok 1
ok 2
             Rate grep list hash keys
grep list 69348/s        --      -16%
hash keys 82919/s       20%        --
1..2
perl function/grep-list-vs-hash-keys.pl  41.15s user 0.04s system 99% cpu 41.335 total

#!/usr/bin/perl
# grep { $v eq $_ } (...)
use Benchmark qw(:all);
use Test::More 'no_plan';

my @X = ( 'To', 'From', 'Date', 'Message-Id', 'List-Id', 'Errors-To', 1..20 );
my @Y = ( 1..20, 'Errors-To', 'List-Id', 'Message-Id', 'Date', 'From', 'To' );

sub forward {
    my $v = shift;
    return 1 if grep { $v eq $_ } @X;
}

sub backward {
    my $v = shift;
    return 1 if grep { $v eq $_ } @Y;
}

is( forward('From'), 1 );
is( backward('From'), 1 );

cmpthese(1500000, { 
    'forward ' => sub { forward('From') },
    'backward' => sub { backward('From') },
});

__END__

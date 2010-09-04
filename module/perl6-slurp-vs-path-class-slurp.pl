#!/usr/bin/perl -w
# Perl6::Slurp vs. Path::Class::File->slurp()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Perl6::Slurp;
use Path::Class::File;

my $file = '/etc/passwd';
my $path = new Path::Class::File($file);

sub perl6slurp { my $x = Perl6::Slurp::slurp($file); return $x; }
sub pathclassf { my $x = $path->slurp(); return $x; }

my $size = [ length perl6slurp(), length pathclassf() ];
ok( $size->[0], $file.' = '.$size->[0] );
ok( $size->[1], $file.' = '.$size->[1] );
is( $size->[0], $size->[1] );

cmpthese(10000, { 
	'Perl6::Slurp->slurp' => sub { perl6slurp(); },
	'Path::Class::File->slurp' => sub { pathclassf(); },
});

__END__

* PowerBookG4/perl 5.10.0
                           Rate Path::Class::File->slurp     Perl6::Slurp->slurp
Path::Class::File->slurp 2304/s                       --                    -59%
Perl6::Slurp->slurp      5556/s                     141%                      --

* PowerBookG4/perl 5.12.0
                           Rate Path::Class::File->slurp     Perl6::Slurp->slurp
Path::Class::File->slurp 3279/s                       --                    -56%
Perl6::Slurp->slurp      7463/s                     128%                      --


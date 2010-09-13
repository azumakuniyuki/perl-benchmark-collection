#!/usr/bin/perl -w
# Perl6::Slurp vs. Path::Class::File->slurp()
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Perl6::Slurp;
use Path::Class::File;
use File::Slurp;

my $file = '/etc/passwd';
my $path = new Path::Class::File($file);

sub perl6slurp { my $x = Perl6::Slurp::slurp($file); return $x; }
sub pathclassf { my $x = $path->slurp(); return $x; }
sub fileslurp  { my $x = File::Slurp::slurp($file); return $x; }

my $size = [ length perl6slurp(), length pathclassf(), length fileslurp() ];
ok( $size->[0], $file.' = '.$size->[0] );
ok( $size->[1], $file.' = '.$size->[1] );
ok( $size->[2], $file.' = '.$size->[2] );
is( $size->[0], $size->[1] );
is( $size->[1], $size->[2] );

cmpthese(10000, { 
	'Perl6::Slurp->slurp' => sub { perl6slurp(); },
	'Path::Class::File->slurp' => sub { pathclassf(); },
	'File::Slurp->slurp' => sub { fileslurp(); },
});

__END__

* PowerBookG4/perl 5.10.0
                           Rate Path::Class::File->slurp Perl6::Slurp->slurp File::Slurp->slurp
Path::Class::File->slurp 2132/s                       --                -60%               -77%
Perl6::Slurp->slurp      5348/s                     151%                  --               -43%
File::Slurp->slurp       9434/s                     342%                 76%                 --

* PowerBookG4/perl 5.12.0
                           Rate Path::Class::File->slurp     Perl6::Slurp->slurp
Path::Class::File->slurp 3279/s                       --                    -56%
Perl6::Slurp->slurp      7463/s                     128%                      --

* Ubuntu 8.04 LTS/perl 5.10.1
                            Rate Path::Class::File->slurp    Perl6::Slurp->slurp
Path::Class::File->slurp  6711/s                       --                   -56%
Perl6::Slurp->slurp      15152/s                     126%                     --


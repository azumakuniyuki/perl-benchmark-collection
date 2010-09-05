#!/usr/bin/perl -w
# substr() competition
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Data = '68b329da9893e34099c7d8ad5cb9c940';
my $Text = '0' x 16;
sub substrlvalue { my $x = shift(); substr( $x, 8, 16 ) = $Text; return $x; }
sub substr4argvs { my $x = shift(); substr( $x, 8, 16, $Text );  return $x; }

like( substrlvalue($Data), qr{\A.{8}$Text.{8}\z} );
like( substr4argvs($Data), qr{\A.{8}$Text.{8}\z} );

cmpthese(400000, { 
	'lvalue' => sub { substrlvalue($Data) }, 
	'4argvs' => sub { substr4argvs($Data) }, 
});

__END__

* PowerBookG4/perl 5.8.8
           Rate lvalue 4argvs
lvalue 408163/s     --   -36%
4argvs 634921/s    56%     --

* PowerBookG4/perl 5.10.0
           Rate lvalue 4argvs
lvalue 264901/s     --   -50%
4argvs 526316/s    99%     --

* PowerBookG4/perl 5.12.0
           Rate lvalue 4argvs
lvalue 322581/s     --   -39%
4argvs 526316/s    63%     --

* Ubuntu 8.04 LTS/perl 5.10.1
            (warning: too few iterations for a reliable count)
            Rate lvalue 4argvs
lvalue  625000/s     --   -41%
4argvs 1052632/s    68%     --


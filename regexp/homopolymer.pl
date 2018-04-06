#!/usr/bin/perl -w
# Find homopolymers: precompile the regex, compile each time, or make new string by appending?
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $homopolymer="ACGTTTTTGGCA";
my $regexCompiled=qr/([ATCG])\1+/;
my $shouldBe="ACGTGCA";

sub homopolymerRegexCompile {
  my $x = shift();
  $x=~s/([ATCG])\1+/$1/g;
  return 1 if($x eq $shouldBe);
}
sub homopolymerRegexAlreadyCompiled {
  my $x = shift();
  $x=~s/$regexCompiled/$1/g;
  return 1 if($x eq $shouldBe);
}
sub notRegex {
  my $x = shift();
  my $length=length($x);

  my $firstNt=substr($x,0,1);
  my $newStr=$firstNt;
  for(my $i=1;$i<$length;$i++){
    my $nextNt=substr($x,$i,1);
    if($firstNt ne $nextNt){
      $newStr.=$nextNt;
      $firstNt = $nextNt;
    }
  }
  return 1 if($newStr eq $shouldBe);
}


ok( homopolymerRegexCompile($homopolymer) );
ok( homopolymerRegexAlreadyCompiled($homopolymer) );
ok( notRegex($homopolymer));

cmpthese(500000, { 
  'homopolymer_compression_append' => sub { &notRegex($homopolymer) },
	'Regex_compiled_each_time' => sub { &homopolymerRegexCompile($homopolymer) }, 
	'Regex_already_compiled'   => sub { &homopolymerRegexAlreadyCompiled($homopolymer) },
});

__END__

                                   Rate homopolymer_compression_append Regex_already_compiled Regex_compiled_each_time
homopolymer_compression_append 287356/s                             --                   -34%                     -37%
Regex_already_compiled         438596/s                            53%                     --                      -4%
Regex_compiled_each_time       454545/s                            58%                     4%                       --


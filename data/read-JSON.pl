#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
 
use JSON::PP (); # don't export functions
use JSON::XS (); # don't export functions 
use Benchmark ':all';
use Data::Dumper;
use Test::More 'no_plan';

my $numElements = 100;
my $jsonXS = JSON::XS->new;
my $jsonPP = JSON::PP->new;
 
my $jsonHash = create_json($numElements);
my $jsonStr = $jsonPP->encode($jsonHash);
is(ref($jsonHash), 'HASH', "Created a JSON hash");
is(scalar(keys(%$jsonHash)), $numElements, "Created $numElements keys in the hash");
ok($jsonXS->encode($jsonHash), "JSON::XS::encode");
ok($jsonPP->encode($jsonHash), "JSON::PP::encode");
ok($jsonXS->decode($jsonStr), "JSON::XS::decode");
ok($jsonPP->decode($jsonStr), "JSON::PP::decode");

cmpthese(100000, {
    'XS::encode' => sub {$jsonXS->encode($jsonHash)},
    'PP::encode' => sub {$jsonPP->encode($jsonHash)},
});
cmpthese(100000, {
    'XS::decode' => sub {$jsonXS->decode($jsonStr)},
    'PP::decode' => sub {$jsonPP->decode($jsonStr)},
});

sub create_json {
    my ($n) = @_;
    my @char = (0..9,"A".."Z","a".."z");
    my $numChars = scalar(@char);

    my %data;
    for my $int(0..$n-1){
      my $key   = $char[int(rand($numChars))];
      my $value = $char[int(rand($numChars))];
      # avoid key reassignment and make sure that
      # we have exactly the right number of elements.
      my $numTries=0;
      while($data{$key}){
        $key .= $char[int(rand($numChars))];
      }
      $data{$key} = $value;
    }
    return \%data;
}
 

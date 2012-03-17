#!/usr/bin/perl
# given-when v.s. if-else
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use feature ':5.10';

sub ifelse { 
	my $x = shift;
	my $y = 0;
	if( $x =~ m{[@]yahoo[.](?:com|co[.]jp)\z} ){
		$y = 1;
	}
	elsif( $x =~ m{[@]gmail[.]com\z} || $x =~ m{[@]googlemail[.]com\z} ){
		$y = 1;
	}
	else{
		$y = 0;
	}
	return $y;
}

sub givenwhen {
	my $x = shift();
	my $y = 0;
	given( $x ){
		when( m{[@]yahoo[.](?:com|co[.]jp)\z} ){
			$y = 1;
			break;
		}
		when( m{[@]gmail[.]com\z} || m{[@]googlemail[.]com\z} ){
			$y = 1;
			break;
		}
		default { $y = 0; }
	}
	return $y;
}

ok( ifelse('azumakuniyuki@gmail.com') );
ok( givenwhen('azumakuniyuki@gmail.com') );

cmpthese( 900000, { 
		'if-else' => sub { ifelse('azumakuniyuki@gmail.com') },
		'given-w' => sub { givenwhen('azumakuniyuki@gmail.com') },
	});

__END__

* MacBook Air/perl 5.14.2
             Rate given-w if-else
given-w  769231/s      --    -26%
if-else 1046512/s     36%      --

* Ubuntu/Perl 5.12.3
            Rate given-w if-else
given-w 548780/s      --    -18%
if-else 666667/s     21%      --


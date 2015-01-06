# Perl Benchmark Collection

## Usage
	> perl ./script-name.pl

 OR

	> sudo make env
	> perl -I./lib/perl5 ./module/script-name.pl

## Benchmark Scripts

### data
  - data/allocate-memory-for-string.pl
    - my $x = ' ' x ( 1<<16 )
    - my $x = undef
  - data/anonymous-hash-constructor.pl
    - my $x = +{ "y" => 1 }
    - my $x = { "y" => 1 }
  - data/convert-list-by-map-vs-for.pl
    - foreach { $x = ... }
    - for { $x = ... }
    - @x = map { ... }
    - map { $_ = ... } @x
  - data/create-list-by-map-vs-for.pl
    - for(){ push @x .. }
    - $x = [ map {...;} ]
    - map { push @x ... }
  - data/dollarsharp-vs-negative-index.pl
    - $x[ $#x ]
    - $x[ -1 ]
  - data/dollarsharp-vs-scalar.pl
    - $#x + 1
    - scalar @x
    - @x
  - data/hash-key-name-competition.pl
    - $x->{y}
    - $x->{'y'}
    - $x->{"y"}
    - $x->{ $y }
  - data/use-constant-vs-sub-vs-string.pl
    - my $x = 'STRING';
    - use constant x => 'STRING';
    - sub x() { 'STRING' };

----
### function
  - function/chop-vs-chomp.pl
    - my $x = "text\n";
      - chop $x
      - chomp $x
      - $x =~ s{\n\z}{}
      - $x =~ y{\n}{}d
  - function/fixed-width-data-competition.pl
    - substr( $x, 8, 16 )
    - $x =~ m{\A.{8}(.{16}).{8}\z}
    - [ unpack( 'A8 A16 A8', $x ) ]->[1]
  - function/int-vs-substr.pl
    - my $x = 511
      - int( $x / 100 ) == 5
      - substr( $x, 0, 1 ) == 5
      - $x =~ m{\A5}
  - function/reduce-vs-map.pl
    - my $x = [ 0 .. 99 ];
      - List::Util::reduce { $a + $b } @$x
      - map { $y += $_ } @$x
  - function/ref-vs-isa.pl
    - ref $x eq 'NAME'
    - $x->isa('NAME')
  - function/shift-vs-atmarkunderscore.pl
    - my $x = shift; my $y = shift;
    - my ( $x, $y ) = @_
    - $_[0], $_[1]
  - function/splice-vs-pop.pl
    - splice( @x, -1 )
    - pop @x
  - function/split-vs-regex.pl
    - my $x = 'postmaster@example.org'
      - [ split( '@', $x ) ]->[1]
      - $1 if $x =~ m{[@](.+)\z}
  - function/substr-competition.pl
    - substr( $x, 8, 16 ) = $y
    - substr( $x, 8, 16, $y )

----
### module
  - module/datetime-vs-time-piece.pl
    - DateTime
    - Time::Piece
  - module/emailaddress-parser-competition.pl
    - Mail::Address 
    - Email::AddressParser
    - Email::Address
  - module/list-vs-hash-at-class-struct.pl
    - Class::Struct
      - struct 'L' => [ ... ]
      - struct 'H' => { ... }
  - module/md5-vs-sha1.pl
    - Digest::MD5
    - Digest::SHA
  - module/net-smtp-vs-email-sender.pl
    - Net::SMTP
    - Email::Send
    - Email::Sender::Simple
  - module/slurp-competition.pl
   - Perl6::Slurp->slurp()
   - Path::Class::File->slurp()
   - File::Slurp->slurp()

----
### operator
  - operator/bitshift-vs-multiply-and-division.pl
    - $x << 1 vs. $x * 2
    - $x >> 1 vs. $x / 2
  - operator/defined-or-vs-if-defined.pl
    - $x = $y // $z
    - $x = defined $y ? $y : $z
  - operator/exclamation-vs-not-operator.pl
    - ! $x
    - not $x
  - operator/exclamation-vs-zero.pl
    - ! $x
    - $x == 0
  - operator/qw-vs-single-quote.pl
    - ( qw(x y z) )
    - ( 'x', 'y', 'z' )
  - operator/s-vs-y.pl
    - s/x/y/
    - y/x/y/
  - operator/smartmatch-operator-vs-grep.pl
    - grep { $x eq $_ } @y
    - grep { $x == $_ } @y
    - $x ~~ @y
  - operator/sprintf-vs-dot-operator.pl
    - sprintf( "%s:%s", $x, $y )
    - $x.':'.$y
  - operator/stat-filename-vs-underscore.pl
    - -f $x && -x $x && -w $x
    - -f $x && -x _ && -w _

----
### regexp
  - regexp/backslash-vs-squarebracket.pl
    - $x =~ m/.+\@.+/
    - $x =~ m/.+[@].+/
  - regexp/capture-vs-grouponly.pl
    - $x =~ m/example[.](jp|com|net|org)/
    - $x =~ m/example[.](?:jp|com|net|org)/
  - regexp/pipeline-vs-3times.pl
    - $x =~ m/(?:x|y|z)/
    - $x =~ m/x/; $x =~ m/y/; $x =~ m/z/;
  - regexp/pipeline-vs-grep.pl
    - $x =~ m/(?:x|y|z)/
    - grep { $x =~ $_ } @y;

----
### statement
  - statement/given-when-vs-if-else.pl
    - given( $x ){ when( 1 ){ ... } }
    - if( $x ){ ... } else { ... }
  - statement/ifelse-vs-switch.pl
    - if( $x ){ ... } else { ... }
    - switch( $x ){ case 0:... }
  - statement/loop-competition.pl
    - grep { ... } @x
    - for( $x = 0; $x < $y; $x++ ){ ... }
    - foreach my $x ( @y ){ ... }
    - while( my $x = shift @y ){ ... }


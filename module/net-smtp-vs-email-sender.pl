#!/usr/bin/perl -w
# Net::SMTP vs. Email::Send vs. Email::Sender

{
	package NS1;
	use strict;
	use warnings;
	use Net::SMTP;

	sub sendmesg {
		my $name = shift();
		my $from = shift();
		my $rcpt = shift();
		my $mesg = shift();
		my $smtp = Net::SMTP->new( 
				'Host' => '127.0.0.1',
				'Port' => 2500,
				'Hello' => '[127.0.0.1]' );
		$smtp->mail('<'.$from.'>');
		$smtp->to('<'.$rcpt.'>');
		$smtp->data();
		$smtp->datasend($mesg->as_string);
		$smtp->quit();
	}
}

{
	package ES1;
	use strict;
	use warnings;
	use Email::Send;

	sub sendmesg { 
		my $name = shift();
		my $from = shift();
		my $rcpt = shift();
		my $mesg = shift();
		my $smtp = Email::Send->new( { 
					'mailer' => 'SMTP',
					'mailer_args' => [ 
						'Host' => '127.0.0.1',
						'Port' => 2500,
						#'From' => $from, # be used?
						#'To' => $rcpt,	# be used?
					],
				} );
		$smtp->send( $mesg );
	}
}

{
	package ES2;
	use strict;
	use warnings;
	use Email::Sender::Simple 'sendmail';
	use Email::Sender::Transport::SMTP;

	sub sendmesg {
		my $name = shift();
		my $from = shift();
		my $rcpt = shift();
		my $mesg = shift();
		my $smtp = Email::Sender::Transport::SMTP->new(
						'host' => '127.0.0.1',
						'port' => 2500,
						'helo' => '[127.0.0.1]' );

		return sendmail( $mesg, { 'from' => $from, 'to' => $rcpt, 'transport' => $smtp } );
	}
}

{
	package main;
	use strict;
	use warnings;
	use Benchmark qw(:all);
	use Test::More 'no_plan';
	use Email::MIME;
	use Email::MIME::Creator;
	use Encode;

	my $S = 'postmaster@example.org';
	my $R = 'dev-null@example.jp';
	my $M = Email::MIME->create(
			'header' => [
				'From' => $S,
				'To' => $R,
				'Subject' => 'TEST',
			],
			'attributes' => {
				'content_type' => 'text/plain',
				'charset' => 'ISO-2022-JP',
				'encoding' => '7bit',
			},
			'body' => encode( 'iso-2022-jp' => 'テスト本文' )
		);

	ok( ES1->sendmesg($S,$R,$M), 'Email::Send' );
	ok( ES2->sendmesg($S,$R,$M), 'Email::Sender' );
	ok( NS1->sendmesg($S,$R,$M), 'Net::SMTP' );

	cmpthese(100, { 
		'Net::SMTP' => sub { NS1->sendmesg($S,$R,$M); },
		'Email::Send' => sub { ES1->sendmesg($S,$R,$M); },
		'Email::Sender' => sub { ES2->sendmesg($S,$R,$M); },
	});
}

__END__

* PowerBookG4/perl 5.10.0

ok 1 - Email::Send
ok 2 - Email::Sender
ok 3 - Net::SMTP
                Rate   Email::Send Email::Sender     Net::SMTP
Email::Send   75.8/s            --          -39%          -55%
Email::Sender  125/s           65%            --          -25%
Net::SMTP      167/s          120%           33%            --


#!/usr/local/bin/perl
# SMTPd on 127.0.0.1 by Net::Server::SMTP
use Net::Server::Mail::SMTP;
use IO::Socket::INET;

my $server = new IO::Socket::INET( 'Listen' => 1, 'LocalPort' => 2500 );
my $conn = undef();

while( $conn = $server->accept() )
{
	my $smtp = new Net::Server::Mail::SMTP( 'socket' => $conn );
	$smtp->set_callback( 'RCPT' => \&validate_recipient );
	$smtp->set_callback( 'DATA' => \&queue_message );
	$smtp->process();
	$conn->close()
}

sub validate_recipient
{
	my $sess = shift();
	my $rcpt = shift();
	my $domain = q();

	$domain = $1 if( $rcpt =~ m{[@](.*)>\s*\z} );
	return(0, 513, 'Syntax error.') unless $domain;
        return(1);
}

sub queue_message
{
	my $sess = shift();
	my $data = shift();
	printf(STDERR '.');
	return(1, 250, 'message queued');
}


* PowerBookG4/perl 5.10.0

               Rate    DateTime Time::Piece
DateTime      296/s          --        -98%
Time::Piece 12346/s       4067%          --


#  _ _ _       ____  __       _         __ _ _      
# | (_) |__   / /  \/  | __ _| | _____ / _(_) | ___ 
# | | | '_ \ / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | | | |_) / / | |  | | (_| |   <  __/  _| | |  __/
# |_|_|_.__/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#                                                   
cmd_CPANM   = ../bin/cpanm -f -l ../
lib_MODULES = \
	Class::Struct \
	CPAN \
	DateTime \
	Devel::Size \
	Digest::MD5 \
	Digest::SHA \
	Email::Address \
	Email::AddressParser \
	Email::MIME \
	Email::MIME::Creator \
	Email::Sender::Simple \
	Email::Sender::Transport::SMTP \
	File::Slurp \
	List::Util \
	Mail::Address \
	Net::SMTP \
	Path::Class::File \
	Perl6::Slurp \
	Switch \
	Time::Piece

.PHONY: clean
all: env
env:
	@for x in $(lib_MODULES); \
	do \
		perl -I./perl5 -M$$x -lE '' 2> /dev/null || \
			( echo install $$x && $(cmd_CPANM) $$x ) ;\
	done
	@test -d ../man && chown -R $$USER ../man
	@test -d ./perl5 && chown -R $$USER ./perl5

clean:
	@:

distclean:
	rm -fr ./perl5/*


#  _     _          ____  __       _         __ _ _      
# | |__ (_)_ __    / /  \/  | __ _| | _____ / _(_) | ___ 
# | '_ \| | '_ \  / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | |_) | | | | |/ / | |  | | (_| |   <  __/  _| | |  __/
# |_.__/|_|_| |_/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#                                                        
url_CPANM = http://xrl.us/cpanm

.PHONY: clean
all: env
env: cpanm
cpanm:
	@test -x $@ || ( wget $(url_CPANM) || curl -LOk $(url_CPANM) )
	@test -f $@ && chmod a+x $@ && chown $$USER $@

clean:
	@:

distclean:
	rm -f ./cpanm*


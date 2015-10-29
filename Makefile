#  __  __       _         __ _ _      
# |  \/  | __ _| | _____ / _(_) | ___ 
# | |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | |  | | (_| |   <  __/  _| | |  __/
# |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#                                     
SHELL   = /bin/sh
BUILD   = make
OPTIOINS=
SUBDIRS = bin lib
RUNPERL = perl -I./lib/perl5
BMSDIRS = data function module operator regexp statement

.PHONY: clean
git-status:
	git status

env:
	@for x in $(SUBDIRS); \
	do \
		cd $$x && echo Making $@ in: && pwd && $(BUILD) $(OPTIONS) $@; \
		cd ../; \
	done

benchmark-list:
	@for x in $(BMSDIRS); \
	do \
		echo - $$x; \
		find $$x -type f -name '*.pl' | sed -e 's/^/  - /g'; \
		echo; \
	done

clean:
	@for x in $(SUBDIRS); \
	do \
		cd $$x && echo Making $@ in: && pwd && $(BUILD) $(OPTIONS) $@; \
		cd ../; \
	done

distclean:
	rm -fr ./man
	@for x in $(SUBDIRS); \
	do \
		cd $$x && echo Making $@ in: && pwd && $(BUILD) $(OPTIONS) $@; \
		cd ../; \
	done

push:
	for G in github; do \
		git push --tags $$G master; \
	done

# Simple makefile for our perl stuff

build: SWGetopt SWSymbol SWStateM

.PHONY: build clean SWGetopt SWSymbol SWStateM

SWGetopt:
	cd SWGetopt; perl Makefile.PL; make; make test; cd ..;

SWSymbol:
	cd SWSymbol; perl Makefile.PL; make; make test; cd ..;

SWStateM:
	cd SWStateM; perl Makefile.PL; make; make test; cd ..;

clean:
	cd SWGetopt; make clean; cd ..;
	cd SWSymbol; make clean; cd ..;
	cd SWStateM; make clean; cd ..;

distclean:
	cd SWGetopt; make distclean; cd ..;
	cd SWSymbol; make distclean; cd ..;
	cd SWStateM; make distclean; cd ..;


install: build
	mkdir -p ../../bin
	cp spm ../../bin/spm-perl
	cp spmadmin ../../bin/spmadmin-perl
	mkdir -p ../../lib
	cd SWGetopt; make install; cd ..;
	cd SWSymbol; make install; cd ..;
	cd SWStateM; make install; cd ..;

all: clean build

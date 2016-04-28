YACC :=		byacc
LDFLAGS :=	-static
CFLAGS :=	-Os
LIBS :=		-lm

PREFIX ?= ~

hoc: hoc.o
	cc ${LDFLAGS} hoc.o -o hoc ${LIBS}

clean:
	@rm -f hoc hoc.o

install:
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp hoc -f ${DESTDIR}${PREFIX}/bin
	@chmod 755  ${DESTDIR}${PREFIX}/bin/hoc

uninstall:
	@rm -f ${DESTDIR}${PREFIX}/bin/hoc

.PHONY: clean install

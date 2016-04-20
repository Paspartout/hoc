YACC=byacc
LDFLAGS=-static
LIBS=-lm

hoc: hoc.o
	cc ${LDFLAGS} hoc.o -o hoc ${LIBS}

clean:
	@rm -f hoc hoc.o

.PHONY: clean

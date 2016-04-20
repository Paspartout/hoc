YACC=byacc
LDFLAGS=-static

hoc: hoc.o
	cc hoc.o -o hoc

clean:
	@rm -f hoc hoc.o

.PHONY: clean

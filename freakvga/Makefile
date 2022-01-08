COMP_OPT = -O2 -pipe -pedantic -fomit-frame-pointer -I./ansi_io
WARN_OPT = -Wall -pedantic -Wstrict-prototypes -Wpointer-arith -Wconversion -Wwrite-strings -Wmissing-prototypes -Wmissing-declarations -Winline
OBJS = inject.o

.c.o:
	gcc $(COMP_OPT) $(WARN_OPT) -c $(DBG) $*.c 

all: inject
	
inject: $(OBJS)
	gcc -o inject $(OBJS) $(LINK_OPT) $(DBG) $(LIBS)

clean:
	rm -f *.o core *~


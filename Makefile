TARGET = life
INCLUDE = .
BYTES_PER_PIXEL=4
KVER=26

$(TARGET): main.o
	ld -melf_i386 --strip-all --omagic -o $(TARGET) main.o

main.o: main.s defs.s
	as --32 -o main.o main.s -I$(INCLUDE) --defsym KVER=$(KVER) --defsym BYTES_PER_PIXEL=$(BYTES_PER_PIXEL)

clean:
	@echo cleaning...
	@rm -f *~ *.o core*


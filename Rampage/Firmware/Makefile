832DIR=../../EightThirtyTwo/
INCDIR=$(832DIR)/include/
832LIBDIR=$(832DIR)/Lib/
LIBDIR=../../Lib/
ROMGENDIR = $(832DIR)/romgen
ROMGEN = $(ROMGENDIR)/romgen
CC=$(832DIR)/vbcc/bin/vbcc832
AS=$(832DIR)/832a/832a
LD=$(832DIR)/832a/832l
DUMP=objdump
CFLAGS = -+ -size
LDFLAGS = -s_STACKSIZE=512
COPT = -O=1311
all: Boot_ROM.vhd

clean :
	-rm *.asm
	-rm *.S
	-rm *.o
	-rm *.vhd
	-rm *.bin
	-rm *.elf

%_ROM.vhd: %.bin $(ROMGEN)
	sed 's/dualportram/$*_rom/' >$*_ROM.vhd <$(ROMGENDIR)/rom_prologue.vhd
	$(ROMGEN) -b $*.bin >>$*_ROM.vhd
	cat >>$*_ROM.vhd $(ROMGENDIR)/rom_epilogue.vhd

%.bin : %.elf Makefile
	objcopy -Obinary $< $@

%.o : %.s Makefile
	gcc -c $*.s

Boot.bin : start.o premain.o uart.o tiny_printf.o spi_sd.o minfat.o swap.o \
			pausecpu.o keyboard.o interrupts.o osd.o osd_spritesheet.o main.o
	$(LD) $(LDFLAGS) -o $@ $+

%.o : %.S Makefile $(832LIBDIR)/start.S
	$(AS) -o $*.o $*.S

%.o : %.c Makefile $(832LIBDIR)/start.S
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c
	$(AS) -o $*.o $*.asm

%.o : $(832LIBDIR)/%.S Makefile $(832LIBDIR)/start.S
	$(AS) -o $*.o $(832LIBDIR)/$*.S

%.o : $(832LIBDIR)/%.asm Makefile $(832LIBDIR)/start.S
	$(AS) -o $*.o $(832LIBDIR)/$*.asm

%.o : $(LIBDIR)/%.S Makefile 
	$(AS) -o $*.o $(LIBDIR)/$*.S

%.o : $(LIBDIR)/%.asm Makefile 
	$(AS) -o $*.o $(LIBDIR)/$*.asm

%.asm : %.c Makefile
	$(CC) $(COPT) $(CFLAGS) -I$(INCDIR) -I$(LIBDIR) $*.c

$(ROMGEN): $(ROMGENDIR)/romgen.c
	gcc -o $(ROMGENDIR)/romgen $(ROMGENDIR)/romgen.c

force:


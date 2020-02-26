PROJECTS=Rampage
BOARDS_ALTERA = "chameleon64 chameleon64v2 mist"

all:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT BOARDS_ALTERA=$(BOARDS_ALTERA) BOARDS_XILINX=$(BOARDS_XILINX); \
	done

clean:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT clean; \
	done


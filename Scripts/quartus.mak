
BOARD=de1
BOARDDIR=../Board/$(BOARD)
PROJECT=HelloWorld
MANIFEST=manifest.rtl
SCRIPTSDIR=../Scripts

PROJECTDIR=fpga/$(BOARD)
TARGET=$(PROJECTDIR)/$(PROJECT)

ALL: $(TARGET).qsf $(TARGET).qpf

clean:
	rm -rf $(PROJECTDIR)

$(TARGET).qsf: $(PROJECTDIR) $(PROJECTDIR)/PLL $(MANIFEST)
	cp $(BOARDDIR)/template.qsf $(TARGET).qsf
	cp $(BOARDDIR)/constraints.sdc $(PROJECTDIR)/PLL
	bash $(SCRIPTSDIR)/expandtemplate_quartus.sh $(MANIFEST) $(BOARD) >>$(TARGET).qsf

$(TARGET).qpf:
	echo >$(TARGET).qpf PROJECT_REVISION = \"${PROJECT}\"


$(PROJECTDIR):
	mkdir $(PROJECTDIR)

$(PROJECTDIR)/PLL:
	mkdir $(PROJECTDIR)/PLL


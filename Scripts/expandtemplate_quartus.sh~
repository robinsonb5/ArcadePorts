#!/bin/bash

cat $1 | while read a; do
	b=${a,,}
	if [ "${b: -4}" = ".vhd" ]; then
		if [[ "$a" = *" "* ]]; then
			echo set_global_assignment -name VHDL_FILE \"../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`\"
		else
			echo set_global_assignment -name VHDL_FILE ../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`
		fi
	fi
	if [ "${b: -4}" = ".qip" ]; then
		if [[ "$a" = *" "* ]]; then
			echo set_global_assignment -name QIP_FILE \"../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`\"
		else
			echo set_global_assignment -name QIP_FILE ../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`
		fi
	fi
	if [ "${b: -2}" = ".v" ]; then
		if [[ "$a" = *" "* ]]; then
			echo set_global_assignment -name VERILOG_FILE \"../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`\"
		else
			echo set_global_assignment -name VERILOG_FILE ../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`
		fi
	fi
	if [ "${b: -3}" = ".sv" ]; then
		if [[ "$a" = *" "* ]]; then
			echo set_global_assignment -name SYSTEMVERILOG_FILE \"../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`\"
		else
			echo set_global_assignment -name SYSTEMVERILOG_FILE ../../`echo $a | sed "s/\\$BOARD/${BOARD}/"`
		fi
	fi
done


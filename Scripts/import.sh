#!/bin/bash
DIR=$(dirname "$1")
DIR=`echo $DIR | sed "s/ /\ /"`

cat "$1" | while read a; do
	b=${a,,}
	a=`echo ${a} | sed "s/set_global_assignment -name QIP_FILE //"`
	a=`echo ${a} | sed "s/set_global_assignment -name VHDL_FILE //"`
	a=`echo ${a} | sed "s/set_global_assignment -name VERILOG_FILE //"`
	a=`echo ${a} | sed "s/set_global_assignment -name SYSTEMVERILOG_FILE //"`
	if [ "${b: -4}" = ".vhd" ]; then
		echo ${DIR}/${a}
	fi
	if [ "${b: -4}" = ".qip" ]; then
		echo ${DIR}/${a}
	fi
	if [ "${b: -2}" = ".v" ]; then
		echo ${DIR}/${a}
	fi
	if [ "${b: -3}" = ".sv" ]; then
		echo ${DIR}/${a}
	fi
done


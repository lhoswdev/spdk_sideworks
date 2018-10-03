#!/bin/bash

function find_lib_defining() {
	symname="$1"
	if [ -z "$symname" ]; then
		return
	fi
	srclib="$2"
	if [ -z "$srclib" ]; then
		return
	fi
	liblist=$(ls -1 libspdk_*.so)
	found_it=0
	for i in $liblist
	do
		if [ "$liblist" == "$srclib" ]; then
			#
			# Don't need to look in the srclib itself
			# from where this symbol reference was retrieved
			#
			continue
		fi
		readelf -s $i | cut -d':' -f2 | tr -s ' ' | egrep -q "DEFAULT [0-9]+ ${symname}$"
		if [ $? -eq 0 ]; then
			echo $i
			found_it=1
		fi
	done
	if [ $found_it -eq 0 ]; then
		echo ":MISSING: $symname"
	fi
}

for libname in $(ls -1 libspdk_*.so)
do
	echo === LIB $libname has references to symbols in:
	readelf -s $libname | cut -d':' -f2 | tr -s ' ' | egrep 'NOTYPE GLOBAL.*UND ' | cut -d' ' -f8 | sort | uniq | egrep -v '^rte|^_rte|^__rte' > func.lst 2>&1
	while [ /bin/true ]
	do
		read symname
		if [ -z "$symname" ]; then
			break
		fi
		find_lib_defining "$symname" "$libname"
	done < func.lst | sort | uniq
done


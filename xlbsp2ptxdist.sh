#!/bin/bash

myself=$0
interactive="no"
cval_list="					\
	PROJECT_NAME				\
	XILINX_MICROBLAZE0_FAMILY		\
	XILINX_MICROBLAZE0_USE_MSR_INSTR	\
	XILINX_MICROBLAZE0_USE_PCMP_INSTR	\
	XILINX_MICROBLAZE0_USE_BARREL		\
	XILINX_MICROBLAZE0_USE_DIV		\
	XILINX_MICROBLAZE0_USE_HW_MUL		\
	XILINX_MICROBLAZE0_USE_FPU		\
	XILINX_MICROBLAZE0_HW_VER		\
	KERNEL_BASE_ADDR			\
"

while getopts ":hil" opt; do
	case $opt in
		h)
			echo "Renew ptxdist project configuration with information"
			echo "from deposited Xilinx BSP in configs/*/platforms/xlbsp"
			echo
			echo "Usage: $(basename $0) [args...]"
			echo 
			echo "   -h     show this short help message"
			echo "   -i     interactive mode -- ask for renew"
			echo "   -l     list configuration values to renew"
			echo
			exit 0
			;;
		i)
			interactive="yes"
			;;
		l)
			for entry in $cval_list; do
				echo $entry
			done
			exit 0
			;;
		\?)
			echo "$(basename $0) invalid option -$OPTARG" >&2
			echo "„$(basename $0) -h“ shows more information" >&2
			exit 1
			;;
	esac
done

ptxd_info() {
        echo "${PTXDIST_LOG_PROMPT:-"$(basename $myself): "}info: $1" >&2
}

#
# comment out configuration value in given file
#
# ${1}	prefix for each configuration value
# ${2}	list of configuration values
# ${3}	configuration file
#
ptxd_cval_rm() {
	if [ $# -ne 3 ]; then
		ptxd_bailout "usage: ptxd_cval_rm <prefix> <cval_list> <cfgfile>"
	fi

	for cval in ${2}; do
		ptxd_info "Remove: ${1}${cval}"
		sed -i -e "/^${1}${cval}/s%^%#%" "${3}"
	done
}

if [ -x "$PTXDIST" ]; then

	platform="$(ptxd_get_ptxconf PTXCONF_PLATFORM)"
	platform_version="$(ptxd_get_ptxconf PTXCONF_PLATFORM_VERSION)"

	ptxd_info "Upgrade $platform-$platform_version"

	platform_config=$(readlink -f $(ptxd_abspath $PTXDIST_PLATFORMCONFIG))
	kernel_config="$(ptxd_abspath $PTXDIST_PLATFORMCONFIGDIR/$(ptxd_get_ptxconf PTXCONF_KERNEL_CONFIG))"

	ptxd_info "Working on: $platform_config"
	ptxd_cval_rm "PTXCONF_" "$cval_list" $platform_config

	ptxd_info "Working on: $kernel_config"
	ptxd_cval_rm "CONFIG_" "$cval_list" $kernel_config

else

	ptxd_info "Start PTXdist environment:"
	ptxdist bash $myself $*

	ptxd_info "Renew platformconfig:"
	if [ "x$interactive" == "xyes" ]; then
		ptxdist oldconfig platform
	else
		yes "" | ptxdist oldconfig platform
	fi

	ptxd_info "Renew kernelconfig:"
	if [ "x$interactive" == "xyes" ]; then
		ptxdist prepare kernel
	else
		yes "" | ptxdist prepare kernel
	fi

fi

exit 0

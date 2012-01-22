#/bin/bash

#echo "$1 $2 $3"

if [ "$1" != "" ] ; then
case "$1" in
	Clean)
		echo "********************************************************************************"
		echo "* Clean Kernel                                                                 *"
		echo "********************************************************************************"

		pushd Kernel
		make clean
		popd
		echo " It's done... "
		exit
		;;
esac
fi
#./build.sh S1_EUR_OPEN k user 03 mid

PROJECT_NAME=S1_EUR_OPEN
HW_BOARD_REV="03"

if [ "$CPU_JOB_NUM" = "" ] ; then
	CPU_JOB_NUM=8
fi

TARGET_LOCALE="uscc"

export LOCALVERSION="-I9000XXJVU-CL851880"

TOOLCHAIN=/home/sztupy/android/tools/arm-2009q3/bin
TOOLCHAIN_PREFIX=arm-none-linux-gnueabi-

KERNEL_BUILD_DIR=`pwd`/Kernel
ANDROID_OUT_DIR=`pwd`/Android/out/target/product/S1_EUR_OPEN

export PRJROOT=$PWD
export PROJECT_NAME
export HW_BOARD_REV

export LD_LIBRARY_PATH=.:${TOOLCHAIN}/../lib

echo "************************************************************"
echo "* EXPORT VARIABLE		                            	 *"
echo "************************************************************"
echo "PRJROOT=$PRJROOT"
echo "PROJECT_NAME=$PROJECT_NAME"
echo "HW_BOARD_REV=$HW_BOARD_REV"
echo "************************************************************"

BUILD_MODULE()
{
	echo "************************************************************"
	echo "* BUILD_MODULE	                                       	 *"
	echo "************************************************************"
	echo

	pushd Kernel
		make ARCH=arm modules
	popd
}

BUILD_KERNEL()
{
	echo "************************************************************"
	echo "*        BUILD_KERNEL                                      *"
	echo "************************************************************"
	echo


	pushd $KERNEL_BUILD_DIR

	export KDIR=`pwd`

	make ARCH=arm aries_eur_defconfig

	# make kernel

	make -j$CPU_JOB_NUM ARCH=arm CROSS_COMPILE=$TOOLCHAIN/$TOOLCHAIN_PREFIX


	popd
	
}

# print title
PRINT_USAGE()
{
	echo "************************************************************"
	echo "* PLEASE TRY AGAIN                                         *"
	echo "************************************************************"
	echo
}

PRINT_TITLE()
{
	echo
	echo "************************************************************"
	echo "*                     MAKE PACKAGES"
	echo "************************************************************"
	echo "* 1. kernel : zImage"
	echo "* 2. modules"
	echo "************************************************************"
}

##############################################################
#                   MAIN FUNCTION                            #
##############################################################
if [ $# -gt 3 ]
then
	echo
	echo "**************************************************************"
	echo "*  Option Error                                              *"
	PRINT_USAGE
	exit 1
fi

START_TIME=`date +%s`

PRINT_TITLE

BUILD_KERNEL
END_TIME=`date +%s`
let "ELAPSED_TIME=$END_TIME-$START_TIME"
echo "Total compile time is $ELAPSED_TIME seconds"


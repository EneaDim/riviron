echo "|**********************************************************************************|"
echo "|                              RISCV GNU toolchain                                 |"
echo "|**********************************************************************************|"
cd 
sudo mkdir /opt/riscv
sudo apt-get install srecord autoconf automake autotools-dev curl python3 python3-pip python3-tomli \
	libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool \
	patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev libslirp-dev
git clone https://github.com/riscv/riscv-gnu-toolchain --recursive
cd riscv-gnu-toolchain
mkdir build
cd build
../configure --prefix=/opt/riscv --enable-multilib
sudo make -j 2
make install
mkdir build32
cd build32
../configure --prefix=/opt/riscv --with-arch=rv32gc --with-abi=ilp32d
sudo make -j 2
make install
cd 

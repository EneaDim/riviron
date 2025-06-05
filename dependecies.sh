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
echo "|**********************************************************************************|"
echo "|                              SPIKE isa sim                                       |"
echo "|**********************************************************************************|"
cd
sudo apt install device-tree-compiler libboost-regex-dev libboost-system-dev
git clone https://github.com/riscv-software-src/riscv-isa-sim.git
cd riscv-isa-sim 
sudo mkdir /opt/spike
mkdir build
cd build
../configure --prefix=/opt/spike
make -j 2
sudo make install
cd 
echo
echo "|**********************************************************************************|"
echo "|                              Proxy Kernel                                        |"
echo "|**********************************************************************************|"
cd 
git clone https://github.com/riscv-software-src/riscv-pk.git
cd riscv-pk
sudo mkdir /opt/riscv-pk
mkdir build
cd build
../configure --prefix=/opt/riscv-pk --host=riscv64-unknown-elf
make -j 2
sudo make install
cd ..
mkdir build32
cd build32
../configure --prefix=/opt/riscv-pk --host=riscv32-unknown-elf
make -j 2
sudo make install
cd 
echo

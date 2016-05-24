# This script is used for our continuous integration tests and installs from scratch on Ubuntu 14.04. 
# You should not normally run this script as it is quite invasive - it installs things and makes folders in your home
# directory.

# add repository for Mono:

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
sudo apt-get update

# install dependencies:

sudo apt-get install build-essential git cmake cmake-qt-gui libboost-all-dev libpython2.7-dev lua5.1 liblua5.1-0-dev openjdk-7-jdk swig libxerces-c-dev doxygen xsltproc libav-tools mono-devel
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/
sudo update-ca-certificates -f

# install Torch: (turned off because the script halts for confirmation of a step)

#git clone https://github.com/torch/distro.git ~/torch --recursive
#cd ~/torch; bash install-deps;
#./install.sh
#source ~/.bashrc

# install CodeSynthesis XSD:

cd ~
wget http://www.codesynthesis.com/download/xsd/4.0/linux-gnu/x86_64/xsd_4.0.0-1_amd64.deb
sudo dpkg -i --force-all xsd_4.0.0-1_amd64.deb
sudo apt-get install -f

# build Luabind:

cd ~
git clone https://github.com/rpavlik/luabind.git ~/rpavlik-luabind
cd rpavlik-luabind
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make

# build Malmo:

cd ~
# git clone <MalmoURL> ~/malmo  (our CI environment does this for us)
wget https://raw.githubusercontent.com/bitfehler/xs3p/master/xs3p.xsl -P ~/malmo/Schemas
cd malmo
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make
ctest

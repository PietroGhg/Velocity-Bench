OPENCV_INSTALL_DIR=/home/pietro/native_cpu/opencv-4.x/build
BOOST_INSTALL_DIR=/home/pietro/native_cpu/deps/boost_1_82_0/install
ETHASH_INSTALL_DIR=/home/pietro/native_cpu/deps/ethash-0.4.3/install
JSONCPP_INSTALL_DIR=/home/pietro/native_cpu/deps/jsoncpp-1.9.5/install
OPENSSL_INSTALL_DIR=/home/pietro/native_cpu/deps/openssl-OpenSSL_1_1_1f/install
ONEMKL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneMKL/build/install
ONEDPL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneDPL
DNNL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneDNN/build/install

source ~/native_cpu/setvars.sh
if [ $1 == "cudaSift" ] || [ $1 == "sobel_filter" ]; then 
  EXTRA_ARGS=-DOpenCV_DIR=$OPENCV_INSTALL_DIR; 
  cd $1/SYCL
elif [ $1 == "ethminer" ]; then 
  cd $1; 
  export Boost_DIR=$BOOST_INSTALL_DIR
  export ethash_DIR=$ETHASH_INSTALL_DIR
  export jsoncpp_DIR=$JSONCPP_INSTALL_DIR
  export OPENSSL_ROOT_DIR=$OPENSSL_INSTALL_DIR
  EXTRA_ARGS="-DETHASHCUDA=OFF -DETHASHSYCL=ON -DUSE_SYS_OPENCL=OFF  -DBINKERN=OFF -DETHASHCL=OFF"
elif [ $1 == "hplinpack" ]; then
  cd $1/dpcpp/nativecpu
  make
  exit
elif [ $1 == "reverse_time_migration" ]; then 
  cd $1;
  EXTRA_ARGS="-DCMAKE_BUILD_TYPE=RELEASE  -DUSE_DPC=ON -DUSE_OpenCV=ON  -DDATA_PATH=data -DWRITE_PATH=results  -DOpenCV_DIR=$OPENCV_INSTALL_DIR"
  cmake -B./build_nativecpu $EXTRA_ARGS -H. -DCOMPRESSION=NO -DCOMPRESSION_PATH=.  -DUSE_NATIVE_CPU=On
  cd build_nativecpu
  make VERBOSE=1 Engine -j16
  exit
elif [ $1 == "SeisAcoMod2D" ]; then
  # to use intel's mpi
  source /opt/intel/oneapi/setvars.sh
  export I_MPI_CXX=clang++
  export CXX=mpicxx
  # to use openmpi
  #export CXX=mpic++
  #export OMPI_CXX=clang++
  #export OMPI_CC=clang
  cd $1/SYCL
elif [ $1 == "svm" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DoneMKLROOT=$ONEMKL_INSTALL_DIR"
elif [ $1 == "tsne" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DONEDPLROOT=$ONEDPL_INSTALL_DIR"
elif [ $1 == "dl-mnist" ]; then
  cd $1/SYCL
  export DNNLROOT=$DNNL_INSTALL_DIR
elif [ $1 == "dl-cifar" ]; then
  cd $1/SYCL
  export DNNLROOT=$DNNL_INSTALL_DIR
  EXTRA_ARGS="-DMKLROOT=$ONEMKL_INSTALL_DIR"
elif [ $1 == "lc0" ]; then
  cd $1
  ./buildSycl.sh -DUSE_NATIVE_CPU=true
  exit
else cd $1/SYCL; fi
echo running cmake -B build_nativecpu -S . -GNinja -DUSE_NATIVE_CPU=On $EXTRA_ARGS
cmake -B build_nativecpu -S . -GNinja -DUSE_NATIVE_CPU=On $EXTRA_ARGS -DCMAKE_BUILD_TYPE=Release
cmake --build build_nativecpu 

OPENCV_INSTALL_DIR=/home/pietro/native_cpu/opencv-4.x/build
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
  cd $1/dpcpp/hpl-2.3
  export DNNLROOT=/opt/intel/oneapi/dnnl/2023.2.0/cpu_dpcpp_gpu_dpcpp
  make arch=nativecpu -j8
  exit
elif [ $1 == "reverse_time_migration" ]; then 
  cd $1;
  EXTRA_ARGS="-DCMAKE_BUILD_TYPE=RELEASE  -DUSE_DPC=ON -DUSE_OpenCV=ON  -DDATA_PATH=data -DWRITE_PATH=results  -DOpenCV_DIR=$OPENCV_INSTALL_DIR"
elif [ $1 == "SeisAcoMod2D" ]; then
  export OMPI_CXX=clang++
  export OMPI_CC=clang
  export CXX=mpic++
  export CC=mpicc
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
elif [ $1 == "lc0" ]; then
  cd $1
  ./buildSycl.sh -DUSE_NATIVE_CPU=true
  exit
else cd $1/SYCL; fi
echo running cmake -B build_nativecpu -S . -GNinja -DUSE_NATIVE_CPU=On $EXTRA_ARGS
cmake -B build_nativecpu -S . -GNinja -DUSE_NATIVE_CPU=On $EXTRA_ARGS 
cmake --build build_nativecpu 

OPENCV_INSTALL_DIR=/home/pietro/native_cpu/opencv-4.x/build
BOOST_INSTALL_DIR=/home/pietro/native_cpu/deps/boost_1_82_0/install
ETHASH_INSTALL_DIR=/home/pietro/native_cpu/deps/ethash-0.4.3/install
JSONCPP_INSTALL_DIR=/home/pietro/native_cpu/deps/jsoncpp-1.9.5/install
OPENSSL_INSTALL_DIR=/home/pietro/native_cpu/deps/openssl-OpenSSL_1_1_1f/install
ONEMKL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneMKL/build_vanilla/install
ONEDNN_INSTALL_DIR=/home/pietro/native_cpu/deps/oneDNN/build_vanilla/install
ONEDPL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneDPL
SPV_AOT=spir64_x86_64

source ~/native_cpu/setvars.sh
if [ $1 == "cudaSift" ] || [ $1 == "sobel_filter" ]; then 
  EXTRA_ARGS=-DOpenCV_DIR=$OPENCV_INSTALL_DIR; 
  EXTRA_ARGS+=" -DGPU_AOT=-fsycl-targets=$SPV_AOT "
  cd $1/SYCL
elif [ $1 == "ethminer" ]; then 
  cd $1; 
  export Boost_DIR=$BOOST_INSTALL_DIR
  export ethash_DIR=$ETHASH_INSTALL_DIR
  export jsoncpp_DIR=$JSONCPP_INSTALL_DIR
  export OPENSSL_ROOT_DIR=$OPENSSL_INSTALL_DIR
  EXTRA_ARGS="-DETHASHCUDA=OFF -DETHASHSYCL=ON -DUSE_SYS_OPENCL=OFF  -DBINKERN=OFF -DETHASHCL=OFF -DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "hplinpack" ]; then
  source /opt/intel/oneapi/setvars.sh
  cd $1/dpcpp/hpl-2.3
  export DNNLROOT=/opt/intel/oneapi/dnnl/2023.2.0/cpu_dpcpp_gpu_dpcpp
  make clean && make 
  exit
elif [ $1 == "reverse_time_migration" ]; then 
  cd $1;
  EXTRA_ARGS="-DCMAKE_BUILD_TYPE=RELEASE  -DUSE_DPC=ON -DUSE_OpenCV=ON  -DDATA_PATH=data -DWRITE_PATH=results  -DOpenCV_DIR=$OPENCV_INSTALL_DIR"
  EXTRA_ARGS+=" -DGPU_AOT=-fsycl-targets=$SPV_AOT "
  cmake -B./build_aot $EXTRA_ARGS -H. -DCOMPRESSION=NO -DCOMPRESSION_PATH=.  -DUSE_CUDA=Off -DCMAKE_BUILD_TYPE=NOMODE
  cd build_aot
  make VERBOSE=1 Engine -j16
  exit
elif [ $1 == "SeisAcoMod2D" ]; then
  # to use intel's mpi
  source /opt/intel/oneapi/setvars.sh
  #export I_MPI_CXX=clang++
  export I_MPI_CXX=icpx
  export CXX=mpicxx
  # to use openmpi
  #export CXX=mpic++
  #export OMPI_CXX=clang++
  #export OMPI_CC=clang
  cd $1/SYCL
  which clang++
  which icpx
  which mpicxx
  EXTRA_ARGS=" -DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "svm" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DoneMKLROOT=$ONEMKL_INSTALL_DIR"
  EXTRA_ARGS+=" -DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "tsne" ]; then
  cd $1/SYCL
  export MKLROOT=$ONEMKL_INSTALL_DIR
  EXTRA_ARGS="-DONEDPLROOT=$ONEDPL_INSTALL_DIR"
  EXTRA_ARGS+=" -DGPU_AOT=-fsycl-targets=$SPV_AOT "
  EXTRA_ARGS+=" -DUSE_MKL=Off"
elif [ $1 == "dl-mnist" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DDNNLROOT=$ONEDNN_INSTALL_DIR"
  EXTRA_ARGS+=" -DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "dl-cifar" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DDNNLROOT=$ONEDNN_INSTALL_DIR -DMKLROOT=$ONEMKL_INSTALL_DIR -DMKLSINGLELIB=On"
  EXTRA_ARGS+=" -DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "easywave" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "bitcracker" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "hashtable" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DGPU_AOT=-fsycl-targets=$SPV_AOT "
elif [ $1 == "QuickSilver" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DGPU_AOT=-fsycl-targets=$SPV_AOT "
else cd $1/SYCL; fi
echo cmake -B build_aot -S . -GNinja $EXTRA_ARGS 
cmake -B build_aot -S . -GNinja $EXTRA_ARGS  
cmake --build build_aot --verbose

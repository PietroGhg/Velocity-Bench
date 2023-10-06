source ~/dpcpp_host_device/setvars.sh
if [ $1 == "cudaSift" ] || [ $1 == "sobel_filter" ]; then 
  EXTRA_ARGS=-DOpenCV_DIR=~/opencv/build; 
  cd $1/SYCL
elif [ $1 == "ethminer" ]; then 
  cd $1; 
  export Boost_DIR=~/dpcpp_host_device/deps/boost_1_73_0/install
  export ethash_DIR=~/dpcpp_host_device/deps/ethash-0.4.3/install
  export jsoncpp_DIR=~/dpcpp_host_device/deps/jsoncpp-1.9.5/install
  export OPENSSL_ROOT_DIR=~/dpcpp_host_device/deps/openssl-OpenSSL_1_1_1f/install
  EXTRA_ARGS="-DETHASHCUDA=OFF -DETHASHSYCL=ON -DUSE_SYS_OPENCL=OFF  -DBINKERN=OFF -DETHASHCL=OFF"
elif [ $1 == "hplinpack" ]; then
  cd $1/dpcpp/hpl-2.3
  export DNNLROOT=/opt/intel/oneapi/dnnl/2023.2.0/cpu_dpcpp_gpu_dpcpp
  make arch=nativecpu -j8
  exit
elif [ $1 == "reverse_time_migration" ]; then 
  cd $1;
  EXTRA_ARGS="-DCMAKE_BUILD_TYPE=RELEASE  -DUSE_DPC=ON -DUSE_OpenCV=ON  -DDATA_PATH=data -DWRITE_PATH=results  -DOpenCV_DIR=~/opencv/build "
elif [ $1 == "SeisAcoMod2D" ]; then
  export OMPI_CXX=clang++
  export OMPI_CC=clang
  export CXX=mpic++
  export CC=mpicc
  cd $1/SYCL
elif [ $1 == "svm" ]; then
  cd $1/SYCL
  export MKLROOT=/opt/intel/oneapi/mkl/2023.1.0
  EXTRA_FLAGS="-DMKLROOT=/opt/intel/oneapi/mkl "
elif [ $1 == "tsne" ]; then
  cd $1/SYCL
  export ONEDPLROOT=/home/pietro/dpcpp_host_device/oneDPL
elif [ $1 == "dl-mnist" ]; then
  cd $1/SYCL
  export DNNLROOT=/opt/intel/oneapi/dnnl/2023.2.0/cpu_dpcpp_gpu_dpcpp
else cd $1/SYCL; fi
cmake -B build_nativecpu -S . -GNinja -DUSE_NATIVE_CPU=On $EXTRA_ARGS
cmake --build build_nativecpu 

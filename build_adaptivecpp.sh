ONEDPL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneDPL
OPENCV_INSTALL_DIR=/home/pietro/native_cpu/opencv-4.x/build
export CXX=~/native_cpu/AdaptiveCpp/build/install/bin/acpp

if [ $1 == "tsne" ]; then
  cd $1/SYCL
  EXTRA_ARGS="-DONEDPLROOT=$ONEDPL_INSTALL_DIR"
elif [ $1 == "sobel_filter" ]; then 
  EXTRA_ARGS="-DOpenCV_DIR=$OPENCV_INSTALL_DIR -DNO_REQD_SUBGROUP_SIZE=On"
  cd $1/SYCL
elif [ $1 == "reverse_time_migration" ]; then 
  cd $1;
  EXTRA_ARGS="-DCMAKE_BUILD_TYPE=RELEASE  -DUSE_DPC=ON -DUSE_OpenCV=ON  -DDATA_PATH=data -DWRITE_PATH=results  -DOpenCV_DIR=$OPENCV_INSTALL_DIR"
  cmake -B./build_adaptivecpp $EXTRA_ARGS -H. -DCOMPRESSION=NO -DCOMPRESSION_PATH=.  -DUSE_ADAPTIVECPP=On -G Ninja
  cd build_adaptivecpp
  ninja Engine --verbose
  exit
else
  cd $1/SYCL
fi
cmake -B build_adaptivecpp -S . -DUSE_ADAPTIVECPP=On -G Ninja $EXTRA_ARGS
cmake --build build_adaptivecpp --verbose


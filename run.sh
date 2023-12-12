OPENCV_INSTALL_DIR=/home/pietro/native_cpu/opencv-4.x/build
ETHASH_INSTALL_DIR=/home/pietro/native_cpu/deps/ethash-0.4.3/install
JSONCPP_INSTALL_DIR=/home/pietro/native_cpu/deps/jsoncpp-1.9.5/install
OPENSSL_INSTALL_DIR=/home/pietro/native_cpu/deps/openssl-OpenSSL_1_1_1f/install
ONEMKL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneMKL/build/install
ONEDPL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneDPL
DNNL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneDNN/build/install
VANILLA_ONEMKL_INSTALL_DIR=/home/pietro/native_cpu/deps/oneMKL/build_vanilla/install

source ~/native_cpu/setvars.sh
if [ $1 == "cudaSift" ]; then 
  exit
elif [ $1 == "sobel_filter" ]; then 
  pushd sobel_filter/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu OPENCV_IO_MAX_IMAGE_PIXELS='1677721600' ./sobel_filter -i ../../res/silverfalls_2Kx2K.bmp -n 5
  popd
  pushd sobel_filter/SYCL/build_nativecpu
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu OPENCV_IO_MAX_IMAGE_PIXELS='1677721600' ./sobel_filter -i ../../res/silverfalls_2Kx2K.bmp -n 5
  exit
elif [ $1 == "ethminer" ]; then 
  exit
elif [ $1 == "hplinpack" ]; then
  exit
elif [ $1 == "QuickSilver" ]; then
  export QS_DEVICE=CPU 
  pushd QuickSilver/SYCL/build_nativecpu
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./qs -i ../../Examples/AllScattering/scatteringOnly.inp
  popd 
  pushd QuickSilver/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu ./qs -i ../../Examples/AllScattering/scatteringOnly.inp
  exit
elif [ $1 == "reverse_time_migration" ]; then 
  cd  reverse_time_migration
  mkdir results
  COMPUTE_JSON_FILE="computation_parameters_cpu.json"
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./build_nativecpu/Engine -p workloads/bp_model/${COMPUTE_JSON_FILE}
  RESULTS=`cat results/timing_results.txt | /bin/grep -wi MigrateShot -A4 | /bin/grep -wi Total`
  mv results results_nativecpu_complete
  mkdir results
  ONEAPI_DEVICE_SELECTOR=opencl:cpu ./build_vanilla/Engine -p workloads/bp_model/${COMPUTE_JSON_FILE}
  RESULTS=`cat results/timing_results.txt | /bin/grep -wi MigrateShot -A4 | /bin/grep -wi Total`
  mv results results_opencl_complete
  exit
elif [ $1 == "SeisAcoMod2D" ]; then
  source /opt/intel/oneapi/setvars.sh
  INPUT=twoLayer_model_5000x5000z_small.json
  #INPUT=sigsbee2a_3201x1201z.json
  pushd SeisAcoMod2D/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu mpiexec -n 2 ./SeisAcoMod2D ../../input/$INPUT
  popd
  pushd SeisAcoMod2D/SYCL/build_nativecpu
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu mpiexec -n 2 ./SeisAcoMod2D ../../input/$INPUT
  exit
elif [ $1 == "svm" ]; then
  pushd svm/SYCL/build_nativecpu
  LD_LIBRARY_PATH=$ONEMKL_INSTALL_DIR/lib:$LD_LIBRARY_PATH ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./svm_sycl a9a a.m
  popd
  pushd svm/SYCL/build_vanilla
  LD_LIBRARY_PATH=/home/pietro/native_cpu/deps/oneMKL/build_vanilla/install/lib:$LD_LIBRARY_PATH ONEAPI_DEVICE_SELECTOR=opencl:cpu ./svm_sycl a9a a.m
  exit
elif [ $1 == "tsne" ]; then
  pushd tsne/SYCL/build_nativecpu
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./tsne
  popd
  pushd tsne/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu ./tsne
  exit
elif [ $1 == "dl-mnist" ]; then
  pushd dl-mnist/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu ./dl-mnist-sycl -conv_algo ONEDNN_AUTO
  popd
  pushd dl-mnist/SYCL/build_nativecpu
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./dl-mnist-sycl -conv_algo ONEDNN_AUTO
  exit
elif [ $1 == "dl-cifar" ]; then
  pushd dl-cifar/SYCL/build_nativecpu
  LD_LIBRARY_PATH=$ONEMKL_INSTALL_DIR/lib:$LD_LIBRARY_PATH ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./dl-cifar_sycl  -dl_nw_size_type WORKLOAD_DEFAULT_SIZE
  exit
  popd
  pushd dl-cifar/SYCL/build_vanilla
  LD_LIBRARY_PATH=$VANILLA_ONEMKL_INSTALL_DIR/lib:$LD_LIBRARY_PATH ONEAPI_DEVICE_SELECTOR=opencl:cpu ./dl-cifar_sycl  -dl_nw_size_type WORKLOAD_DEFAULT_SIZE
  exit
elif [ $1 == "lc0" ]; then
  exit
elif [ $1 == "bitcracker" ]; then
  pushd bitcracker/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu ./bitcracker -f ../../hash_pass/img_win8_user_hash.txt -d ../../hash_pass/user_passwords_60000.txt -b 60000
  popd
  pushd bitcracker/SYCL/build_nativecpu
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./bitcracker -f ../../hash_pass/img_win8_user_hash.txt -d ../../hash_pass/user_passwords_60000.txt -b 60000
elif [ $1 == "easywave" ]; then
  pushd easywave/SYCL/build_nativecpu
  DATA_DIR=/home/pietro/native_cpu/Velocity-Bench/easywave/SYCL/build_nativecpu/easyWave-master/data
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./easyWave_sycl -grid $DATA_DIR/grids/e2Asean.grd -source $DATA_DIR/faults/BengkuluSept2007.flt -time 120
  popd
  pushd easywave/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu ./easyWave_sycl -grid $DATA_DIR/grids/e2Asean.grd -source $DATA_DIR/faults/BengkuluSept2007.flt -time 120 
elif [ $1 == "hashtable" ]; then
  pushd hashtable/SYCL/build_nativecpu
  ONEAPI_DEVICE_SELECTOR=native_cpu:cpu ./hashtable_sycl
  popd
  pushd hashtable/SYCL/build_vanilla
  ONEAPI_DEVICE_SELECTOR=opencl:cpu ./hashtable_sycl
else 
  echo "Unrecognized benchmark"
fi

if [ $1 == "bitcracker" ]; then
  pushd bitcracker/SYCL/build_adaptivecpp
  ./bitcracker -f ../../hash_pass/img_win8_user_hash.txt -d ../../hash_pass/user_passwords_60000.txt -b 60000
elif [ $1 == "sobel_filter" ]; then 
  pushd sobel_filter/SYCL/build_adaptivecpp
  OPENCV_IO_MAX_IMAGE_PIXELS='1677721600' ./sobel_filter -i ../../res/silverfalls_2Kx2K.bmp -n 5
elif [ $1 == "reverse_time_migration" ]; then 
  cd  reverse_time_migration
  mkdir results
  COMPUTE_JSON_FILE="computation_parameters_cpu.json"
  ./build_adaptivecpp/Engine -p workloads/bp_model/${COMPUTE_JSON_FILE}
  RESULTS=`cat results/timing_results.txt | /bin/grep -wi MigrateShot -A4 | /bin/grep -wi Total`
  mv results results_adaptivecpp_complete
fi

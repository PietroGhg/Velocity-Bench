build_thing() {
  echo Building subproject $1
  bash build_nativecpu.sh $1
}

build_thing bitcracker
build_thing cudaSift
build_thing dl-cifar
build_thing dl-mnist
build_thing easywave
build_thing ethminer
build_thing hashtable
build_thing hplinpack
build_thing lc0
build_thing QuickSilver
build_thing reverse_time_migration
build_thing SeisAcoMod2D
build_thing sobel_filter
build_thing svm
build_thing tsne

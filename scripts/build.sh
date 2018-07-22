#!/bin/bash
# -C no overwrite, -e stop at error, -u stop at undefined variable, -x print commands
set -Cx
if [ "${TENSORFLOW_VER}" == "" ]; then
	TENSORFLOW_VER=r1.8
fi
if [ "${PYTHON_VER}" == "" ]; then
	PYTHON_VER=3.7.0
fi

export PATH=~/.pyenv/bin:${PATH}

mkdir -p tensorflow
git clone https://github.com/tensorflow/tensorflow.git -b ${TENSORFLOW_VER} tensorflow/
cd tensorflow/
export PATH=/root/.pyenv/shims:$PATH

# see https://github.com/tensorflow/tensorflow/blob/master/configure.py
export PYTHON_BIN_PATH=$(which python)
export PYTHON_LIB_PATH="$($PYTHON_BIN_PATH -c 'import site; print(site.getsitepackages()[0])')"
export TF_NEED_S3=1
export TF_NEED_GCP=1
export TF_NEED_HDFS=1
export TF_NEED_JEMALLOC=1
export TF_NEED_CUDA=0
export TF_NEED_OPENCL=0
export TF_NEED_OPENCL_SYCL=0
export TF_DOWNLOAD_CLANG=0
export TF_NEED_KAFKA=0
export TF_ENABLE_XLA=0
export TF_NEED_VERBS=0
export TF_NEED_GDR=0
export TF_NEED_MKL=1
export TF_DOWNLOAD_MKL=1
export TF_NEED_MPI=0
export TF_SET_ANDROID_WORKSPACE=0

export GCC_HOST_COMPILER_PATH=$(which gcc)
export CC_OPT_FLAGS="-march=native"
bazel clean
./configure
bazel build -c opt \
	--copt=-mfpmath=both \
	--copt=-mavx \
	--copt=-mavx2 \
	--copt=-mfma \
	--copt=-msse4.1 \
	--copt=-msse4.2 \
	//tensorflow/tools/pip_package:build_pip_package
mkdir -p out
./bazel-bin/tensorflow/tools/pip_package/build_pip_package ../out/tensorflow_pkg

# Microbenchmark

|master|
|--|
| [![Build Status](https://travis-ci.com/rai-project/microbench.svg?branch=master)](https://travis-ci.com/rai-project/microbench)|

## Installing latest cmake

cmake version >=3.8 is required.
(there's a problem with hunter using cmake 3.10.2)

```
cd /tmp
wget https://cmake.org/files/v3.10/cmake-3.10.1-Linux-x86_64.sh
sudo sh cmake-3.10.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir
```
you may also want to remove the default installation `sudo apt-get remove cmake`

you need to install from source if on ppc64le

## Checkout all submodules

```
git submodule update --init --recursive
```

or to update

```
git submodule update --recursive --remote
```

## Compile

To compile the project run the following commands

    mkdir -p build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release -DUSE_CUDA_EVENTS=ON ..
    make
    
if you get errors about nvcc not supporting your gcc compiler, then you may want to use

    cmake -DCMAKE_BUILD_TYPE=Release -DUSE_CUDA_EVENTS=ON -DCMAKE_CUDA_HOST_COMPILER=`which gcc-6` ..  


## Available Benchmarks

The following micro-benchmarks are currently available

| Benchmarks            |
| --------------------- |
| CUDAMemcpyToGPU       |
| CUDAPinnedMemcpyToGPU |
| C_DAXPY               |
| C_SGEMM               |
| CUBLAS_SGEMM          |
| CUDA_SGEMM_BASIC      |
| CUDA_SGEMM_TILED      |
| CUDA_VECTOR_ADD       |

you can run each individually using

./bench --benchmark_filter=[name_of_benchmark]

for example

./bench --benchmark_filter=SGEMM

futher controls over the benchmarks are explained in the `--help` option

## Run all the benchmarks

    ./bench

The above will output to stdout somthing like 

    ------------------------------------------------------------------------------
    Benchmark                       Time           CPU Iterations UserCounters...
    ------------------------------------------------------------------------------
    SGEMM/1000/1/1/-1/1             5 us          5 us     126475 K=1 M=1000 N=1 alpha=-1 beta=1
    SGEMM/128/169/1728/1/0        539 us        534 us       1314 K=1.728k M=128 N=169 alpha=1 beta=0
    SGEMM/128/729/1200/1/0       1042 us       1035 us        689 K=1.2k M=128 N=729 alpha=1 beta=0
    SGEMM/192/169/1728/1/0        729 us        724 us        869 K=1.728k M=192 N=169 alpha=1 beta=0
    SGEMM/256/169/1/1/1             9 us          9 us      75928 K=1 M=256 N=169 alpha=1 beta=1
    SGEMM/256/729/1/1/1            35 us         35 us      20285 K=1 M=256 N=729 alpha=1 beta=1
    SGEMM/384/169/1/1/1            18 us         18 us      45886 K=1 M=384 N=169 alpha=1 beta=1
    SGEMM/384/169/2304/1/0       2475 us       2412 us        327 K=2.304k M=384 N=169 alpha=1 beta=0
    SGEMM/50/1000/1/1/1            10 us         10 us      73312 K=1 M=50 N=1000 alpha=1 beta=1
    SGEMM/50/1000/4096/1/0       6364 us       5803 us        100 K=4.096k M=50 N=1000 alpha=1 beta=0
    SGEMM/50/4096/1/1/1            46 us         45 us      13491 K=1 M=50 N=4.096k alpha=1 beta=1
    SGEMM/50/4096/4096/1/0      29223 us      26913 us         20 K=4.096k M=50 N=4.096k alpha=1 beta=0
    SGEMM/50/4096/9216/1/0      55410 us      55181 us         10 K=9.216k M=50 N=4.096k alpha=1 beta=0
    SGEMM/96/3025/1/1/1            55 us         51 us      14408 K=1 M=96 N=3.025k alpha=1 beta=1
    SGEMM/96/3025/363/1/0        1313 us       1295 us        570 K=363 M=96 N=3.025k alpha=1 beta=0

Output as JSON using

    ./bench --benchmark_out_format=json --benchmark_out=test.json
    
or preferably 


    ./bench --benchmark_out_format=json --benchmark_out=`hostname`.json

## On Minsky With PowerAI

```
cd build && rm -fr * && OpenBLAS=/opt/DL/openblas cmake -DUSE_CUDA_EVENTS=ON -DCMAKE_BUILD_TYPE=Release .. -DOpenBLAS=/opt/DL/openblas
```

## Disable CPU frequency scaling

If you see this error:

```
***WARNING*** CPU scaling is enabled, the benchmark real time measurements may be noisy and will incur extra overhead.
```

you might want to disable the CPU frequency scaling while running the benchmark:

```bash
sudo cpupower frequency-set --governor performance
./mybench
sudo cpupower frequency-set --governor powersave
```

## Run with Docker

Install `nvidia-docker`, then, list the available benchmarks.

    nvidia-docker run  --rm raiproject/microbench:amd64-latest bench --benchmark_list_tests

You can run benchmarks in the following way (probably with the `--benchmark_filter` flag).

    nvidia-docker run --privileged --rm -v `readlink -f .`:/data -u `id -u`:`id -g` raiproject/microbench:amd64-latest ./numa-separate-process.sh dgx bench /data/sync2


* `--privileged` is needed to set the NUMA policy for NUMA benchmarks.
* `` -v `readlink -f .`:/data `` maps the current directory into the container as `/data`.
* `` --benchmark_out=/data/\`hostname`.json `` tells the `bench` binary to write out to `/data`, which is mapped to the current directory.
* `` -u `id -u`:`id -g` `` tells docker to run as user `id -u` and group `id -g`, which is the current user and group. This means that files that docker produces will be modifiable from the host system without root permission.

## Hunter Toolchain File

If some of the third-party code compiled by hunter needs a different compiler, you can create a cmake toolchain file to set various cmake variables that will be globally used when building that code. You can then pass this file into cmake

    cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake ...

## Adding a new benchmark

You may start by duplicating `src/example`.

    cp src/example src/newbenchmark

To build the benchmark, you will need to inform the build system about the new benchmark. Run

    tools/genenerate_sugar_files.py

## Resources

* https://github.com/google/benchmark

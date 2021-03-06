# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED SUGAR_CMAKE_)
  return()
else()
  set(SUGAR_CMAKE_ 1)
endif()

include(sugar_files)
include(sugar_include)

sugar_include(um-coherence)
sugar_include(gemv)
sugar_include(numaum-latency)
sugar_include(numamemcpy)
sugar_include(launch)
sugar_include(utils)
sugar_include(example)
sugar_include(lock)
sugar_include(axpy)
sugar_include(conv)
sugar_include(vectoradd)
sugar_include(numa)
sugar_include(gemm)
sugar_include(init)
sugar_include(numaum-coherence)
sugar_include(memcpy)
sugar_include(um-prefetch)
sugar_include(numaum-prefetch)
sugar_include(atomic)

sugar_files(
    BENCHMARK_HEADERS
    config.hpp
)

sugar_files(
    BENCHMARK_SOURCES
    main.cpp
)


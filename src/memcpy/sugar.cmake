# This file generated automatically by:
#   generate_sugar_files.py
# see wiki for more info:
#   https://github.com/ruslo/sugar/wiki/Collecting-sources

if(DEFINED MEMCPY_SUGAR_CMAKE_)
  return()
else()
  set(MEMCPY_SUGAR_CMAKE_ 1)
endif()

include(sugar_files)

sugar_files(
    BENCHMARK_HEADERS
    args.hpp
)

sugar_files(
    BENCHMARK_SOURCES
    host_to_gpu.cpp
    gpu_to_pinned.cpp
    gpu_to_host.cpp
    gpu_to_gpu_peer.cpp
    pinned_to_gpu.cpp
)


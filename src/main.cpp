

#include <benchmark/benchmark.h>

#include "config.hpp"
#include "cuda_info.hpp"
#include "flags.hpp"
#include "init.hpp"
#include "utils.hpp"

int main(int argc, char **argv) {
  init(argc, argv);
  benchmark::Initialize(&argc, argv);
  // if (::benchmark::ReportUnrecognizedArguments(argc, argv)) return 1;
  benchmark::RunSpecifiedBenchmarks();
}

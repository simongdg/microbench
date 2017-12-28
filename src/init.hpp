#pragma once

#include "spdlog/spdlog.h"

#include "flags.hpp"

namespace utils {
namespace logger {
extern std::shared_ptr<spdlog::logger> console;
}
} // namespace utils

#define LOG(level, ...) utils::logger::console->level(__VA_ARGS__)

static void init(int argc, char **argv) { init_flags(argc, argv); }

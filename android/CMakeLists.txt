# Copyright (c) 2020 smarsufan. All Rights Reserved.

cmake_minimum_required(VERSION 3.6.0)
project(audio_crash)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -O3")

link_directories(arm64)

add_library(audio_crash SHARED audio_crash.cc)
target_link_libraries(
  audio_crash
  -Wl,--whole-archive
  libaudio_crash.a
  libavcodec.a
  libavfilter.a
  libavformat.a
  libavutil.a
  libswresample.a
  libswscale.a
  -Wl,--no-whole-archive
)

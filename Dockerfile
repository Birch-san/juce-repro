FROM ubuntu:22.04

# install juceaide dependencies:
RUN apt-get update -qq && \
apt-get install -qqy --no-install-recommends \
git wget ca-certificates \
xz-utils cmake build-essential pkg-config \
libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libfreetype6-dev && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/*
COPY download_llvm_mingw.sh download_llvm_mingw.sh
ARG LLVM_MINGW_VER=20220209
RUN LLVM_MINGW_VER=$LLVM_MINGW_VER ./download_llvm_mingw.sh download_llvm_mingw.sh
RUN mkdir -p /opt/llvm-mingw && tar -xvf llvm-mingw.tar.xz --strip-components=1 -C /opt/llvm-mingw && rm llvm-mingw.tar.xz
ENV PATH="/opt/llvm-mingw/bin:$PATH"
COPY x86_64_toolchain.cmake x86_64_toolchain.cmake
COPY i686_toolchain.cmake i686_toolchain.cmake
COPY clone_juce.sh clone_juce.sh
RUN ./clone_juce.sh
COPY configure_juceaide.sh configure_juceaide.sh
RUN ./configure_juceaide.sh
COPY build_juceaide.sh build_juceaide.sh
RUN ./build_juceaide.sh
COPY fix_mingw_headers.sh fix_mingw_headers.sh
RUN ./fix_mingw_headers.sh
# x86_64 or i686
ARG XARCH=x86_64
COPY configure_audio_plugin.sh configure_audio_plugin.sh
RUN XARCH=$XARCH ./configure_audio_plugin.sh
COPY build_audio_plugin.sh build_audio_plugin.sh
RUN ./build_audio_plugin.sh
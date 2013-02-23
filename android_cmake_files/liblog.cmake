#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
CLEAR_VARS()

set(liblog_sources logd_write.c)

# Don't care right now!
# some files must not be compiled when building against Mingw
# they correspond to features not used by our host development tools
# which are also hard or even impossible to port to native Win32
#WITH_MINGW :=
#ifeq ($(HOST_OS),windows)
#    ifeq ($(strip $(USE_CYGWIN)),)
#        WITH_MINGW := true
#    endif
#endif
## USE_MINGW is defined when we build against Mingw on Linux
#ifneq ($(strip $(USE_MINGW)),)
#    WITH_MINGW := true
#endif
#
if(NOT ${WITH_MINGW})
    concat(liblog_sources
        logprint.c
        event_tag_map.c
        )
endif()

set(liblog_host_sources ${liblog_sources} fake_log_device.c)


# # Shared and static library for host
# # ========================================================
# LOCAL_MODULE := liblog
# LOCAL_SRC_FILES := $(liblog_host_sources)
# LOCAL_LDLIBS := -lpthread
# LOCAL_CFLAGS := -DFAKE_LOG_DEVICE=1
# include $(BUILD_HOST_STATIC_LIBRARY)
# 
# include $(CLEAR_VARS)
# LOCAL_MODULE := liblog
# LOCAL_WHOLE_STATIC_LIBRARIES := liblog
# include $(BUILD_HOST_SHARED_LIBRARY)
# 
# 
# # Static library for host, 64-bit
# # ========================================================
# include $(CLEAR_VARS)
# LOCAL_MODULE := lib64log
# LOCAL_SRC_FILES := $(liblog_host_sources)
# LOCAL_LDLIBS := -lpthread
# LOCAL_CFLAGS := -DFAKE_LOG_DEVICE=1 -m64
# include $(BUILD_HOST_STATIC_LIBRARY)


# Shared and static library for target
# ========================================================
#CLEAR_VARS()
#set(LOCAL_MODULE log_static)
##set(LOCAL_SRC_FILES ${liblog_sources})
## For now, fake log it
#set(LOCAL_SRC_FILES ${liblog_host_sources})
#BUILD_STATIC_LIBRARY()

CLEAR_VARS()
set(LOCAL_MODULE log)
#set(LOCAL_SRC_FILES ${liblog_sources})
# For now, fake log it
set(LOCAL_SRC_FILES ${liblog_host_sources})
set(LOCAL_LDLIBS -lpthread)
set(LOCAL_CFLAGS -DFAKE_LOG_DEVICE=1)
BUILD_SHARED_LIBRARY()

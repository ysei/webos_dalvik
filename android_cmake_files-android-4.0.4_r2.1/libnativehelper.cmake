# Copyright (C) 2009 The Android Open Source Project
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


set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(libnativehelper_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING "" FORCE)

#
# Common definitions for host and device.
#

set(src_files
    JNIHelp.cpp
    Register.cpp
    )

set(c_includes
    ${JNI_H_INCLUDE}
    )

# Any shared/static libs required by libcore
# need to be mentioned here as well.
# TODO: fix this requirement

set(shared_libraries
    crypto  
    icui18n 
    icuuc   
    ssl
    )

set(static_libraries
    javacore 
    fdlibm
    )



#
# Build for the target (device).
#

CLEAR_VARS()

set(LOCAL_SRC_FILES ${src_files})
set(LOCAL_C_INCLUDES ${c_includes})
set(LOCAL_STATIC_LIBRARIES ${static_libraries})
set(LOCAL_SHARED_LIBRARIES ${shared_libraries} cutils expat log z) #stlport libz)
set(LOCAL_MODULE_TAGS optional)
set(LOCAL_MODULE nativehelper)

BUILD_SHARED_LIBRARY()


# #
# # Build for the host.
# #
# 
# ifeq ($(WITH_HOST_DALVIK),true)
# 
#     include $(CLEAR_VARS)
# 
#     LOCAL_SRC_FILES := $(src_files)
#     LOCAL_C_INCLUDES := $(c_includes)
#     LOCAL_WHOLE_STATIC_LIBRARIES := $(static_libraries:%=%-host)
# 
#     ifeq ($(HOST_OS)-$(HOST_ARCH),darwin-x86)
#         # OSX has a lot of libraries built in, which we don't have to
#         # bother building; just include them on the ld line.
#         LOCAL_LDLIBS := -lexpat -lssl -lz -lcrypto -licucore
#     else
#         LOCAL_SHARED_LIBRARIES := $(shared_libraries)
#         LOCAL_STATIC_LIBRARIES := libcutils libexpat liblog libz
#     endif
# 
#     LOCAL_MODULE_TAGS := optional
#     LOCAL_MODULE := libnativehelper
#     include $(BUILD_HOST_STATIC_LIBRARY)
# 
# endif
# 

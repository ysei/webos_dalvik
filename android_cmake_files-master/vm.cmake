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
# Android.mk for Dalvik VM.
#
# This makefile builds both for host and target, and so the very large
# swath of common definitions are factored out into a separate file to
# minimize duplication.
#
# If you enable or disable optional features here (or in Dvm.mk),
# rebuild the VM with:
#
#  make clean-libdvm clean-libdvm_assert clean-libdvm_sv clean-libdvm_interp
#  make -j4 libdvm
#

set(LOCAL_PATH ${CMAKE_CURRENT_SOURCE_DIR})
set(vm_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING "" FORCE)

#
# Build for the target (device).
#

if(${TARGET_CPU_SMP})
    set(target_smp_flag -DANDROID_SMP=1)
else()
    set(target_smp_flag -DANDROID_SMP=0)
endif()
set(host_smp_flag -DANDROID_SMP=1)

# Build the installed version (libdvm.so) first
#set(WITH_JIT true)
# FIXME: Figure out how to turn on JIT
set(WITH_JIT false)
android_include(ReconfigureDvm.cmake)

# Add some missing link libs I can't seem to find
concat(LOCAL_LDLIBS -lpthread -lrt)
# Overwrite default settings
set(LOCAL_MODULE dvm)
concat(LOCAL_CFLAGS ${target_smp_flag})

# TODO: Work on this later
# # Define WITH_ADDRESS_SANITIZER to build an ASan-instrumented version of the
# # library in /system/lib/asan/libdvm.so.
# ifneq ($(strip $(WITH_ADDRESS_SANITIZER)),)
#     LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/asan
#     LOCAL_ADDRESS_SANITIZER := true
#     LOCAL_CFLAGS := $(filter-out $(CLANG_CONFIG_UNKNOWN_CFLAGS),$(LOCAL_CFLAGS))
# endif

# TODO: split out the asflags.
set(LOCAL_ASFLAGS ${LOCAL_CFLAGS})

BUILD_SHARED_LIBRARY()

# # Derivation #1
# # Enable assertions and JIT tuning
# android_include(ReconfigureDvm.cmake)
# concat(LOCAL_CFLAGS -UNDEBUG -DDEBUG=1 -DLOG_NDEBUG=1 -DWITH_DALVIK_ASSERT
#                 -DWITH_JIT_TUNING ${target_smp_flag})
# set(LOCAL_MODULE dvm_assert)
# BUILD_SHARED_LIBRARY()

#ifneq ($(dvm_arch),mips)    # MIPS support for self-verification is incomplete
#
#    # Derivation #2
#    # Enable assertions and JIT self-verification
#    include $(LOCAL_PATH)/ReconfigureDvm.mk
#    LOCAL_CFLAGS += -UNDEBUG -DDEBUG=1 -DLOG_NDEBUG=1 -DWITH_DALVIK_ASSERT \
#                    -DWITH_SELF_VERIFICATION $(target_smp_flag)
#    # TODO: split out the asflags.
#    LOCAL_ASFLAGS := $(LOCAL_CFLAGS)
#    LOCAL_MODULE := dvm_sv
#    include $(BUILD_SHARED_LIBRARY)
#
#endif # dvm_arch!=mips

# # Derivation #3
# # Compile out the JIT
# set(WITH_JIT false)
# android_include(ReconfigureDvm.cmake)
# concat(LOCAL_CFLAGS ${target_smp_flag})
# # TODO: split out the asflags.
# set(LOCAL_ASFLAGS ${LOCAL_CFLAGS})
# set(LOCAL_MODULE dvm_interp)
# BUILD_SHARED_LIBRARY()


# #
# # Build for the host.
# #
# 
# ifeq ($(WITH_HOST_DALVIK),true)
# 
#     include $(CLEAR_VARS)
# 
#     # Variables used in the included Dvm.mk.
#     dvm_os := $(HOST_OS)
#     dvm_arch := $(HOST_ARCH)
#     # Note: HOST_ARCH_VARIANT isn't defined.
#     dvm_arch_variant := $(HOST_ARCH)
#     WITH_JIT := true
#     include $(LOCAL_PATH)/Dvm.mk
# 
#     LOCAL_SHARED_LIBRARIES += libcrypto libssl libicuuc libicui18n
# 
#     LOCAL_LDLIBS := -lpthread -ldl
#     ifeq ($(HOST_OS),linux)
#       # need this for clock_gettime() in profiling
#       LOCAL_LDLIBS += -lrt
#     endif
# 
#     # Build as a WHOLE static library so dependencies are available at link
#     # time. When building this target as a regular static library, certain
#     # dependencies like expat are not found by the linker.
#     LOCAL_WHOLE_STATIC_LIBRARIES += libexpat libcutils libdex liblog libz
# 
#     # The libffi from the source tree should never be used by host builds.
#     # The recommendation is that host builds should always either
#     # have sufficient custom code so that libffi isn't needed at all,
#     # or they should use the platform's provided libffi. So, if the common
#     # build rules decided to include it, axe it back out here.
#     ifneq (,$(findstring libffi,$(LOCAL_SHARED_LIBRARIES)))
#         LOCAL_SHARED_LIBRARIES := \
#             $(patsubst libffi, ,$(LOCAL_SHARED_LIBRARIES))
#     endif
# 
#     LOCAL_CFLAGS += $(host_smp_flag)
#     # TODO: split out the asflags.
#     LOCAL_ASFLAGS := $(LOCAL_CFLAGS)
#     LOCAL_MODULE_TAGS := optional
#     LOCAL_MODULE := libdvm
# 
#     include $(BUILD_HOST_SHARED_LIBRARY)
# 
#     # Copy the dalvik shell script to the host's bin directory
#     include $(CLEAR_VARS)
#     LOCAL_IS_HOST_MODULE := true
#     LOCAL_MODULE_TAGS := optional
#     LOCAL_MODULE_CLASS := EXECUTABLES
#     LOCAL_MODULE := dalvik
#     include $(BUILD_SYSTEM)/base_rules.mk
# $(LOCAL_BUILT_MODULE): $(LOCAL_PATH)/dalvik | $(ACP)
# 	@echo "Copy: $(PRIVATE_MODULE) ($@)"
# 	$(copy-file-to-new-target)
# 	$(hide) chmod 755 $@
# 
# endif

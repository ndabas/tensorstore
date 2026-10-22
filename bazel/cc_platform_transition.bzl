# Copyright 2026 The TensorStore Authors
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

"""Rule for building a C/C++ library for a different target platform.

This is used to build individual libraries with a different C++ toolchain, such
as clang-cl, which is selected by a constraint on the target platform.
"""

load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")

def _platform_transition_impl(_settings, attr):
    return {"//command_line_option:platforms": str(attr.platform)}

_platform_transition = transition(
    implementation = _platform_transition_impl,
    inputs = [],
    outputs = ["//command_line_option:platforms"],
)

def _cc_platform_transition_impl(ctx):
    dep = ctx.attr.dep[0]
    return [
        dep[CcInfo],
        DefaultInfo(files = dep[DefaultInfo].files),
    ]

cc_platform_transition = rule(
    doc = "Forwards the CcInfo of `dep` built for the target `platform`.",
    implementation = _cc_platform_transition_impl,
    attrs = {
        "dep": attr.label(
            mandatory = True,
            providers = [CcInfo],
            cfg = _platform_transition,
        ),
        "platform": attr.label(mandatory = True),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    provides = [CcInfo],
)

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
"""CMake implementation of "@tensorstore//bazel:cc_platform_transition.bzl".

CMake builds every target with the same toolchain, so the platform transition
is replaced by an alias to `dep`.
"""

# pylint: disable=invalid-name,missing-function-docstring,relative-beyond-top-level

from .. import native_rules_alias
from ..starlark.invocation_context import RelativeLabel
from ..starlark.scope_common import ScopeCommon
from ..starlark.select import Configurable
from .register import register_bzl_library


@register_bzl_library("@tensorstore//bazel:cc_platform_transition.bzl")
class CcPlatformTransitionLibrary(ScopeCommon):

  def bazel_cc_platform_transition(
      self,
      name: str,
      dep: Configurable[RelativeLabel],
      visibility: list[RelativeLabel] | None = None,
      **kwargs,
  ):
    del kwargs
    native_rules_alias.alias(
        self._context, name=name, actual=dep, visibility=visibility
    )

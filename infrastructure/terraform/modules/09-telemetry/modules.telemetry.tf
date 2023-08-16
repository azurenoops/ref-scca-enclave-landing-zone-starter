# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# The following random id is created once per module instantiation and is appended to the teleletry deployment name
resource "random_id" "telem" {
  count       = local.disable_telemetry ? 0 : 1
  byte_length = 4
}
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of google_maps_flutter;

/// Define the options for the map clusters
///
@immutable
class ClusterOption {
  const ClusterOption({
    this.color = true
  }) : assert(color != false);

  final bool color;
}

Map<String, dynamic> _serializeClusterOption(ClusterOption clusterOption) {
  assert(clusterOption != null);

  final Map<String, dynamic> optionsMap = <String, dynamic>{};

  void addIfNonNull(String fieldName, dynamic value) {
    if (value != null) {
      optionsMap[fieldName] = value;
    }
  }

  addIfNonNull('color', clusterOption.color);

  return optionsMap;
}
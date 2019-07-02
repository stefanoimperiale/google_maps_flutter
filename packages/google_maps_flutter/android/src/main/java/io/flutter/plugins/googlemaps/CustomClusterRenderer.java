// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import android.content.Context;
import android.graphics.Bitmap;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.maps.android.clustering.Cluster;
import com.google.maps.android.clustering.ClusterManager;
import com.google.maps.android.clustering.view.DefaultClusterRenderer;
import com.google.maps.android.ui.IconGenerator;

import java.util.Map;

public class CustomClusterRenderer extends DefaultClusterRenderer<ClusterItemController> {

  private final Context context;
  private final IconGenerator mClusterIconGenerator;
  private Map<String, Object> clusterOption;

  CustomClusterRenderer(
      Context context, GoogleMap map, ClusterManager<ClusterItemController> clusterManager) {
    super(context, map, clusterManager);
    this.context = context;
    this.mClusterIconGenerator = new IconGenerator(context.getApplicationContext());
  }

  @SuppressWarnings("unchecked")
  void setClusterOption(Object clusterOption) {
    this.clusterOption = (Map<String, Object>) clusterOption;
  }

  @Override
  protected void onBeforeClusterItemRendered(
      ClusterItemController item, MarkerOptions markerOptions) {
    markerOptions.icon(item.getIcon()).snippet(item.getTitle());
  }

  @Override
  protected void onBeforeClusterRendered(Cluster<ClusterItemController> cluster, MarkerOptions markerOptions) {
    if (clusterOption != null) {
      final Bitmap icon = mClusterIconGenerator.makeIcon("SIZE" + cluster.getSize());
      markerOptions.icon(BitmapDescriptorFactory.
              fromBitmap(icon));
    }
  }
}

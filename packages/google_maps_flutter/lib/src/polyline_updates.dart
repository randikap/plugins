// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of google_maps_flutter;

/// [Polyline] update events to be applied to the [GoogleMap].
///
/// Used in [GoogleMapController] when the map is updated.
class _PolylineUpdates {
  /// Computes [_PolylineUpdates] given previous and current [Polylines]s.
  _PolylineUpdates.from(Set<Polyline> previous, Set<Polyline> current) {
    if (previous == null) {
      previous = Set<Polyline>.identity();
    }

    if (current == null) {
      current = Set<Polyline>.identity();
    }

    final Map<PolylineId, Polyline> previousPolylines = _keyByPolylineId(previous);
    final Map<PolylineId, Polyline> currentPolylines = _keyByPolylineId(current);

    final Set<PolylineId> prevPolylinesIds = previousPolylines.keys.toSet();
    final Set<PolylineId> currentPolylinesIds = currentPolylines.keys.toSet();

    Polyline idToCurrentPolyline(PolylineId id) {
      return currentPolylines[id];
    }

    final Set<PolylineId> _polylineIdsToRemove =
        prevPolylinesIds.difference(currentPolylinesIds);

    final Set<Polyline> _polylinesToAdd = currentPolylinesIds
        .difference(prevPolylinesIds)
        .map(idToCurrentPolyline)
        .toSet();

    final Set<Polyline> _polylinesToChange = currentPolylinesIds
        .intersection(prevPolylinesIds)
        .map(idToCurrentPolyline)
        .toSet();

    polylinesToAdd = _polylinesToAdd;
    polylineIdsToRemove = _polylineIdsToRemove;
    polylinesToChange = _polylinesToChange;
  }

  Set<Polyline> polylinesToAdd;
  Set<PolylineId> polylineIdsToRemove;
  Set<Polyline> polylinesToChange;

  Map<String, dynamic> _toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('polylinesToAdd', _serializePolylineSet(polylinesToAdd));
    addIfNonNull('polylinesToChange', _serializePolylineSet(polylinesToChange));
    addIfNonNull('polylineIdsToRemove',
        polylineIdsToRemove.map<dynamic>((PolylineId m) => m.value).toList());

    return updateMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final _PolylineUpdates typedOther = other;
    return setEquals(polylinesToAdd, typedOther.polylinesToAdd) &&
        setEquals(polylineIdsToRemove, typedOther.polylineIdsToRemove) &&
        setEquals(polylinesToChange, typedOther.polylinesToChange);
  }

  @override
  int get hashCode =>
      hashValues(polylinesToAdd, polylineIdsToRemove, polylinesToChange);

  @override
  String toString() {
    return '_PolylineUpdates{polylinesToAdd: $polylinesToAdd, '
        'polylineIdsToRemove: $polylineIdsToRemove, '
        'polylinesToChange: $polylinesToChange}';
  }
}

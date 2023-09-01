import 'dart:math';

import 'package:rtiow/math.dart';
import 'package:rtiow/ray.dart';
import 'package:rtiow/vector3.dart';

class Camera {
  late final Vector3 _origin;
  late final Vector3 _horizontal;
  late final Vector3 _vertical;
  late final Vector3 _lowerLeftCorner;
  late final Vector3 _u;
  late final Vector3 _v;
  late final Vector3 _w;
  late final double _lensRadius;

  Camera({
    required Vector3 lookFrom,
    required Vector3 lookAt,
    required Vector3 vUp,
    required double vFov,
    required double aspectRatio,
    required double aperture,
    required double focusDistance,
  }) {
    var theta = vFov.radians;
    var h = tan(theta / 2);
    var viewportHeight = 2.0 * h;
    var viewportWidth = aspectRatio * viewportHeight;

    _w = (lookFrom - lookAt).normalized;
    _u = Vector3.cross(vUp, _w).normalized;
    _v = Vector3.cross(_w, _u);

    _origin = lookFrom;
    _horizontal = _u * viewportWidth * focusDistance;
    _vertical = _v * viewportHeight * focusDistance;
    _lowerLeftCorner =
        _origin - _horizontal / 2 - _vertical / 2 - _w * focusDistance;
    _lensRadius = aperture / 2;
  }

  Ray castRay(double s, double t) {
    var rd = Vector3.randomInUnitDisk() * _lensRadius;
    var offset = _u * rd.x + _v * rd.y;
    return Ray(
        origin: _origin + offset,
        direction: _lowerLeftCorner +
            _horizontal * s +
            _vertical * t -
            _origin -
            offset);
  }
}

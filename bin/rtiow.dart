import 'dart:collection';

import 'package:rtiow/camera.dart';
import 'package:rtiow/canvas.dart';
import 'package:rtiow/dielectric.dart';
import 'package:rtiow/hittable.dart';
import 'package:rtiow/hittable_list.dart';
import 'package:rtiow/lambertian.dart';
import 'package:rtiow/math.dart';
import 'package:rtiow/metal.dart';
import 'package:rtiow/ray_tracer.dart';
import 'package:rtiow/sphere.dart';
import 'package:rtiow/vector3.dart';

HittableList _randomScene() {
  var ground = Lambertian(Color.all(0.5));
  var world = HittableList(
      [Sphere(radius: 1000.0, center: Vector3(y: -1000.0), material: ground)]);

  for (var a = -11; a < 11; a++) {
    for (var b = -11; b < 11; b++) {
      var chooseMat = randomDouble();
      var center =
          (Vector3.of(a + 0.9 * randomDouble(), 0.2, b + 0.9 * randomDouble()));

      if ((center - Vector3(x: 4.0, y: 0.2)).length > 0.9) {
        if (chooseMat < 0.8) {
          var albedo = Color.mul(Color.random(), Color.random());
          world.add(Sphere(
              center: center, radius: 0.2, material: Lambertian(albedo)));
        } else {
          if (chooseMat < 0.95) {
            var albedo = Color.randomInside(min: 0.5, max: 1.0);
            var fuzz = randomDoubleInside(min: 0.0, max: 0.5);
            world.add(Sphere(
                center: center,
                radius: 0.2,
                material: Metal(albedo: albedo, fuzz: fuzz)));
          } else {
            world.add(
                Sphere(center: center, radius: 0.2, material: Dielectric(1.5)));
          }
        }
      }
    }
  }

  var dielectric = Dielectric(1.5);
  var lambertian = Lambertian(Color.of(0.4, 0.2, 0.1));
  var metal = Metal(albedo: Color.of(0.7, 0.6, 0.5), fuzz: 0);

  return world
    ..addAll([
      Sphere(center: Vector3(y: 1.0), radius: 1.0, material: dielectric),
      Sphere(
          center: Vector3.of(-4.0, 1.0, 0.0),
          radius: 1.0,
          material: lambertian),
      Sphere(center: Vector3(x: 4.0, y: 1.0), radius: 1.0, material: metal),
    ]);
}

Color _rayColor(int x, int y, Canvas canvas, Camera camera, Hittable world) {
  var color = Color();
  for (int s = 0; s < canvas.samplesPerPixel; s++) {
    var u = (x + randomDouble()) / (canvas.imageWidth - 1);
    var v = (y + randomDouble()) / (canvas.imageHeight - 1);
    var ray = camera.castRay(u, v);
    color += rayColor(ray, world, 50);
  }
  return color;
}

Future<void> main() async {
  var world = _randomScene();
  var canvas =
      Canvas(imageWidth: 100, aspectRatio: 3.0 / 2.0, samplesPerPixel: 100);
  var lookFrom = Vector3.of(13.0, 2.0, 3.0);
  var lookAt = Vector3();
  var vUp = Vector3(y: 1.0);
  var distToFocus = 10.0;
  var aperture = 0.1;
  var camera = Camera(
    lookFrom: lookFrom,
    lookAt: lookAt,
    vUp: vUp,
    aspectRatio: canvas.aspectRatio,
    vFov: 20.0,
    aperture: aperture,
    focusDistance: distToFocus,
  );

  var coords = Queue<(int, int)>();
  for (int x = 0; x < canvas.imageWidth; x++) {
    for (int y = 0; y < canvas.imageHeight; y++) {
      coords.add((x, y));
    }
  }

  while (coords.isNotEmpty) {
    var (x, y) = coords.removeFirst();
    var color = _rayColor(x, y, canvas, camera, world);
    canvas.writeColor(color, x, y);
  }

  await canvas.writeImage();
}

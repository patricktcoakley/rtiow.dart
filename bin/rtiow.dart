import 'package:rtiow/camera.dart';
import 'package:rtiow/canvas.dart';
import 'package:rtiow/dielectric.dart';
import 'package:rtiow/hittable_list.dart';
import 'package:rtiow/lambertion.dart';
import 'package:rtiow/math.dart';
import 'package:rtiow/metal.dart';
import 'package:rtiow/ray_tracer.dart';
import 'package:rtiow/sphere.dart';
import 'package:rtiow/vector3.dart';

HittableList randomScene() {
  var ground = Lambertion(Color.all(0.5));
  var world = HittableList(
      [Sphere(radius: 1000, center: Vector3(y: -1000), material: ground)]);

  for (var a = -11; a < 11; a++) {
    for (var b = -11; b < 11; b++) {
      var chooseMat = randomDouble();
      var center =
          (Vector3.of(a + 0.9 * randomDouble(), 0.2, b + 0.9 * randomDouble()));

      if ((center - Vector3(x: 4, y: 0.2)).length > 0.9) {
        if (chooseMat < 0.8) {
          var albedo = Color.mul(Color.random(), Color.random());
          world.add(Sphere(
              center: center, radius: 0.2, material: Lambertion(albedo)));
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
  var lambertion = Lambertion(Color.of(0.4, 0.2, 0.1));
  var metal = Metal(albedo: Color.of(0.7, 0.6, 0.5), fuzz: 0);

  return world
    ..addAll([
      Sphere(center: Vector3(y: 1), radius: 1, material: dielectric),
      Sphere(center: Vector3.of(-4, 1, 0), radius: 1, material: lambertion),
      Sphere(center: Vector3(x: 4, y: 1), radius: 1, material: metal),
    ]);
}

void main() {
  var world = randomScene();
  var canvas =
      Canvas(imageWidth: 200, aspectRatio: 3.0 / 2.0, samplesPerPixel: 100);
  var lookFrom = Vector3.of(13, 2, 3);
  var lookAt = Vector3();
  var vUp = Vector3(y: 1);
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

  for (int y = canvas.imageHeight - 1; y >= 0; y--) {
    for (int x = canvas.imageWidth - 1; x >= 0; x--) {
      var color = Color();
      for (int s = 0; s < canvas.samplesPerPixel; s++) {
        var u = (x + randomDouble()) / (canvas.imageWidth - 1);
        var v = (y + randomDouble()) / (canvas.imageHeight - 1);
        var ray = camera.castRay(u, v);
        color += rayColor(ray, world, 50);
      }
      canvas.writeColor(color, x, canvas.imageHeight - y - 1);
    }
  }

  canvas.writeImage();
}

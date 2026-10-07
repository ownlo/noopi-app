import 'dart:convert';
import 'dart:io';

import 'package:image/image.dart' as im;

void main() {
  final rigs = <String, dynamic>{};
  for (final name in ['noopi', 'woopi', 'dangbi']) {
    final x = im.decodePng(
      File('assets/splash/greeting/$name.png').readAsBytesSync(),
    )!;
    final xs = [0, (x.width * .39).round(), (x.width * .72).round(), x.width];
    final ys = [0, (x.height * .535).round(), x.height];
    final parts = <List<int>>[];
    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < 3; col++) {
        var l = xs[col + 1], t = ys[row + 1], r = xs[col], b = ys[row];
        for (var yy = ys[row]; yy < ys[row + 1]; yy++) {
          for (var xx = xs[col]; xx < xs[col + 1]; xx++) {
            if (x.getPixel(xx, yy).a > 160) {
              if (xx < l) l = xx;
              if (xx > r) r = xx;
              if (yy < t) t = yy;
              if (yy > b) b = yy;
            }
          }
        }
        if (r <= l || b <= t) throw StateError('Missing $name $row $col');
        l = (l - 3).clamp(xs[col], xs[col + 1]);
        t = (t - 3).clamp(ys[row], ys[row + 1]);
        r = (r + 4).clamp(xs[col], xs[col + 1]);
        b = (b + 4).clamp(ys[row], ys[row + 1]);
        parts.add([l, t, r - l, b - t]);
      }
    }
    rigs[name] = parts;
    stdout.writeln('$name $parts');
  }
  File('assets/splash/greeting/rigs.json')
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(rigs));
}

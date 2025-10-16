import 'dart:math';

class RandomNumberGenerator {
  final Random _random = Random();

  int generate() {
    return _random.nextInt(1025) + 1; // nextInt(1025) donne [0..1024]
  }
}

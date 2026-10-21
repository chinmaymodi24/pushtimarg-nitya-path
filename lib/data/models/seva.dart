import 'package:flutter/material.dart';

class Seva {
  const Seva(this.id, this.icon);
  final String id;
  final IconData icon;

  /// Translation key for the seva name.
  String get nameKey => 'seva_$id';
}

const sevaList = <Seva>[
  Seva('mangla', Icons.wb_sunny_outlined),
  Seva('shringar', Icons.local_florist_outlined),
  Seva('gwal', Icons.grass_outlined),
  Seva('rajbhog', Icons.rice_bowl_outlined),
  Seva('utthapan', Icons.wb_twilight_outlined),
  Seva('bhog', Icons.restaurant_outlined),
  Seva('sandhya', Icons.local_fire_department_outlined),
  Seva('shayan', Icons.nightlight_outlined),
];

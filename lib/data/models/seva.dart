class Seva {
  const Seva(this.id, this.icon);
  final String id;

  /// SVG name under assets/icons.
  final String icon;

  String get nameKey => 'seva_$id';
  String get subKey => 'seva_${id}_sub';
}

const sevaList = <Seva>[
  Seva('mangla', 'sun'),
  Seva('shringar', 'lotus'),
  Seva('gwal', 'cow'),
  Seva('rajbhog', 'thali'),
  Seva('utthapan', 'leaf'),
  Seva('bhog', 'matki'),
  Seva('sandhya', 'diya'),
  Seva('shayan', 'moon'),
];

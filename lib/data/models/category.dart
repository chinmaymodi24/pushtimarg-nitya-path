/// A group of paths in the Paths tab. Grouped by author or by kind of
/// composition, in the app's own order.
class PathCategory {
  const PathCategory(this.id, this.icon);
  final String id;

  /// SVG name under assets/icons.
  final String icon;

  String get nameKey => 'cat_$id';
  String get subKey => 'cat_${id}_sub';

  /// Short name for the Home grid.
  String get shortKey => 'cat_${id}_short';
}

const categoryList = <PathCategory>[
  PathCategory('nitya', 'sun'),
  PathCategory('shodash', 'lotus'),
  PathCategory('mahaprabhuji', 'flower'),
  PathCategory('gusaiji', 'leaf'),
  PathCategory('hariraiji', 'diya'),
  PathCategory('raghunathji', 'matki'),
  PathCategory('yamunaji', 'wave'),
  PathCategory('geet', 'flute'),
  PathCategory('dhol', 'music'),
  PathCategory('kavach', 'shield'),
  PathCategory('siddhant', 'book'),
];

PathCategory categoryById(String id) => categoryList.firstWhere(
  (c) => c.id == id,
  orElse: () => categoryList.first,
);

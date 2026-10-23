/// A group of paths in the Paths tab. Grouped by author or by kind of
/// composition, in the app's own order.
class PathCategory {
  const PathCategory(this.id, this.icon);
  final String id;

  /// SVG name under assets/icons.
  final String icon;

  String get nameKey => 'cat_$id';
  String get subKey => 'cat_${id}_sub';
}

const categoryList = <PathCategory>[
  PathCategory('nitya', 'sun'),
  PathCategory('shodash', 'lotus'),
  PathCategory('mahaprabhuji', 'flower'),
  PathCategory('gusaiji', 'book_closed'),
  PathCategory('hariraiji', 'book_stack'),
  PathCategory('raghunathji', 'pothi'),
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

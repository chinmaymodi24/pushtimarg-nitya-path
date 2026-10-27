/// A group of paths in the Paths tab. Grouped by author or by kind of
/// composition, in the app's own order.
class PathCategory {
  const PathCategory(this.id, this.icon);
  final String id;

  /// SVG name under assets/icons.
  final String icon;

  String get nameKey => 'cat_$id';
}

/// The book's own order: an opening group, then its eleven "pushpa".
const categoryList = <PathCategory>[
  PathCategory('intro', 'sun'),
  PathCategory('p1', 'book_closed'),
  PathCategory('p2', 'granth'),
  PathCategory('p3', 'book_stack'),
  PathCategory('p4', 'book_ribbon'),
  PathCategory('p5', 'wave'),
  PathCategory('p6', 'flower'),
  PathCategory('p7', 'bhagavat'),
  PathCategory('p8', 'leaf'),
  PathCategory('p9', 'music'),
  PathCategory('p10', 'shield'),
  PathCategory('p11', 'diya'),
];

PathCategory categoryById(String id) => categoryList.firstWhere(
  (c) => c.id == id,
  orElse: () => categoryList.first,
);

import 'guide_diagram.dart';

class NonogramGuideItem {
  const NonogramGuideItem({
    required this.title,
    required this.description,
    required this.diagrams,
  });

  final String title;
  final String description;
  final List<GuideDiagram> diagrams;
}

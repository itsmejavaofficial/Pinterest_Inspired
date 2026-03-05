/// Model representing a Pinterest-style pin/post card.
class PinModel {
  final String imageUrl;
  final String title;
  final String saves;
  final double aspectRatio;
  final List<String> tags;

  const PinModel({
    required this.imageUrl,
    required this.title,
    required this.saves,
    required this.aspectRatio,
    required this.tags,
  });

  /// Default sample pins used in the Explore tab.
  static List<PinModel> get samplePins => List.generate(8, (i) => PinModel(
    imageUrl: 'https://picsum.photos/300/${[500,380,620,420,550,340,580,450][i]}?random=$i',
    aspectRatio: [1.4, 0.95, 1.8, 1.1, 1.55, 0.85, 1.65, 1.2][i],
    title: [
      'Cozy Reading Nook',
      'Minimal Kitchen',
      'Scandinavian Bedroom',
      'Plant Corner Vibes',
      'Japandi Living Room',
      'Coffee Aesthetic',
      'Rooftop Garden',
      'Neutral Palette Home',
    ][i],
    saves: ['2.1k', '856', '4.3k', '1.7k', '3.9k', '612', '2.8k', '1.4k'][i],
    tags: i.isEven ? ['Home', 'Decor'] : ['Kitchen', 'Minimalism'],
  ));
}
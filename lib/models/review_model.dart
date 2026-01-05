class ReviewModel {
  final int id;
  final String name;
  final double rating;
  final String comment;

  ReviewModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      name: json['user'] != null
          ? json['user']['username'] ?? 'Anonymous'
          : 'Anonymous',
      rating: double.parse(json['stars'].toString()), // pastikan double
      comment: json['comment'] ?? '',
    );
  }
}

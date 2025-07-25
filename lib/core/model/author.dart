class AuthorModel {
  final String name;
  final String image;

  AuthorModel({
    required this.name,
    required this.image,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  factory AuthorModel.fromValue(String name, String image) {
    return AuthorModel(name: name, image: image);
  }
}
class BannerModel {
  final int id;
  final String image;
  final String path;

  BannerModel({required this.id, required this.image, required this.path});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      path: json['path'],
    );
  }
}

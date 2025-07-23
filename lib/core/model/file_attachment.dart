class AttachmentFile {
  final String name;
  final String url;

  AttachmentFile({required this.name, required this.url});

  factory AttachmentFile.fromJson(Map<String, dynamic> json) {
    return AttachmentFile(name: json['name'], url: json['url']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}
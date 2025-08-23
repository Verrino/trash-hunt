class Trash {
  final String type;
  final String description;

  Trash({required this.type, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
    };
  }

  factory Trash.fromJson(Map<String, dynamic> json) {
    return Trash(
      type: json['type'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
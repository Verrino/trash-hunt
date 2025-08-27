class Trash {
  final String trashId;
  final String type;
  final String description;

  Trash({required this.trashId, required this.type, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'trashId': trashId,
      'type': type,
      'description': description,
    };
  }

  factory Trash.fromJson(Map<String, dynamic> json, String id) {
    return Trash(
      trashId: id,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
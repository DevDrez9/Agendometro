class ServiciosClass {
  int id;
  String serviceName;
  String description;
  int durationMinutes;
  double price;
  bool isActive;
  String createdBy;
  String updatedBy;
  String deletedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  ServiciosClass({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  ServiciosClass.empty()
      : id = 0,
        serviceName = "",
        description = "",
        durationMinutes = 0,
        price = 0,
        isActive = false,
        createdBy = "",
        updatedBy = "",
        deletedBy = "",
        deletedAt = "",
        createdAt = "",
        updatedAt = "";

  // Método fromJson para deserializar un JSON a un objeto de tipo Service
  factory ServiciosClass.fromJson(Map<String, dynamic> json) {
    return ServiciosClass(
      id: json['id'] ?? 0,
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      price: json['price'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      deletedBy: json['deletedBy'] ?? '',
      deletedAt: json['deletedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  // Método toJson para serializar un objeto de tipo Service a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'description': description,
      'durationMinutes': durationMinutes,
      'price': price,
      'isActive': isActive,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'deletedBy': deletedBy,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

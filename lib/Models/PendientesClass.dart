class PendientesClass {
  String? commentary;
  String notes;
  int? score;
  String? scheduleStartTime;
  String? scheduleEndTime;
  int scheduleId;
  int? employeeId;
  int progressState;
  int workId;

  double price;
  int sessions;
  String service_name;
  String customer_nombre, customer_apellido_paterno, customer_apellido_materno;
  String employee_nombre, employee_apellido_paterno;

  PendientesClass(
      {this.commentary,
      required this.notes,
      this.score,
      this.scheduleStartTime,
      this.scheduleEndTime,
      required this.scheduleId,
      this.employeeId,
      required this.progressState,
      required this.workId,
      required this.price,
      required this.sessions,
      required this.service_name,
      required this.customer_nombre,
      required this.customer_apellido_paterno,
      required this.customer_apellido_materno,
      required this.employee_apellido_paterno,
      required this.employee_nombre});

  // Constructor vacío
  factory PendientesClass.empty() {
    return PendientesClass(
        commentary: null,
        notes: "",
        score: null,
        scheduleStartTime: null,
        scheduleEndTime: null,
        scheduleId: 0,
        employeeId: null,
        progressState: 0,
        workId: 0,
        price: 0,
        sessions: 0,
        service_name: "",
        customer_nombre: "",
        customer_apellido_materno: "",
        customer_apellido_paterno: "",
        employee_nombre: "",
        employee_apellido_paterno: "");
  }

  // Método fromJson
  factory PendientesClass.fromJson(Map<String, dynamic> json) {
    return PendientesClass(
      commentary: json['commentary'],
      notes: json['notes'] ?? "",
      score: json['score'],
      scheduleStartTime: json['schedule_start_time'],
      scheduleEndTime: json['schedule_end_time'],
      scheduleId: json['schedule_id'] ?? 0,
      employeeId: json['employee_id'],
      progressState: json['progress_state'] ?? 0,
      workId: json['work_id'] ?? 0,
      service_name: json['service_name'] ?? '',
      customer_nombre: json['customer_nombre'] ?? '',
      customer_apellido_paterno: json['customer_apellido_paterno'] ?? '',
      customer_apellido_materno: json['customer_apellido_materno'] ?? '',
      employee_nombre: json['employee_nombre'] ?? '',
      employee_apellido_paterno: json['employee_apellido_paterno'] ?? '',
      price: json['price'] ?? 0,
      sessions: json['sessions'] ?? 0,
    );
  }
}

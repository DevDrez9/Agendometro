import 'package:agendometro/Utilidades/GlobalVariables.dart';

class CustomerServiceRequest {
  int customerId;
  int serviceId;
  List<DtoSchedule> dtoSchedules;
  int progressState;
  double price;
  int sessions;
  List<Pago> pagos;

  CustomerServiceRequest({
    required this.customerId,
    required this.serviceId,
    required this.dtoSchedules,
    required this.progressState,
    required this.price,
    required this.sessions,
    required this.pagos,
  });

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'serviceId': serviceId,
      'dtoSchedules':
          dtoSchedules.map((schedule) => schedule.toJson()).toList(),
      'progressState': progressState,
      'price': price,
      'sessions': sessions,
      'pagos': pagos.map((pago) => pago.toJson()).toList(),
    };
  }
}

class DtoSchedule {
  int employeeId;
  String scheduleStartTime;
  String scheduleEndTime;
  int progressState;
  String notes;

  DtoSchedule({
    required this.employeeId,
    required this.scheduleStartTime,
    required this.scheduleEndTime,
    required this.progressState,
    required this.notes,
  });

  DtoSchedule.empy()
      : employeeId = GlobalVariables.instance.mainUsuario.idUsuario,
        scheduleStartTime = "",
        scheduleEndTime = "",
        progressState = 0,
        notes = "";

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'scheduleStartTime': scheduleStartTime,
      'scheduleEndTime': scheduleStartTime,
      'progressState': progressState,
      'notes': notes,
    };
  }
}

class Pago {
  String fecha;
  String tipo;
  double monto;
  List<FormaPago> formaPagos;

  Pago({
    required this.fecha,
    required this.tipo,
    required this.monto,
    required this.formaPagos,
  });

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'tipo': tipo,
      'monto': monto,
      'formaPagos': formaPagos.map((formaPago) => formaPago.toJson()).toList(),
    };
  }
}

class FormaPago {
  String tipo;
  double monto;

  FormaPago({
    required this.tipo,
    required this.monto,
  });

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'monto': monto,
    };
  }
}

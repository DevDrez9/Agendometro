import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Models/ClienteClass.dart';
import 'package:agendometro/Models/DtoSchedules.dart';
import 'package:agendometro/Models/EspecialistasClass.dart';
import 'package:agendometro/Models/ServiciosClass.dart';
import 'package:agendometro/Pages/HomePage2.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Utilidades/Alerta.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:agendometro/Utilidades/LoadingDialog.dart';
import 'package:agendometro/Widgets/BotonPrimario.dart';
import 'package:agendometro/Widgets/BotonSegundario.dart';
import 'package:agendometro/Widgets/BuscadorClientes.dart';
import 'package:agendometro/Widgets/BuscadorEspecialistas.dart';
import 'package:agendometro/Widgets/BuscadorServicios.dart';
import 'package:agendometro/Widgets/CustomDropdown.dart';
import 'package:agendometro/Widgets/DatePicker.dart';
import 'package:agendometro/Widgets/DropdownHoras.dart';
import 'package:agendometro/Widgets/Pagar.dart';
import 'package:agendometro/Widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

class AgendarPage extends StatefulWidget {
  const AgendarPage({super.key});

  @override
  State<AgendarPage> createState() => _AgendarPageState();
}

class _AgendarPageState extends State<AgendarPage> {
  final _formKeyAgendar = GlobalKey<FormState>();
  TextEditingController controllerCliente = TextEditingController();
  TextEditingController controllerPrecio = TextEditingController();
  TextEditingController controllerSesiones = TextEditingController();
  TextEditingController controllerEspecialista = TextEditingController();
  TextEditingController controllerServicio = TextEditingController();
  TextEditingController controllerPagar = TextEditingController();

  int sesiones = 1;
  int contador = 1;

  ClienteClass clienteSelect = ClienteClass.empty();
  ServiciosClass servicioSelect = ServiciosClass.empty();
  EspecialistaClass especialistaSelect = EspecialistaClass.empty();

  List<List<String>> listaHorasPorSesion = [];
  List<DtoSchedule> listaCitas = [];

  bool validarCitas = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerSesiones.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            child: Form(
      key: _formKeyAgendar,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //textInput(controller: controllerCliente, labelText: "Cliente"),
        BuscadorClientes(
          buscarClientes: buscarClientes,
          controller: controllerCliente,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecciona un cliente'; // Validador personalizado
            }
            return null;
          },
          onAgregarCliente: agregarCliente,
          onClienteSeleccionado: (value) {
            setState(() {
              clienteSelect = value;
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        BuscadorServicios(
          buscarServicio: buscarServicios,
          controller: controllerServicio,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecciona un servicio'; // Validador personalizado
            }
            return null;
          },
          onServicioSeleccionado: (value) {
            setState(() {
              servicioSelect = value;
              controllerPrecio.text = value.price.toString();
            });
          },
        ),

        SizedBox(
          height: 5,
        ),
        BuscadorEspecialistas(
          buscarEspecilista: buscarEspecialista,
          controller: controllerEspecialista,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecciona un cliente'; // Validador personalizado
            }
            return null;
          },
          onEspecialistaSeleccionado: (value) {
            setState(() {
              especialistaSelect = value;
            });
          },
        ),

        SizedBox(
          height: 5,
        ),
        textInput(
          controller: controllerPrecio,
          labelText: "Total Servicio",
          isNumberOnly: true,
          icon: Icons.monetization_on,
        ),
        SizedBox(
          height: 5,
        ),
        textInput(
            controller: controllerSesiones,
            labelText: "Numero de Sesiones",
            icon: Icons.format_list_numbered_rounded,
            isNumberOnly: true,
            onChanged: (value) {
              setState(() {
                sesiones = int.parse(value);
                contador = sesiones;
              });
            }),

        SizedBox(
          height: 5,
        ),
        Center(
          child: Column(
            children: List.generate(contador, (index) {
              // Inicializa la lista de horas para cada sesión si no existe
              while (listaHorasPorSesion.length <= index) {
                listaHorasPorSesion.add([]);

                listaCitas.add(DtoSchedule.empy());

                print(listaCitas.length);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DatePickerField(
                      label: "Sesion ${index + 1}",
                      onDateSelected: (date) async {
                        print(
                            "Fecha seleccionada en sesión ${index + 1}: $date");
                        // Realiza la consulta al servidor
                        List<String> horas =
                            await buscarHoras(date.replaceAll("/", "-"));

                        // Actualiza el estado con las horas obtenidas
                        setState(() {
                          if (listaHorasPorSesion.length <= index) {
                            listaHorasPorSesion.add([]);
                          }
                          listaHorasPorSesion[index] = horas;
                        });
                      },
                    ),
                    SizedBox(width: 5),
                    DropdownHoras(
                      label: "Hora sesion ${index + 1}",
                      items: listaHorasPorSesion.length > index
                          ? listaHorasPorSesion[index]
                          : [],
                      onChanged: (value) {
                        // Maneja el cambio de valor en el Dropdown
                        print(
                            "Hora seleccionada en sesión ${index + 1}: $value");

                        // Verificar si ya existe una cita para esta sesión
                        setState(() {
                          listaCitas[index] = DtoSchedule.empy();
                          listaCitas[index].scheduleStartTime = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        validarCitas
            ? Container(
                width: AppTheme.mainSize - 3,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                decoration: BoxDecoration(
                    color: Color.fromARGB(59, 230, 57, 71),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  "Seleccione al menos una cita.",
                  style: TextStyle(color: AppThemeColors.error),
                ),
              )
            : Container(),

        textInput(
            controller: controllerPagar,
            labelText: "Monto a Pagar",
            isNumberOnly: true,
            icon: Icons.monetization_on,
            isValidatorEnabled: false),

        SizedBox(
          height: 10,
        ),
        /* SecondaryButton(
            text: "Pagar",
            onPressed: () {
              if (_formKeyAgendar.currentState!.validate()) {
                setState(() async {
                  pagarSelect = (await showFullScreenPagar(
                      context,
                      servicioSelect.serviceName,
                      "${especialistaSelect.person.nombre} ${especialistaSelect.person.apellidoPaterno}",
                      "${clienteSelect.nombre} ${clienteSelect.apellidoPaterno}",
                      controllerPrecio.text,
                      0))!;
                  print(pagarSelect.monto);
                });
              }
            }),*/
        SizedBox(
          height: 10,
        ),
        PrimaryButton(
            text: "Agendar",
            onPressed: () {
              if (_formKeyAgendar.currentState!.validate()) {
                if (listaCitas[0].scheduleStartTime != "") {
                  LoadingDialog.showLoadingDialog(context, "Registrando...");
                  setState(() {
                    validarCitas = false;
                  });
                  print("Employee " + especialistaSelect.id.toString());

                  for (var element in listaCitas) {
                    element.employeeId = especialistaSelect.id;
                  }
                  listaCitas.removeWhere((cita) =>
                      cita.scheduleStartTime == "" ||
                      cita.scheduleStartTime!.isEmpty);

                  List<Pago> listaPago = [];
                  if (!controllerPagar.text.isEmpty) {
                    Pago pagarSelect = Pago(
                        fecha: listaCitas[0].scheduleStartTime,
                        tipo: "",
                        monto: double.parse(controllerPagar.text),
                        formaPagos: []);
                    listaPago.add(pagarSelect);
                  }

                  CustomerServiceRequest crearCita = CustomerServiceRequest(
                      customerId: clienteSelect.idPersona,
                      serviceId: servicioSelect.id,
                      dtoSchedules: listaCitas,
                      progressState: 0,
                      price: double.parse(controllerPrecio.value.text),
                      sessions: int.parse(controllerSesiones.text),
                      pagos: listaPago);

                  print(crearCita.toJson().toString());

                  guardarCita(crearCita);
                } else {
                  setState(() {
                    validarCitas = true;
                  });
                }
              }
            })
      ]),
    )));
  }

  Future<List<ClienteClass>> buscarClientes(String query) async {
    // Lista de clientes de ejemplo (esto debería ser reemplazado por una llamada real al backend)

    List<ClienteClass> listaClientes = [];

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url13 +
            "/persona/v1/buscarempresatexto-simplificado"),
        headers: headers,
        body: json.encode(createSearchJson(
            idEmpresa: 111, page: 0, size: 10, textoBusqueda: query)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Json" +
              createSearchJson(
                      idEmpresa: 111, page: 0, size: 10, textoBusqueda: query)
                  .toString());
          print("Servidor " + jsonData.toString());

          if (jsonData['ENTITY']['content'] is List) {
            listaClientes = (jsonData['ENTITY']['content'] as List)
                .map((item) => ClienteClass.fromJson(item))
                .toList();
          } else {
            throw Exception("El campo 'content' no es una lista");
          }

          //return usuario;
        } catch (e) {
          print(" Buscador No Registrado " + "$e");
        }
      } else if (response.statusCode == 500) {
        print(response.body);
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print(
            "Buscador error No entro ${response.statusCode} ${response.body}");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Buscadorno conectado");

      //loginSqlite(login.usuario, login.contrasena, context);
    }

    // Filtra los clientes que coinciden con la consulta
    return listaClientes;
  }

  void agregarCliente(String nuevoCliente) {
    Navigator.pushNamed(context, 'registrar');
  }

  Map<String, dynamic> createSearchJson({
    required int idEmpresa,
    required int page,
    required int size,
    required String textoBusqueda,
  }) {
    return {
      "idempresa": idEmpresa,
      "page": page,
      "size": size,
      "textobusqueda": textoBusqueda,
    };
  }

  Future<List<ServiciosClass>> buscarServicios(String query) async {
    // Lista de clientes de ejemplo (esto debería ser reemplazado por una llamada real al backend)

    List<ServiciosClass> listaClientes = [];

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url12 + "/servicios/search"),
        headers: headers,
        body: json.encode(createSearchJson(
            idEmpresa: 111, page: 0, size: 10, textoBusqueda: query)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Servidor " + jsonData.toString());

          if (jsonData['content'] is List) {
            listaClientes = (jsonData['content'] as List)
                .map((item) => ServiciosClass.fromJson(item))
                .toList();
          } else {
            throw Exception("El campo 'content' no es una lista");
          }

          //return usuario;
        } catch (e) {
          print(" Servicio No Registrado " + "$e");
        }
      } else if (response.statusCode == 500) {
        print(response.body);
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print(
            "Servicio error No entro ${response.statusCode} ${response.body}");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Servicio no conectado");

      //loginSqlite(login.usuario, login.contrasena, context);
    }

    // Filtra los clientes que coinciden con la consulta
    return listaClientes;
  }

  Map<String, dynamic> createEspecialistaJson({
    required int idEmpresa,
    required int page,
    required int size,
    required String textoBusqueda,
  }) {
    return {
      "idEmpresa": idEmpresa,
      "page": page,
      "size": size,
      "textoBusqueda": textoBusqueda,
    };
  }

  Future<List<EspecialistaClass>> buscarEspecialista(String query) async {
    // Lista de clientes de ejemplo (esto debería ser reemplazado por una llamada real al backend)

    List<EspecialistaClass> listaEspecialistas = [];

    print(GlobalVariables.instance.mainUsuario.token);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url12 + "/employees/search"),
        headers: headers,
        body: json.encode(createSearchJson(
            idEmpresa: 111, page: 0, size: 10, textoBusqueda: query)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Servidor " + jsonData.toString());

          if (jsonData['content'] is List) {
            listaEspecialistas = (jsonData['content'] as List)
                .map((item) => EspecialistaClass.fromJson(item))
                .toList();
          } else {
            throw Exception("El campo 'content' no es una lista");
          }

          //return usuario;
        } catch (e) {
          print(" Servicio No Registrado " + "$e");
        }
      } else if (response.statusCode == 500) {
        print(response.body);
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print(
            "Servicio error No entro ${response.statusCode} ${response.body}");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Servicio no conectado");

      //loginSqlite(login.usuario, login.contrasena, context);
    }

    // Filtra los clientes que coinciden con la consulta
    return listaEspecialistas;
  }

  Map<String, dynamic> createHorasJson({
    required String fecha,
  }) {
    return {
      "startDate": fecha,
      "endDate": fecha,
      "startTime": "00:00",
      "endTime": "23:59",
      "range": 60,
      "idServicio": servicioSelect.id,
      "idEmpleado": especialistaSelect.id,
    };
  }

  Future<List<String>> buscarHoras(String query) async {
    // Lista de clientes de ejemplo (esto debería ser reemplazado por una llamada real al backend)

    List<String> listaHoras = [];

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url12 + "/schedules/free-times"),
        headers: headers,
        body: json.encode(createHorasJson(fecha: query)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Servidor " + jsonData.toString());

          if (jsonData is List) {
            listaHoras = (jsonData as List)
                .map((item) =>
                    item.toString()) // Convierte cada elemento a String
                .toList();
            return listaHoras;
          } else {
            print("error tipeado");
            return [];
          }

          //return usuario;
        } catch (e) {
          print(" Buscador No Registrado " + "$e");
          return [];
        }
      } else if (response.statusCode == 500) {
        print(response.body);
        return [];
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print(
            "Buscador error No entro ${response.statusCode} ${response.body}");
        return [];

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Buscadorno conectado");
      return [];

      //loginSqlite(login.usuario, login.contrasena, context);
    }

    // Filtra los clientes que coinciden con la consulta
  }

  guardarCita(CustomerServiceRequest nuevaCita) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url12 + "/works/notification"),
        headers: headers,
        body: json.encode(nuevaCita.toJson()),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        try {
          /* String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);*/
          // Extrae el objeto "tecnico"
          print("Guardado ");
          LoadingDialog.hideLoadingDialog(context);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage2()));
          Alerta(context, "Se Registro", "Se registro correctamente la cita.");

          //return usuario;
        } catch (e) {
          LoadingDialog.hideLoadingDialog(context);
          Alerta(context, "Error",
              "Error al intentar agendar, intentelo mas tarde.");

          print(" Error guardar " + "$e");
        }
      } else if (response.statusCode == 500) {
        print("Error guardar " + response.body);
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error", "Error al  agendar, intentelo mas tarde.");
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print("Guardar error No entro ${response.statusCode} ${response.body}");
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error", "Error al  agendar, intentelo mas tarde.");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Guadrdar conectado");
      LoadingDialog.hideLoadingDialog(context);
      Alerta(context, "Error",
          "Error al  conectarse al servidor, intentelo mas tarde.");

      //loginSqlite(login.usuario, login.contrasena, context);
    }

    // Filtra los clientes que coinciden con la consulta
  }
}

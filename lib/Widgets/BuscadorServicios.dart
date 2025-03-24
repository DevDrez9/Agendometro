import 'package:agendometro/Models/ServiciosClass.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

class BuscadorServicios extends StatefulWidget {
  final Future<List<ServiciosClass>> Function(String query)
      buscarServicio; // Función para buscar clientes en el backend
  final TextEditingController controller; // Controlador para el campo de texto
  final FormFieldValidator<String>? validator; // Validador opcional
  final Function(ServiciosClass)?
      onServicioSeleccionado; // Callback para seleccionar un cliente

  const BuscadorServicios({
    Key? key,
    required this.buscarServicio,
    required this.controller,
    this.validator,
    this.onServicioSeleccionado,
  }) : super(key: key);

  @override
  _BuscadorServiciosState createState() => _BuscadorServiciosState();
}

class _BuscadorServiciosState extends State<BuscadorServicios> {
  List<ServiciosClass> _resultados = []; // Lista de resultados del backend
  bool _mostrarDropdown = false; // Controla si se muestra el dropdown
  bool _buscando = false; // Controla si se está buscando

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el controlador para limpiar los resultados si el texto está vacío
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller
        .removeListener(_onControllerChanged); // Dejar de escuchar cambios
    super.dispose();
  }

  // Función para manejar cambios en el controlador
  void _onControllerChanged() {
    if (widget.controller.text.isEmpty) {
      setState(() {
        _resultados = [];
        _mostrarDropdown = false;
      });
    }
  }

  // Función para buscar clientes en el backend
  void _buscarServicio(String query) async {
    if (query.isEmpty) {
      setState(() {
        _resultados = [];
        _mostrarDropdown = false;
      });
      return;
    }

    setState(() {
      _buscando = true; // Mostrar indicador de carga
    });

    // Llama al backend para obtener resultados
    final resultados = await widget.buscarServicio(query);

    setState(() {
      _resultados = resultados;
      _mostrarDropdown = true; // Mostrar dropdown
      _buscando = false; // Ocultar indicador de carga
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.mainSize, // Ajusta el ancho
      child: Column(
        children: [
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: 'Nombre del servicio',
              suffixIcon: Icon(Icons.search), // Ícono de búsqueda
            ),
            onChanged:
                _buscarServicio, // Llama al backend cuando el texto cambia
            validator: widget.validator, // Validador personalizado
            onTap: () {
              // Borra el contenido al hacer clic
              widget.controller.clear();
            },
          ),
          if (_buscando) CircularProgressIndicator(), // Indicador de carga
          if (_mostrarDropdown)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  // Lista de resultados de búsqueda
                  if (_resultados.isNotEmpty)
                    ListView.builder(
                      shrinkWrap:
                          true, // Ajusta el tamaño del ListView al contenido
                      itemCount: _resultados.length,
                      itemBuilder: (context, index) {
                        final cliente = _resultados[index];
                        return ListTile(
                          title: Text(cliente.serviceName),
                          onTap: () {
                            setState(() {
                              widget.controller.text = cliente
                                  .serviceName; // Rellena el campo con el nombre del cliente seleccionado
                              _mostrarDropdown = false; // Oculta el dropdown
                            });
                            widget.onServicioSeleccionado?.call(cliente);
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

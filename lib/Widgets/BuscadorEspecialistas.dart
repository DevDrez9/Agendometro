import 'package:agendometro/Models/EspecialistasClass.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

class BuscadorEspecialistas extends StatefulWidget {
  final Future<List<EspecialistaClass>> Function(String query)
      buscarEspecilista; // Función para buscar clientes en el backend
  final TextEditingController controller; // Controlador para el campo de texto
  final FormFieldValidator<String>? validator; // Validador opcional
  final Function(EspecialistaClass)?
      onEspecialistaSeleccionado; // Callback para seleccionar un cliente

  const BuscadorEspecialistas({
    Key? key,
    required this.buscarEspecilista,
    required this.controller,
    this.validator,
    this.onEspecialistaSeleccionado,
  }) : super(key: key);

  @override
  _BuscadorEspecialistasState createState() => _BuscadorEspecialistasState();
}

class _BuscadorEspecialistasState extends State<BuscadorEspecialistas> {
  List<EspecialistaClass> _resultados = []; // Lista de resultados del backend
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
  void _buscarClientes(String query) async {
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
    final resultados = await widget.buscarEspecilista(query);

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
              labelText: 'Nombre del especialista',
              suffixIcon: Icon(Icons.search), // Ícono de búsqueda
            ),
            onChanged:
                _buscarClientes, // Llama al backend cuando el texto cambia
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
                          title: Text(cliente.person.nombre +
                              " " +
                              cliente.person.apellidoPaterno),
                          onTap: () {
                            setState(() {
                              widget.controller.text = cliente.person.nombre +
                                  " " +
                                  cliente.person
                                      .apellidoPaterno; // Rellena el campo con el nombre del cliente seleccionado
                              _mostrarDropdown = false; // Oculta el dropdown
                            });
                            widget.onEspecialistaSeleccionado?.call(
                                cliente); // Devuelve el objeto ClienteClass seleccionado
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

import 'package:agendometro/Models/ClienteClass.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:flutter/material.dart';

class BuscadorClientes extends StatefulWidget {
  final Future<List<ClienteClass>> Function(String query)
      buscarClientes; // Función para buscar clientes en el backend
  final TextEditingController controller; // Controlador para el campo de texto
  final FormFieldValidator<String>? validator; // Validador opcional
  final Function(ClienteClass)?
      onClienteSeleccionado; // Callback para seleccionar un cliente
  final Function(String)?
      onAgregarCliente; // Callback para agregar un nuevo cliente

  const BuscadorClientes({
    Key? key,
    required this.buscarClientes,
    required this.controller,
    this.validator,
    this.onClienteSeleccionado,
    this.onAgregarCliente,
  }) : super(key: key);

  @override
  _BuscadorClientesState createState() => _BuscadorClientesState();
}

class _BuscadorClientesState extends State<BuscadorClientes> {
  List<ClienteClass> _resultados = []; // Lista de resultados del backend
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
    final resultados = await widget.buscarClientes(query);

    setState(() {
      _resultados = resultados;
      _mostrarDropdown = true; // Mostrar dropdown
      _buscando = false; // Ocultar indicador de carga
    });
  }

  // Función para agregar un nuevo cliente
  void _agregarCliente() {
    final nuevoCliente = widget.controller.text;
    if (nuevoCliente.isNotEmpty) {
      widget.onAgregarCliente
          ?.call(nuevoCliente); // Llama al callback para agregar el cliente
      setState(() {
        _mostrarDropdown = false; // Oculta el dropdown
      });
    }
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
              labelText: 'Nombre del cliente',
              suffixIcon: Icon(Icons.search), // Ícono de búsqueda
            ),
            onChanged:
                _buscarClientes, // Llama al backend cuando el texto cambia
            validator: widget.validator, // Validador personalizado
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
                          title: Text(
                              cliente.nombre + " " + cliente.apellidoPaterno),
                          onTap: () {
                            setState(() {
                              widget.controller.text = cliente
                                  .nombre; // Rellena el campo con el nombre del cliente seleccionado
                              _mostrarDropdown = false; // Oculta el dropdown
                            });
                            widget.onClienteSeleccionado?.call(
                                cliente); // Devuelve el objeto ClienteClass seleccionado
                          },
                        );
                      },
                    ),
                  // Opción para agregar un nuevo cliente (siempre visible)
                  ListTile(
                    title: Text('Agregar '),
                    leading: Icon(Icons.add),
                    onTap: _agregarCliente,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

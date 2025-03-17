import 'package:agendometro/Pages/HomePage.dart';
import 'package:agendometro/Pages/HomePage2.dart';
import 'package:agendometro/Pages/RegistrarPage.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context)
              ]),
        ),
      );

  buildHeader(BuildContext context) => Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top));

  buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "Usuario: ${GlobalVariables.instance.mainUsuario.persona.nombre}"),
                  //  Text(GlobalVariables.instance.tecnico.nombre)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Rol: "),
                  // Text(GlobalVariables.instance.tecnico.codigo.toString())
                ],
              ),
            ],
          )),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage2()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person_add_alt_1,
              color: AppThemeColors.primary,
            ),
            title: const Text("Registrar Cliente"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RegistrarPage()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.assignment_rounded,
              color: AppThemeColors.primary,
            ),
            title: const Text("Solicitar Producto"),
            onTap: () {
              Navigator.pop(context);
              /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RutaPage(
                        accion: 0,
                      )));*/
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.import_contacts,
              color: AppThemeColors.primary,
            ),
            title: const Text("Importar Contactos"),
            onTap: () {
              Navigator.pop(context);
              /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RutaPage(
                        accion: 0,
                      )));*/
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(
              Icons.add_business_rounded,
              color: AppThemeColors.primary,
            ),
            title: const Text("Agregar Servicio"),
            onTap: () {
              Navigator.pop(context);
              /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RutaPage(
                        accion: 1,
                      )));*/
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.assignment_turned_in_rounded,
              color: AppThemeColors.primary,
            ),
            title: const Text("Solicitudes"),
            onTap: () {
              Navigator.pop(context);
              /*Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RutaPage(
                        accion: 1,
                      )));*/
            },
          ),

          /*ListTile(
            leading: const Icon(Icons.add_to_photos_rounded),
            title: const Text("Limpiar Memoria"),
            onTap: () {
              VaciarBD(context);
              Navigator.pop(context);
            },
          ),*/
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: const Text("Cerrar Sesion"),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          Text("")
        ],
      ));
}

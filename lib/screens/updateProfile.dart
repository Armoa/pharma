import 'package:flutter/material.dart';
import 'package:pharma/model/usuario_model.dart';
import 'package:pharma/screens/perfil_screen.dart';
import 'package:pharma/services/actualizar_usuario.dart';
import 'package:pharma/services/obtener_usuario.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  void _cargarDatosUsuario() async {
    UsuarioModel? usuario = await obtenerUsuarioDesdeMySQL();
    if (usuario != null) {
      setState(() {
        nameController.text = usuario.name;
        lastNameController.text = usuario.lastName;
        addressController.text = usuario.address;
        dateBirthController.text = usuario.dateBirth;
      });
    }
  }

  void _actualizarUsuario() async {
    bool success = await actualizarUsuarioEnMySQL(
      nameController.text,
      lastNameController.text,
      addressController.text,
      dateBirthController.text,
      // Add the remaining 6 required arguments below, replace with actual values or controllers as needed
      '', // arg5
      '', // arg6
      '', // arg7
      '', // arg8
      '', // arg9
      '', // arg10
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Perfil actualizado correctamente"),
          duration: Duration(seconds: 2),
        ),
      );
      // Volver a ProfileScreen y forzar recarga
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al actualizar perfil"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Actualizar perfil")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: "Apellido"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Dirección"),
            ),
            TextField(
              controller: dateBirthController,
              readOnly: true, // Hace que el campo sea solo lectura
              decoration: InputDecoration(labelText: "Fecha de nacimiento"),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900), // Rango mínimo
                  lastDate: DateTime.now(), // Rango máximo
                );

                if (pickedDate != null) {
                  setState(() {
                    dateBirthController.text =
                        "${pickedDate.toLocal()}".split(
                          ' ',
                        )[0]; // Formatear fecha
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _actualizarUsuario,
              child: Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }
}

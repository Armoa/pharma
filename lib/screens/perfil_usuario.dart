import 'package:flutter/material.dart';
import 'package:pharma/model/usuario_model.dart';
import 'package:pharma/screens/updateProfile.dart';
import 'package:pharma/services/obtener_usuario.dart';

class ProfileScreen2 extends StatelessWidget {
  const ProfileScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil del Usuario")),
      body: FutureBuilder<UsuarioModel?>(
        future: obtenerUsuarioDesdeMySQL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No se encontraron datos del usuario."));
          }

          UsuarioModel usuario = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      usuario.photo.isNotEmpty
                          ? NetworkImage(usuario.photo)
                          : AssetImage("assets/default_avatar.png")
                              as ImageProvider,
                ),
                SizedBox(height: 10),
                Text(
                  usuario.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  usuario.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Text("Dirección: ${usuario.address}"),
                Text("Fecha de nacimiento: ${usuario.dateBirth}"),
                Text("Fecha de registro: ${usuario.dateCreated}"),
                Text("ID: ${usuario.id}"),
                SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProfileScreen(),
                            ),
                          );
                        },
                        child: Text("Actualizar perfil"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

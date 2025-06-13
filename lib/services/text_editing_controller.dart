import 'package:flutter/material.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController barrioController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController razonSocialController = TextEditingController();
final TextEditingController rucController = TextEditingController();
final TextEditingController nombreUbicacionController = TextEditingController();
final TextEditingController numeroCasaController = TextEditingController();
final TextEditingController ciudadController = TextEditingController();
final TextEditingController calleController = TextEditingController();
final TextEditingController latitudController = TextEditingController();
final TextEditingController longitudController = TextEditingController();

void clearFormFields() {
  nameController.clear();
  lastNameController.clear();
  addressController.clear();
  cityController.clear();
  barrioController.clear();
  emailController.clear();

  phoneController.clear();
  razonSocialController.clear();
  rucController.clear();
}

@override
void dispose() {
  // Libera los recursos de los controladores
  nameController.dispose();
  lastNameController.dispose();
  addressController.dispose();
  cityController.dispose();
  barrioController.dispose();
  emailController.dispose();
  phoneController.dispose();
  razonSocialController.dispose();
  rucController.dispose();
}

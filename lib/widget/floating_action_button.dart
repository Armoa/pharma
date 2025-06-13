import 'package:flutter/material.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/screens/cart.dart';

class NewFloatingActionButton extends StatelessWidget {
  const NewFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreenView()),
        );
      },
      backgroundColor: AppColors.blueDark,
      shape: const CircleBorder(), // Color de fondo del botón
      child: const Icon(
        Icons.shopping_cart_outlined,
        color: AppColors.white,
      ), // Icono de carrito
    );
  }
}

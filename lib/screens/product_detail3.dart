// import 'package:flutter/material.dart';
// import 'package:pharma/model/product_model.dart';

// class ProductoScreen extends StatefulWidget {
//   const ProductoScreen({super.key, required Product data});

//   @override
//   ProductoScreenState createState() => ProductoScreenState();
// }

// class ProductoScreenState extends State<ProductoScreen> {
//   PageController pageController = PageController();
//   int currentIndex = 0;

//   void _changeProduct(int index) {
//     setState(() {
//       currentIndex = index;
//       pageController.animateToPage(
//         index,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Ficha de Producto")),
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView(
//               controller: pageController,
//               children: [
//                 _buildProductImage("assets/producto_30.png"),
//                 _buildProductImage("assets/producto_60.png"),
//                 _buildProductImage("assets/producto_90.png"),
//               ],
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildButton(0, "30"),
//               _buildButton(1, "60"),
//               _buildButton(2, "90"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductImage(String imagePath) {
//     return Center(child: Image.asset(imagePath));
//   }

//   Widget _buildButton(int index, String label) {
//     return ElevatedButton(
//       onPressed: () => _changeProduct(index),
//       child: Text(label),
//     );
//   }
// }

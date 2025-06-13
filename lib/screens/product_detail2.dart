import 'package:flutter/material.dart';
import 'package:pharma/model/card_model.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/model/product_model.dart';
import 'package:pharma/provider/auth_provider.dart';
import 'package:pharma/provider/cart_provider.dart';
import 'package:pharma/screens/cart.dart';
import 'package:pharma/screens/login.dart';
import 'package:provider/provider.dart';

String numberFormat(String x) {
  List<String> parts = x.toString().split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');
  parts[0] = parts[0].replaceAll(re, '.');
  if (parts.length == 1) {
    parts.add('');
  } else {
    parts[1] = parts[1].padRight(2, '0').substring(0, 2);
  }
  return parts.join('');
}

class ProductDetail2 extends StatefulWidget {
  final Product data;

  const ProductDetail2({super.key, required this.data});

  @override
  State<ProductDetail2> createState() => ProductDetail2State();
}

class ProductDetail2State extends State<ProductDetail2> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _changeProduct(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedQuantity = 1;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"), // Imagen local
          fit: BoxFit.contain,
          opacity: 0.4,
        ),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 250, 254, 255),
            const Color.fromARGB(255, 232, 234, 235),
          ],
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset("assets/logo.png", height: 40)],
          ),

          leading: Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: InkWell(
              onTap: () => Navigator.pop(context),

              child: Icon(
                Icons.arrow_circle_left,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),

          backgroundColor: Colors.transparent,
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreenView()),
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Icon(Icons.shopping_bag_outlined, color: Colors.black),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              flex: 6, // 60% de la altura
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Center(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        children: [
                          _buildProductImage(widget.data.image),
                          _buildProductImage(widget.data.image),
                          _buildProductImage(widget.data.image),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton(0, "30"),
                          SizedBox(height: 10),
                          _buildButton(1, "60"),
                          SizedBox(height: 10),
                          _buildButton(2, "90"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4, // 40% de la altura
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 210, 248, 229),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 340,
                            child: Text(
                              widget.data.name,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.data.categoryName.toString(),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 90, 90, 90),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₲${numberFormat(widget.data.price)}',
                            style: TextStyle(fontSize: 30),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                child: Center(
                                  child: Text(
                                    "12",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox(height: 20)),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(color: Colors.black),
                                backgroundColor: AppColors.blueDark,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              onPressed: () {
                                final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                );

                                if (!authProvider.isAuthenticated) {
                                  // Si el usuario no está logeado, redirigirlo a LoginScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                  return; // Detiene la ejecución
                                }

                                final cartItem = CartItem(
                                  id: widget.data.id,
                                  name: widget.data.name,
                                  price: double.parse(widget.data.price),
                                  image: widget.data.image,
                                  quantity: 1,
                                );
                                Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                ).addToCart(cartItem, selectedQuantity);

                                // Mostrar el SnackBar después de agregar el producto
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${widget.data.name} añadido al carrito",
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.shopping_basket_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Añadir',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(String imagePath) {
    return Center(child: Image.network(imagePath));
  }

  Widget _buildButton(int index, String label) {
    return ElevatedButton(
      onPressed: () => _changeProduct(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentIndex == index ? Colors.black : Colors.black38,
        foregroundColor:
            _currentIndex == index ? Colors.amber[400] : Colors.grey[800],
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.amber[400], fontSize: 20),
      ),
    );
  }
}

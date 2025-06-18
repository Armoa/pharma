import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pharma/model/card_model.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/model/product_model.dart';
import 'package:pharma/provider/auth_provider.dart';
import 'package:pharma/provider/cart_provider.dart';
import 'package:pharma/screens/cart.dart';
import 'package:pharma/screens/fullscreen_image.dart';
import 'package:pharma/screens/login.dart';
import 'package:pharma/widget/btn_wishList.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

class ProductDetail extends StatefulWidget {
  final Product data;

  const ProductDetail({super.key, required this.data});

  @override
  State<ProductDetail> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
  int _selectedQuantity = 1;

  void _handleQuantityChanged(int quantity) {
    if (mounted) {
      setState(() {
        _selectedQuantity = quantity;
      });
    }
  }

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
          actions: [
            Stack(
              children: [
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
                      color: AppColors.blueDark,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),

                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return Positioned(
                      right: 16,
                      bottom: -2,
                      child: Visibility(
                        visible: cart.totalDistinctItems != 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),

                          child: Text(
                            cart.totalDistinctItems
                                .toString(), // Muestra la cantidad total de ítems
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 55, // 60% de la altura
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
                            _buildButton(0, widget.data.image),
                            SizedBox(height: 10),
                            _buildButton(1, widget.data.image),
                            SizedBox(height: 10),
                            _buildButton(2, widget.data.image),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 45, // 40% de la altura
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 210, 248, 229),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                    child: Column(
                      children: [
                        // Boton mas detalles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed:
                                  () => {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: const EdgeInsets.fromLTRB(
                                            20,
                                            5,
                                            25,
                                            10,
                                          ),
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.8,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Detalles ",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      icon: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        size: 28,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(widget.data.description),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 28,
                                    color: AppColors.grayDark,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // NOMBRE DEL PRODUCTO
                        Row(
                          children: [
                            SizedBox(
                              width: 340,
                              child: Text(
                                widget.data.name,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
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
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '₲ ',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    numberFormat(widget.data.price),
                                    style: const TextStyle(
                                      fontSize: 26.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              QuantityField(
                                onQuantityChanged: _handleQuantityChanged,
                              ),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.blueDark, // Color del borde
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.transparent,
                              ),
                              child: BtnWishList(product: widget.data),
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: TextButton.icon(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  backgroundColor: AppColors.blueDark,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                ),
                                onPressed: () {
                                  final authProvider =
                                      Provider.of<AuthProvider>(
                                        context,
                                        listen: false,
                                      );

                                  if (!authProvider.isAuthenticated) {
                                    // Si el usuario no está logeado, redirigirlo a LoginScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const LoginScreen(),
                                      ),
                                    );
                                    return;
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
                                  ).addToCart(cartItem, _selectedQuantity);

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

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  String nombreProducto = widget.data.name;
                                  // String enlaceProducto = widget.data.permalink;
                                  String mensaje =
                                      "Hola, estoy interesado en este producto: $nombreProducto. Cantidad: $_selectedQuantity ";
                                  // Generar la URL para WhatsApp
                                  Uri url = Uri.parse(
                                    "https://wa.me/595974133687?text=${Uri.encodeComponent(mensaje)}",
                                  );
                                  // Verificar si la URL se puede abrir
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No se pudo abrir WhatsApp',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min, // Ajusta el tamaño al contenido
                                    children: [
                                      Text(
                                        'Pedir por WhatsApp',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                    ],
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
      ),
    );
  }

  Widget _buildProductImage(String imagePath) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullscreenImage(imageUrl: imagePath),
            ),
          );
        },
        child: Image.network(imagePath),
      ),
    );
  }

  Widget _buildButton(int index, String imagePath) {
    return InkWell(
      onTap: () => _changeProduct(index),

      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color:
                _currentIndex == index
                    ? AppColors.blueAcua
                    : const Color.fromARGB(255, 219, 219, 219),

            width: 2,
          ),
          // shape: BoxShape.circle,
          color: _currentIndex == index ? Colors.white : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Opacity(
            opacity: _currentIndex == index ? 1.0 : 0.5,

            child: Image.network(imagePath),
          ),
        ),
      ),
    );
  }
}

class QuantityField extends StatefulWidget {
  final Function(int) onQuantityChanged; // Callback para enviar la cantidad

  const QuantityField({super.key, required this.onQuantityChanged});

  @override
  QuantityFieldState createState() => QuantityFieldState();
}

class QuantityFieldState extends State<QuantityField> {
  int _quantity = 1;

  void _increment() {
    if (mounted) {
      setState(() {
        _quantity++;
        widget.onQuantityChanged(
          _quantity,
        ); // Llama al callback con la nueva cantidad
      });
    }
  }

  void _decrement() {
    if (mounted) {
      setState(() {
        if (_quantity > 1) {
          _quantity--;
          widget.onQuantityChanged(
            _quantity,
          ); // Llama al callback con la nueva cantidad
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _decrement,
          icon: const Icon(Icons.remove_circle_outline_rounded, size: 36),
        ),
        SizedBox(
          width: 30,
          child: Center(
            child: Text('$_quantity', style: const TextStyle(fontSize: 20)),
          ),
        ),
        IconButton(
          onPressed: _increment,
          icon: Stack(
            children: [const Icon(Icons.add_circle_outline_rounded, size: 36)],
          ),
        ),
      ],
    );
  }
}

// MOSTRAR IMAGEN EN PANTALLA COMPELTA
class FullScreenImage extends StatelessWidget {
  final String image;
  const FullScreenImage({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close, // Ícono de cruz
              color: Colors.black, // Color personalizado
            ),
            onPressed: () {
              Navigator.pop(context); // Cierra la pantalla actual
            },
          ),
        ],
      ),
      body: Center(child: Image.network(image, fit: BoxFit.contain)),
    );
  }
}

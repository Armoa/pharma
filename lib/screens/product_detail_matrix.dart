import 'package:flutter/material.dart';
import 'package:pharma/model/product_model.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required Product data});

  @override
  State<ProductDetail> createState() => ProductDetailState();
}

class ProductDetailState extends State<ProductDetail> {
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
            const Color.fromARGB(255, 244, 176, 17),
            const Color.fromARGB(255, 250, 218, 40),
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
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Icon(Icons.shopping_bag_outlined, color: Colors.black),
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
                          _buildProductImage("assets/producto_30.png"),
                          _buildProductImage("assets/producto_60.png"),
                          _buildProductImage("assets/producto_90.png"),
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
                  color: Colors.white,
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
                              'Relax 30 Dissolvable Wafers',
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
                            '250 mg',
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
                          Text('G25.50', style: TextStyle(fontSize: 30)),
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
                                backgroundColor: Color.fromARGB(
                                  255,
                                  244,
                                  202,
                                  17,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                              ),
                              onPressed: () => {},
                              icon: const Icon(
                                Icons.payment,
                                color: Colors.black,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Buy Now',
                                  style: TextStyle(
                                    color: Colors.black,
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
    return Center(child: Image.asset(imagePath));
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

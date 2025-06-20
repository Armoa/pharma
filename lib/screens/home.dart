import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharma/model/category_model.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/screens/list_categoria.dart';
import 'package:pharma/screens/list_product_all.dart';
import 'package:pharma/screens/show_promo_banner.dart';
import 'package:pharma/services/brand_box.dart';
import 'package:pharma/services/category_service.dart';
import 'package:pharma/services/fetch_active_banner.dart';
import 'package:pharma/services/verificar_perfil_usuario.dart';
import 'package:pharma/widget/appbar.dart';
import 'package:pharma/widget/category_widget.dart';
import 'package:pharma/widget/drawer.dart';
import 'package:pharma/widget/featured_ProductCard.dart';
import 'package:pharma/widget/floating_action_button.dart';
import 'package:pharma/widget/last_productCard.dart';
import 'package:pharma/widget/offert_ProductCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Verifica si hay un banner activo al iniciar
    _checkForPromoBanner();
    // Vefifica y el usuario completo su perfil
    verificarPerfilUsuario(context);
  }

  // POPUP BANNER
  void _checkForPromoBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Solo restablecer si la app se ha reiniciado completamente
    bool bannerShown = prefs.getBool('bannerShown') ?? false;

    if (!bannerShown) {
      await Future.delayed(const Duration(seconds: 10));

      String? imagen = await fetchActiveBanner();
      if (imagen != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showPromoBanner(context);
          prefs.setBool(
            'bannerShown',
            true,
          ); // Guarda que el banner ha sido mostrado
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppBar(),
      drawer: NewDrawer(),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.blueBlak
                  : Colors.white,
        ),

        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: CustomScrollView(
            slivers: [
              // BANNE SLIDER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: SizedBox(
                    height: 150.0,
                    child: FutureBuilder<List<String>?>(
                      future: fetchShowSliders(),
                      builder: (context, featured) {
                        if (featured.hasData) {
                          if (featured.data!.isEmpty) {
                            return const Center(
                              child: Text("0 Banners disponibles"),
                            );
                          }
                          return Container(
                            width: double.infinity,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.blueBlak
                                    : Colors.white,
                            child: CarouselSlider.builder(
                              itemCount: featured.data!.length,
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 16 / 8,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.2,
                                // viewportFraction: 0.8,
                              ),
                              itemBuilder: (context, i, realIdx) {
                                return InkWell(
                                  onTap: () {},
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      featured.data![i],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (featured.hasError) {
                          return Center(child: Text(featured.error.toString()));
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Categorías",
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // CATEGORIAS DE PRODUCTOS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: SizedBox(
                    height: 124,
                    child: FutureBuilder<List<Category>>(
                      future: fetchCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final categories = snapshot.data!;
                          if (categories.isEmpty) {
                            return const Center(
                              child: Text("0 Categoría a mostrar"),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, i) {
                              final cat = categories[i];
                              return SizedBox(
                                width: 94.0,
                                child: CategoryCard(
                                  imagePath: cat.images,
                                  label: cat.nombre,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ListCategoria(
                                              int.parse(cat.id),
                                              cat.nombre,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),

              // PRODUCTOS OFERTAS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ofertas",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: OffertProductCard()),

              // PRODUCTOS DESTACADOS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Destacados",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: FeaturedProductCard()),

              // PRODUCTOS ULTIMOS CARGADOS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " Novedades",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ListProductAll(),
                              ),
                            ),
                        child: Text(
                          "Ver más",
                          style: GoogleFonts.quicksand(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: LastProductCard()),
              // Marcas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Marcas TOP",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: BrandBox()),
            ],
          ),
        ),
      ),
      floatingActionButton: NewFloatingActionButton(),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pharma/services/fetch_active_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showPromoBanner(BuildContext context) async {
  String? imageUrl = await fetchActiveBanner();

  if (imageUrl != null) {
    // ✅ Precargar la imagen
    final ImageStream imageStream = NetworkImage(
      imageUrl,
    ).resolve(ImageConfiguration());
    final Completer<void> completer = Completer<void>();

    imageStream.addListener(
      ImageStreamListener((_, __) {
        completer.complete(); // ✅ Imagen precargada correctamente
      }),
    );

    await completer
        .future; // ✅ Esperar a que la imagen se precargue antes de continuar

    // ✅ Mostrar el `showDialog()` solo cuando la imagen está lista
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 33,
                  height: 33,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(26)),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, size: 18),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('bannerShown', true);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// void showPromoBanner(BuildContext context, String imagen) async {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         child: Stack(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               height: MediaQuery.of(context).size.height * 0.5,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   image: NetworkImage(imagen),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Container(
//                 width: 33,
//                 height: 33,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(26)),
//                   color: Color.fromARGB(255, 255, 255, 255),
//                 ),
//                 child: IconButton(
//                   // ignore: prefer_const_constructors
//                   icon: Icon(Icons.close, size: 18),
//                   onPressed: () async {
//                     SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                     prefs.setBool(
//                       'bannerShown',
//                       true,
//                     ); // Guarda que el banner ha sido mostrado

//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

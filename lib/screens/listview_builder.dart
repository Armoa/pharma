import 'package:flutter/material.dart';
import 'package:pharma/model/mapa_city.dart';
import 'package:pharma/widget/appbar.dart';
import 'package:pharma/widget/drawer.dart';

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppBar(),
      drawer: NewDrawer(),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Text(cities[i]['id'].toString()),
            title: Text(cities[i]['name'].toString()),
            subtitle: Text("Precio G. ${cities[i]['costoEnvio'].toString()}"),
          );
        },
      ),
    );
  }
}

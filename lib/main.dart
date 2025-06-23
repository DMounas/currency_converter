// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'currency_converter_material_page.dart' as material;
import 'currency_converter_cupertino_page.dart' as cupertino;
 // Use an alias for clarity

void main() {
  // You can switch which app to run here
  runApp(const MyApp()); 
  // or runApp(const MyCupertinoApp());
}

// --- Material App ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // FIX #1: Added const and () to instantiate the class correctly
      home: material.CurrencyConverterMaterialPage(), 
    );
  }
}

//--- Cupertino App ---
class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      // FIX #2: Removed const and used the correct class name from the import
      home: cupertino.CurrencyConverterCupertinoPage(),
    );
  }
}
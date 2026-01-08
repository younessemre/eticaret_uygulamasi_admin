import 'package:ecommerce_flutter_admin/constans/theme_data.dart';
import 'package:ecommerce_flutter_admin/provider/product_provider.dart';
import 'package:ecommerce_flutter_admin/provider/theme_provider.dart';
import 'package:ecommerce_flutter_admin/screens/DashboardScreen.dart';
import 'package:ecommerce_flutter_admin/screens/editorUploadProduct.dart';
import 'package:ecommerce_flutter_admin/screens/search_screen.dart';
import 'package:ecommerce_flutter_admin/widget/order/order_screen.dart';
import 'package:ecommerce_flutter_admin/widget/order/order_details_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  } catch (_) {
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Admin',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const DashboardScreen(),
            routes: {
              OrderScreen.routName: (_) => const OrderScreen(),
              SearchScreen.routName: (_) => const SearchScreen(),
              EditorUploadProductScreen.routName: (_) =>
                  const EditorUploadProductScreen(),
              OrderDetailsScreen.routName: (context) {
                final args = ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
                return OrderDetailsScreen(
                  orderNo: args['orderNo'] as String,
                  total: (args['total'] as num).toDouble(),
                  items: (args['items'] as List).cast<Map<String, dynamic>>(),
                );
              },
            },
          );
        },
      ),
    );
  }
}

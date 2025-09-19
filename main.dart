import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/intro_splashscreen.dart';
import 'state/app_state.dart';
import 'services/products_repository.dart';
import 'services/fake_products_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Okrika());
}

class Okrika extends StatelessWidget {
  const Okrika({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(ProductsRepositoryFake()),
        ),
      ],
      child: MaterialApp(
        title: 'Okrika',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const IntroSplashScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notes/app/pages/splash/splash_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF40B7AD);
    const textColor = Color(0xFF4A4A4A);
    const backgroundColor = Color(0xFFF5F5F5);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Poppins',
            bodyColor: textColor,
            displayColor: textColor),
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.transparent),
        appBarTheme: AppBarTheme(
            backgroundColor: primary,
            iconTheme: IconThemeData(
              color: backgroundColor,
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w700))),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}

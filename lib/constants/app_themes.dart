import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class MyThemes {
  static ThemeData get myLightTheme => ThemeData(
        useMaterial3: true,
        primaryColor: MyColors.defaultPurple,
        primarySwatch: MaterialColor(0xFF93278F, {
          50: MyColors.defaultPurple.withOpacity(0.9),
          100: MyColors.defaultPurple.withOpacity(0.8),
          200: MyColors.defaultPurple.withOpacity(0.7),
          300: MyColors.defaultPurple.withOpacity(0.6),
          400: MyColors.defaultPurple.withOpacity(0.5),
          500: MyColors.defaultPurple.withOpacity(0.4),
          600: MyColors.defaultPurple.withOpacity(0.3),
          700: MyColors.defaultPurple.withOpacity(0.2),
          800: MyColors.defaultPurple.withOpacity(0.1),
          900: MyColors.defaultPurple,
        }),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.defaultBackgroundPurple,
            statusBarIconBrightness: Brightness.light,
          ),
        ),

        // SemiBold 600 // Medium 500 // Normal(Regular) 400 // Light 300
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            headlineSmall: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(),
            titleMedium: TextStyle(
              fontWeight: FontWeight.w600,
            ),
            titleSmall: TextStyle(
              fontWeight: FontWeight.w600,
            ),
            labelLarge: TextStyle(
              color: Color(0xff808080),
            ),
          ),
        ),

        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: Color(0x74e3e0e0),
          height: 50,
          backgroundColor:Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      );
}

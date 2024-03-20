import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromRGBO(230, 230, 230, 1)),
    useMaterial3: true,
    textTheme: TextTheme(
      titleSmall: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
    ));

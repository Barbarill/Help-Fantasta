import 'package:flutter/material.dart';

class AppColors {
  static const verdeScuro = Color(0xFF0B3D2E);
  static const verdeMedio = Color(0xFF145A43);
  static const oro = Color(0xFFC9A227);
  static const oroChiaro = Color(0xFFE8C766);
  static const sfondoChiaro = Color(0xFFF4F6F4);

  // Colori badge ruolo
  static const portiere = Color(0xFFE8A33D);
  static const difensore = Color(0xFF2E7D46);
  static const centrocampista = Color(0xFF2C6FB0);
  static const attaccante = Color(0xFFC0392B);
}

class AppTheme {
  static ThemeData get tema {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.verdeScuro,
        primary: AppColors.verdeScuro,
        secondary: AppColors.oro,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.sfondoChiaro,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.verdeScuro,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.verdeScuro,
        indicatorColor: AppColors.oro,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selezionato = states.contains(WidgetState.selected);
          return TextStyle(
            color: selezionato ? AppColors.verdeScuro : Colors.white70,
            fontSize: 11,
            fontWeight: selezionato ? FontWeight.bold : FontWeight.normal,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selezionato = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selezionato ? AppColors.verdeScuro : Colors.white70,
          );
        }),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.oro,
        unselectedLabelColor: Colors.white70,
        indicatorColor: AppColors.oro,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.oro,
        foregroundColor: AppColors.verdeScuro,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeScuro,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ) !=
              null
          ? InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            )
          : null,
    );
  }
}
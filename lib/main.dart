// ============================================================
// FILE: lib/main.dart
// ⭐ INI ADALAH ENTRY POINT / TITIK AWAL SELURUH APLIKASI ⭐
// ------------------------------------------------------------
// FUNGSI UTAMA: File ini adalah yang PERTAMA KALI dijalankan
// oleh Flutter saat aplikasi dibuka. Tugasnya:
//   1. Menjalankan aplikasi (runApp)
//   2. Menyediakan CartProvider ke SELURUH bagian aplikasi
//      (inilah titik "INTEGRASI" antara Tahap 2/Slicing UI
//      dengan Tahap 3/State Management)
//   3. Mengatur tema warna & halaman pembuka (home)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  // ^ Fungsi main() adalah fungsi WAJIB di setiap program Dart —
  //   ini adalah titik masuk paling pertama yang dijalankan.
  runApp(const MyApp());
  // ^ runApp() adalah fungsi bawaan Flutter yang "menempelkan"
  //   widget MyApp ke layar perangkat, memulai seluruh proses
  //   render UI.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // ^ ⭐⭐⭐ INI ADALAH TITIK INTEGRASI STATE MANAGEMENT ⭐⭐⭐
      //   ChangeNotifierProvider adalah widget dari pustaka
      //   "provider" yang tugasnya MEMBUAT dan MEMBAGIKAN satu
      //   instance CartProvider ke SELURUH widget di bawahnya
      //   (child) dalam tree ini — yaitu SELURUH aplikasi, karena
      //   ini membungkus MaterialApp secara keseluruhan.
      //
      //   Analoginya: bayangkan ChangeNotifierProvider ini seperti
      //   "wadah/toples" yang menyimpan CartProvider, dan
      //   diletakkan di POSISI PALING ATAS/LUAR aplikasi, sehingga
      //   halaman manapun (CatalogScreen, CartScreen) yang ada
      //   "di dalam toples ini" bisa mengambil isinya lewat
      //   context.watch<CartProvider>() atau context.read<CartProvider>().
      create: (_) => CartProvider(),
      // ^ "create" adalah fungsi yang dipanggil SEKALI SAJA untuk
      //   membuat instance CartProvider yang baru. Karena hanya
      //   dibuat sekali (bukan setiap halaman membuat CartProvider
      //   baru masing-masing), maka datanya TETAP KONSISTEN &
      //   TERPUSAT di seluruh aplikasi — inilah esensi "state
      //   terpusat" yang diminta LKPD.
      child: MaterialApp(
        title: 'Smart-Cart & E-Catalog',
        debugShowCheckedModeBanner: false,
        // ^ menyembunyikan label "DEBUG" merah di pojok kanan atas
        //   saat aplikasi dijalankan dalam mode development.
        theme: ThemeData(
          primaryColor: const Color(0xFF23C16B),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF23C16B),
            primary: const Color(0xFF23C16B),
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
          // ^ mengaktifkan desain Material 3 (versi terbaru
          //   guideline desain dari Google)
        ),
        home: const CatalogScreen(),
        // ^ "home" menentukan HALAMAN PERTAMA yang tampil saat
        //   aplikasi dibuka. Di sini diarahkan ke CatalogScreen.
        //   Untuk berpindah ke CartScreen, dipakai Navigator.push()
        //   yang dipanggil dari dalam BadgeCounter.
      ),
    );
  }
}

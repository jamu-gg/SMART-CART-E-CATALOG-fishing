// ============================================================
// FILE: lib/widgets/badge_counter.dart
// FUNGSI UTAMA: Widget ikon keranjang + lingkaran merah kecil
// (badge) di pojok kanan atas yang menunjukkan JUMLAH TOTAL
// item di keranjang. Dipasang di actions: [] pada AppBar
// CatalogScreen.
//
// Ini termasuk file "WIDGET" (bukan Screen) karena ukurannya
// kecil dan bisa dipakai ulang (reusable) — bedanya dengan
// Screen yang mewakili SATU HALAMAN PENUH.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ^ Import pustaka "provider" — INI yang menyediakan method
//   context.watch<T>() dan context.read<T>() yang dipakai di
//   bawah. Tanpa import ini, kedua method tersebut tidak dikenal.

import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';

class BadgeCounter extends StatelessWidget {
  // ^ StatelessWidget dipilih (bukan StatefulWidget) karena
  //   widget ini TIDAK menyimpan state-nya sendiri. Semua data
  //   (jumlah item) diambil dari CartProvider di luar dirinya.
  //   Ini POLA PENTING dalam arsitektur Provider: hampir semua
  //   widget UI cukup jadi StatelessWidget, karena "kepintaran"
  //   menyimpan data sudah dipindah ke Provider.

  const BadgeCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCount = context.watch<CartProvider>().totalItemCount;
    // ^ ⭐ INI CONTOH PEMAKAIAN context.watch<T>() ⭐
    //   Artinya: "widget ini BERLANGGANAN pada perubahan data di
    //   CartProvider". Setiap kali CartProvider memanggil
    //   notifyListeners(), method build() di file ini akan
    //   dipanggil ULANG secara otomatis oleh Flutter, sehingga
    //   angka itemCount selalu ter-update REAL-TIME tanpa perlu
    //   setState() manual.

    return Stack(
      // ^ Stack = widget untuk menumpuk beberapa widget anak
      //   di atas satu sama lain (seperti layer di Photoshop).
      //   Di sini dipakai untuk menumpuk badge merah DI ATAS ikon
      //   keranjang.
      clipBehavior: Clip.none,
      // ^ mengizinkan badge sedikit "keluar" dari batas ikon
      //   tanpa terpotong.
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () {
            // Saat ikon ditekan, pindah (navigate) ke CartScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
        ),
        if (itemCount > 0)
          // ^ Badge HANYA muncul kalau ada isinya (>0).
          //   Ini disebut "conditional rendering".
          Positioned(
            // ^ Positioned dipakai DI DALAM Stack untuk menentukan
            //   posisi persis (dari tepi atas & kanan).
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle, // membuat bentuk lingkaran
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                '$itemCount',
                // ^ "$itemCount" adalah string interpolation —
                //   cara Dart menyisipkan nilai variabel ke
                //   dalam String tanpa perlu operator "+".
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

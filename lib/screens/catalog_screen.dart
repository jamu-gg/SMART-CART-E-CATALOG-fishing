// ============================================================
// FILE: lib/screens/catalog_screen.dart
// FUNGSI UTAMA: Halaman UTAMA/PERTAMA aplikasi — menampilkan
// AppBar hijau "E-Catalog Mancing" + grid 2 kolom berisi semua
// produk. Ini termasuk file "SCREEN" (bukan widget kecil) karena
// mewakili SATU HALAMAN PENUH yang punya Scaffold sendiri.
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/badge_counter.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatelessWidget {
  // ^ StatelessWidget karena halaman ini sendiri tidak menyimpan
  //   state apapun — data produk (productList) bersifat statis/
  //   tetap, dan data keranjang diambil dari CartProvider lewat
  //   widget-widget anaknya (BadgeCounter, ProductCard).
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ^ Scaffold = "kerangka dasar" satu halaman Material Design.
      //   Menyediakan struktur baku: AppBar di atas, body di
      //   tengah, dan bisa ditambah FloatingActionButton/BottomNav
      //   dst jika diperlukan.
      backgroundColor: const Color(0xFFF5F5F5), // abu-abu sangat muda
      appBar: AppBar(
        backgroundColor: const Color(0xFF23C16B), // hijau sesuai Figma
        elevation: 0, // tanpa efek bayangan di bawah AppBar
        automaticallyImplyLeading: false,
        // ^ mencegah Flutter otomatis menampilkan tombol "back"
        //   di halaman utama (karena ini halaman pertama, tidak
        //   ada halaman sebelumnya untuk kembali).
        title: const Text(
          'E-Catalog Mancing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [
          BadgeCounter(), // ikon keranjang + badge, ditaruh di
                           // kanan AppBar (actions selalu di kanan)
          SizedBox(width: 8), // jarak kecil dari tepi layar
        ],
      ),
      body: SafeArea(
        // ^ SafeArea mencegah konten tertutup oleh notch/status
        //   bar/kamera depan HP (area yang "tidak aman" untuk
        //   konten penting).
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            // ^ GridView.builder dipilih (bukan GridView.count biasa)
            //   karena bersifat "lazy" — hanya me-render item yang
            //   TERLIHAT di layar, membuat performa lebih baik kalau
            //   nanti jumlah produk bertambah banyak (misal 100+).
            itemCount: productList.length,
            // ^ jumlah total item yang akan ditampilkan, diambil
            //   dari panjang List productList (di product.dart)
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // ^ "delegate" ini mengatur BAGAIMANA grid disusun
              crossAxisCount: 2, // 2 KOLOM sesuai desain Figma
              crossAxisSpacing: 14, // jarak horizontal antar kartu
              mainAxisSpacing: 14,  // jarak vertikal antar kartu
              childAspectRatio: 0.60,
              // ^ rasio lebar:tinggi tiap kartu. Angka ini
              //   DIPERKECIL dari nilai awal (0.68) untuk memberi
              //   ruang vertikal lebih agar TIDAK OVERFLOW saat
              //   dijalankan di HP fisik dengan ukuran layar
              //   berbeda-beda.
            ),
            itemBuilder: (context, index) {
              // ^ Fungsi ini dipanggil BERULANG oleh Flutter untuk
              //   setiap index (0, 1, 2, ... sampai itemCount-1),
              //   dan harus mengembalikan SATU widget untuk posisi
              //   grid tersebut.
              final product = productList[index];
              // ambil 1 objek Product sesuai index saat ini
              return ProductCard(product: product);
              // kirim objek Product itu ke widget ProductCard
              // untuk ditampilkan sebagai satu kartu
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FILE: lib/widgets/product_card.dart
// FUNGSI UTAMA: Menampilkan SATU KARTU produk (gambar, nama,
// harga, tombol "Tambah") di dalam GridView pada CatalogScreen.
// Dipanggil berulang kali (6x) sesuai jumlah produk di
// productList — inilah kenapa dibuat sebagai widget terpisah,
// supaya kodenya tidak ditulis berulang-ulang secara manual.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  // ^ Widget ini menerima SATU objek Product sebagai "input"
  //   (disebut juga "parameter" atau constructor argument).
  //   Data produk mana yang ditampilkan tergantung apa yang
  //   dikirim oleh CatalogScreen saat memanggil ProductCard(...).

  const ProductCard({super.key, required this.product});

  // --------------------------------------------------------
  // FUNGSI BANTU (bukan bagian dari UI, murni logika)
  // --------------------------------------------------------
  String _formatRupiah(int price) {
    // ^ Mengubah angka biasa (contoh: 1237000) menjadi format
    //   Rupiah dengan titik pemisah ribuan (Rp 1.237.000).
    //   Tanda underscore "_" di depan nama fungsi = private,
    //   hanya dipakai di dalam file ini.
    final str = price.toString();
    final buffer = StringBuffer(); // struktur efisien untuk
                                    // menggabungkan banyak String
    int count = 0;
    // Loop dari BELAKANG angka (satuan) menuju depan (ribuan/
    // jutaan), menyisipkan titik setiap 3 digit.
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    // Hasil buffer masih dalam urutan TERBALIK, maka di-reverse
    // dulu sebelum ditampilkan.
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ^ Container = "kartu putih" pembungkus seluruh isi (mirip
      //   <div> di HTML, tapi dengan properti styling built-in).
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // sudut membulat
        boxShadow: [
          // efek bayangan halus di bawah kartu
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        // ^ Column = menyusun widget anak SECARA VERTIKAL
        //   (dari atas ke bawah): gambar → nama → harga → tombol.
        crossAxisAlignment: CrossAxisAlignment.start,
        // ^ membuat teks rata KIRI (bukan rata tengah)
        mainAxisSize: MainAxisSize.min,
        // ^ Column hanya mengambil tinggi SEPERLUNYA (tidak
        //   memaksa mengisi seluruh ruang vertikal yang tersedia).
        children: [
          ClipRRect(
            // ^ Memotong (clip) widget anak agar sudutnya ikut
            //   membulat sesuai borderRadius yang ditentukan.
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              // ^ Memaksa area gambar SELALU berbentuk persegi
              //   (rasio lebar:tinggi = 1:1), agar tampilan rapi
              //   walau ukuran layar HP berbeda-beda.
              aspectRatio: 1,
              child: Image.asset(
                // ^ ⭐ Image.asset (BUKAN Image.network) karena
                //   gambar diambil dari file LOKAL di folder
                //   assets/, bukan dari internet.
                product.imageUrl, // contoh: 'assets/joran.jpg'
                fit: BoxFit.cover,
                // ^ gambar akan "memenuhi" area tanpa gepeng,
                //   bagian yang berlebih akan dipotong otomatis.
                errorBuilder: (context, error, stackTrace) => Container(
                  // ^ errorBuilder = tampilan CADANGAN yang
                  //   muncul HANYA JIKA gambar gagal dimuat
                  //   (misal: nama file salah/tidak ditemukan).
                  //   Berguna supaya aplikasi tidak crash, cuma
                  //   menampilkan ikon "gambar tidak tersedia".
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: Colors.grey, size: 32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // jarak kosong vertikal
          Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatRupiah(product.price), // panggil fungsi bantu
                                           // di atas
            style: const TextStyle(
              color: Color(0xFF00A3FF), // biru sesuai desain Figma
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity, // tombol selebar kartu
            child: ElevatedButton.icon(
              onPressed: () {
                // ⭐ INI CONTOH PEMAKAIAN context.read<T>() ⭐
                // Beda dengan .watch(), .read() dipakai saat kita
                // HANYA PERLU MEMANGGIL AKSI SEKALI (saat tombol
                // ditekan), BUKAN untuk terus-menerus mendengarkan
                // perubahan data. Aturan umum: watch() untuk BACA
                // data terus-menerus di build(), read() untuk
                // MEMANGGIL method di dalam event seperti onPressed.
                context.read<CartProvider>().addToCart(product);

                // Menampilkan notifikasi kecil di bawah layar
                // sebagai umpan balik ke pengguna.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} ditambahkan ke keranjang'),
                    duration: const Duration(milliseconds: 900),
                    backgroundColor: const Color(0xFF23C16B),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart, size: 16),
              label: const Text('Tambah'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF23C16B), // hijau
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

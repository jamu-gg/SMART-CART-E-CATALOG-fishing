// ============================================================
// FILE: lib/models/cart_item.dart
// FUNGSI UTAMA: Mendefinisikan struktur data untuk SATU baris
// item yang ada DI DALAM KERANJANG BELANJA.
//
// Kenapa butuh model terpisah dari Product? Karena CartItem
// butuh informasi TAMBAHAN yang tidak dimiliki Product biasa,
// yaitu "quantity" (berapa banyak jumlah barang ini dipilih).
// Product hanya tahu "ini Joran, harganya 1.237.000" — tapi
// tidak tahu "user mau beli berapa Joran". Itu tugas CartItem.
// ============================================================

import 'product.dart';
// ^ Import ini WAJIB karena CartItem "memakai" tipe data Product
//   di dalam class-nya (lihat baris "final Product product;" di bawah).
//   Tanpa import ini, Dart tidak akan tahu apa itu "Product".

class CartItem {
  // --- ATRIBUT ---

  final Product product;
  // ^ CartItem "membungkus" satu objek Product di dalamnya.
  //   Ini disebut "komposisi" dalam OOP — CartItem TIDAK
  //   mewarisi (extends) Product, tapi MEMILIKI (has-a) Product.
  //   final = referensi ke Product ini tidak akan diganti-ganti.

  int quantity;
  // ^ PERHATIKAN: ini TIDAK diberi "final"!
  //   Beda dengan Product yang semua atributnya final (tetap),
  //   quantity justru HARUS bisa berubah-ubah, karena user akan
  //   menekan tombol (+) atau (-) untuk mengubah jumlah barang.

  // --- CONSTRUCTOR ---
  CartItem({
    required this.product,
    this.quantity = 1,
    // ^ "this.quantity = 1" artinya quantity punya NILAI DEFAULT
    //   1 jika tidak diisi saat membuat CartItem baru. Masuk akal:
    //   saat produk pertama kali "Ditambah" ke keranjang, jumlahnya
    //   otomatis 1 (bukan 0 atau kosong).
  });

  // --- COMPUTED PROPERTY (GETTER) ---
  int get totalPrice => product.price * quantity;
  // ^ Ini BUKAN variabel biasa, tapi sebuah GETTER — sebuah
  //   "rumus" yang dihitung ulang setiap kali dipanggil.
  //   totalPrice = harga satuan produk dikali jumlah.
  //   Contoh: Joran (Rp 1.237.000) x quantity 2 = Rp 2.474.000
  //
  //   Keuntungan pakai getter (bukan disimpan sebagai variabel
  //   biasa): nilainya SELALU akurat/up-to-date secara otomatis.
  //   Kalau quantity berubah, totalPrice otomatis ikut berubah
  //   tanpa perlu kode tambahan untuk "mengupdate" nilainya.
}

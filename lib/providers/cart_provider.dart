// ============================================================
// FILE: lib/providers/cart_provider.dart
// ⭐ INI FILE PALING PENTING UNTUK POIN "STATE MANAGEMENT" (35%)
// ============================================================
// FUNGSI UTAMA: Ini adalah "OTAK" atau "PUSAT KENDALI" dari
// seluruh data keranjang belanja. SEMUA operasi terkait cart
// (tambah, kurang, hapus, hitung total) WAJIB lewat file ini —
// tidak boleh ada halaman lain yang mengubah data cart secara
// langsung. Inilah yang disebut "State Management Terpusat"
// sesuai ketentuan LKPD.
//
// Kenapa TIDAK pakai setState() biasa? Karena setState() hanya
// bekerja LOKAL di dalam satu widget/halaman saja. Padahal data
// keranjang perlu dibagikan/disinkronkan ke BANYAK halaman
// sekaligus (CatalogScreen perlu tahu badge counter berapa,
// CartScreen perlu tahu daftar & total belanja) — maka
// dibutuhkan satu sumber data TUNGGAL yang bisa "didengarkan"
// dari mana saja: itulah CartProvider ini.
// ============================================================

import 'package:flutter/foundation.dart';
// ^ Package ini berisi kelas "ChangeNotifier" yang kita pakai
//   di bawah. ChangeNotifier adalah fitur BAWAAN Flutter (bukan
//   dari pustaka provider), sedangkan pustaka "provider" nanti
//   hanya berfungsi menjembatani ChangeNotifier ini ke UI.

import '../models/cart_item.dart';
import '../models/product.dart';
// ^ Import 2 model yang dipakai di file ini.

class CartProvider with ChangeNotifier {
  // ^ "with ChangeNotifier" adalah MIXIN — cara Dart untuk
  //   "menambahkan kemampuan" ke sebuah class tanpa harus
  //   inheritance (extends) penuh. Kemampuan yang didapat:
  //   method notifyListeners() dan kemampuan untuk "didengarkan"
  //   oleh widget-widget lain lewat Provider.

  // --------------------------------------------------------
  // PENYIMPANAN DATA UTAMA
  // --------------------------------------------------------
  final Map<String, CartItem> _items = {};
  // ^ Ini adalah "database" keranjang belanja yang sesungguhnya.
  //   Dipilih tipe data Map (bukan List) karena:
  //   - Key = product.id (String), Value = CartItem
  //   - Mencari/mengecek "apakah produk X sudah ada di keranjang?"
  //     jadi SANGAT CEPAT (O(1)) dibanding harus looping List satu
  //     per satu (O(n)).
  //   - Tanda underscore "_" di depan nama variabel artinya
  //     PRIVATE — variabel ini HANYA bisa diakses dari dalam file
  //     ini sendiri. Halaman lain TIDAK BISA mengubah _items
  //     secara langsung, HARUS lewat method-method di bawah ini.
  //     Ini praktik keamanan data yang disebut "encapsulation".

  // --------------------------------------------------------
  // GETTER — cara "aman" untuk membaca data dari luar
  // --------------------------------------------------------
  Map<String, CartItem> get items => {..._items};
  // ^ Getter ini mengembalikan SALINAN (copy) dari _items,
  //   bukan _items aslinya. Ini mencegah kode dari luar
  //   mengubah data secara diam-diam tanpa lewat method resmi.
  //   {..._items} artinya "sebar/salin semua isi _items ke Map baru".

  List<CartItem> get itemList => _items.values.toList();
  // ^ Mengubah Map menjadi List agar mudah ditampilkan di UI
  //   dengan widget seperti ListView/Column yang butuh List.

  int get totalItemCount {
    // ^ Menghitung TOTAL JUMLAH UNIT barang di keranjang.
    //   Contoh: 2 Joran + 3 Kail = totalItemCount 5.
    //   Dipakai oleh BadgeCounter di AppBar.
    int count = 0;
    _items.forEach((key, cartItem) {
      count += cartItem.quantity; // jumlahkan quantity tiap item
    });
    return count;
  }

  int get uniqueItemCount => _items.length;
  // ^ Menghitung JUMLAH JENIS/BARIS produk berbeda di keranjang
  //   (bukan total unit). Contoh: 2 Joran + 3 Kail = uniqueItemCount 2.

  int get totalPrice {
    // ^ Menghitung TOTAL BIAYA seluruh belanjaan.
    //   Ditampilkan di Container "Total Pembayaran" pada CartScreen.
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice; // totalPrice sudah dihitung
                                     // otomatis di model CartItem
    });
    return total;
  }

  bool get isEmpty => _items.isEmpty;
  // ^ Dipakai CartScreen untuk menampilkan tampilan "keranjang
  //   kosong" jika belum ada barang sama sekali.

  // --------------------------------------------------------
  // METHOD — cara "resmi" untuk MENGUBAH data dari luar
  // --------------------------------------------------------

  void addToCart(Product product) {
    // ^ Dipanggil saat tombol "Tambah" di ProductCard ditekan.
    if (_items.containsKey(product.id)) {
      // Jika produk SUDAH ADA di keranjang, cukup tambah quantity-nya
      _items[product.id]!.quantity += 1;
      // tanda "!" (bang operator) memberi tahu Dart "saya yakin
      // nilai ini pasti tidak null" karena kita sudah cek
      // containsKey di atas.
    } else {
      // Jika produk BELUM ADA, buat CartItem baru dengan quantity 1
      _items[product.id] = CartItem(product: product, quantity: 1);
    }

    notifyListeners();
    // ^ ⭐⭐⭐ INI BARIS PALING PENTING DI SELURUH APLIKASI ⭐⭐⭐
    //   notifyListeners() adalah "pengumuman siaran" ke SEMUA
    //   widget yang sedang "menonton" (watch) CartProvider ini.
    //   Begitu baris ini dijalankan, Flutter otomatis me-rebuild
    //   ulang semua widget yang terhubung — misalnya BadgeCounter
    //   langsung update angkanya, CartScreen langsung update
    //   daftar & totalnya — TANPA kita perlu menulis setState()
    //   satu per satu di setiap halaman.
  }

  void incrementQuantity(String productId) {
    // ^ Dipanggil saat tombol (+) di CartTile ditekan.
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
      notifyListeners(); // beri tahu UI untuk update lagi
    }
  }

  void decrementQuantity(String productId) {
    // ^ Dipanggil saat tombol (-) di CartTile ditekan.
    if (!_items.containsKey(productId)) return;
    // ^ early return: kalau produk tidak ada, hentikan method
    //   (tidak melakukan apa-apa) supaya tidak error.

    if (_items[productId]!.quantity > 1) {
      // Jika quantity masih lebih dari 1, cukup dikurangi
      _items[productId]!.quantity -= 1;
    } else {
      // Jika quantity sudah 1 (mau jadi 0), hapus saja itemnya
      // sepenuhnya dari keranjang, bukan dibiarkan quantity 0
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    // ^ Method untuk menghapus produk dari keranjang secara
    //   langsung (tidak dipakai di UI saat ini, tapi disediakan
    //   sebagai fungsi tambahan / future-proofing).
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    // ^ Mengosongkan SELURUH keranjang. Dipanggil setelah user
    //   menekan "PESAN SEKARANG" dan mengonfirmasi pesanan.
    _items.clear();
    notifyListeners();
  }

  int quantityOf(String productId) {
    // ^ Method bantu untuk mengecek "sudah ada berapa banyak
    //   produk ini di keranjang?" — berguna kalau nanti mau
    //   menampilkan angka quantity langsung di ProductCard juga.
    return _items[productId]?.quantity ?? 0;
    // ^ "?." artinya "akses .quantity HANYA JIKA nilainya tidak
    //   null". "?? 0" artinya "kalau hasilnya null, pakai nilai 0
    //   sebagai gantinya". Ini disebut null-safety operator,
    //   fitur khas bahasa Dart untuk mencegah error "null exception".
  }
}

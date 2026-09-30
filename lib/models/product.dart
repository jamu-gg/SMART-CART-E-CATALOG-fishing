// ============================================================
// FILE: lib/models/product.dart
// FUNGSI UTAMA: Mendefinisikan "bentuk" atau struktur data
// untuk SATU produk (misal: Joran, Kail, dst).
//
// Ini disebut "MODEL" dalam arsitektur aplikasi karena hanya
// berisi definisi DATA, tidak ada tampilan (UI) sama sekali.
// File ini akan dipakai oleh:
//   - lib/widgets/product_card.dart  (untuk menampilkan 1 produk)
//   - lib/screens/catalog_screen.dart (untuk daftar semua produk)
//   - lib/models/cart_item.dart      (setiap item keranjang
//                                      "membungkus" 1 Product)
// ============================================================

class Product {
  // --- ATRIBUT / PROPERTI ---
  // Semua diberi kata kunci "final" artinya nilainya TIDAK BISA
  // diubah lagi setelah objek Product ini dibuat (immutable).
  // Ini masuk akal karena data produk (nama, harga) di katalog
  // memang seharusnya tetap/statis, bukan berubah-ubah.

  final String id;       // ID unik tiap produk, dipakai sebagai
                          // "kunci" pencarian di CartProvider
                          // (Map<String, CartItem>).

  final String name;      // Nama produk, contoh: "Joran".

  final int price;        // Harga produk dalam satuan Rupiah,
                           // disimpan sebagai angka bulat (int),
                           // BUKAN String, supaya bisa dihitung
                           // (dijumlah, dikali quantity, dll).

  final String imageUrl;  // Path menuju file gambar di folder
                           // assets/, contoh: 'assets/joran.jpg'.
                           // Nama variabel tetap "imageUrl" walau
                           // isinya path lokal (bukan URL internet),
                           // supaya konsisten dengan kode sebelumnya.

  // --- CONSTRUCTOR ---
  // Constructor adalah "cetakan" untuk membuat objek Product baru.
  // "const" di depan berarti objek ini bisa dibuat saat COMPILE TIME
  // (bukan saat aplikasi jalan), ini membuat performa lebih baik
  // karena Flutter tidak perlu membuat ulang objek yang sama
  // berkali-kali saat widget di-rebuild.
  const Product({
    required this.id,        // "required" = wajib diisi saat
    required this.name,      // memanggil Product(...), kalau lupa
    required this.price,     // isi salah satu, akan error saat
    required this.imageUrl,  // menulis kode (compile error).
  });
}

// ============================================================
// DATA DUMMY / DATA STATIS
// ------------------------------------------------------------
// Ini adalah "database sementara" berupa List (daftar) berisi
// 6 objek Product, sesuai desain Figma "E-Catalog Mancing".
// Di aplikasi nyata/production, data ini biasanya diambil dari
// server/API, tapi untuk tugas LKPD ini cukup data statis.
//
// List<Product> artinya: "sebuah List yang isinya harus berupa
// objek-objek bertipe Product" (Dart adalah bahasa yang strict
// terhadap tipe data / strongly typed).
// ============================================================
final List<Product> productList = [
  Product(
    id: 'p1',
    name: 'Joran',
    price: 1237000,
    imageUrl: 'assets/joran.jpg', // path relatif ke folder assets/
  ),
  Product(
    id: 'p2',
    name: 'Kail',
    price: 50000,
    imageUrl: 'assets/kail.jpg',
  ),
  Product(
    id: 'p3',
    name: 'Reel',
    price: 1730000,
    imageUrl: 'assets/reeler.jpg', // perhatikan: nama file "reeler"
  ),
  Product(
    id: 'p4',
    name: 'Casting',
    price: 500000,
    imageUrl: 'assets/casting.jpg',
  ),
  Product(
    id: 'p5',
    name: 'Pelampung',
    price: 20000,
    imageUrl: 'assets/pelampung.jpg',
  ),
  Product(
    id: 'p6',
    name: 'Senar',
    price: 1500000,
    imageUrl: 'assets/senar.jpg',
  ),
];

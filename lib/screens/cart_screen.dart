// ============================================================
// FILE: lib/screens/cart_screen.dart
// FUNGSI UTAMA: Halaman KERANJANG BELANJA — menampilkan total
// pembayaran, daftar item yang dipilih, dan tombol "PESAN
// SEKARANG". Halaman ini dibuka dari CatalogScreen saat ikon
// keranjang (BadgeCounter) ditekan.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String _formatRupiah(int price) {
    // (fungsi format Rupiah yang sama, diulang di sini karena
    //  setiap file berdiri sendiri — bisa juga dipindah ke file
    //  "utils.dart" terpisah supaya tidak duplikat, sebagai ide
    //  pengembangan lebih lanjut)
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    // ^ ⭐ context.watch() dipakai di SINI (level Screen) karena
    //   HAMPIR SELURUH tampilan halaman ini (total harga, daftar
    //   item, status kosong/tidak) bergantung pada data
    //   CartProvider. Jadi lebih efisien "watch" sekali di level
    //   atas, lalu data-nya diturunkan (pass down) ke widget anak
    //   seperti CartTile lewat parameter biasa.

    final itemList = cartProvider.itemList;
    // ambil daftar CartItem dari provider untuk ditampilkan

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23C16B),
        elevation: 0,
        leading: IconButton(
          // ^ "leading" = posisi KIRI AppBar, biasanya untuk
          //   tombol kembali/back.
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          // ^ Navigator.pop() = kembali ke halaman sebelumnya
          //   (CatalogScreen), kebalikan dari Navigator.push()
          //   yang dipakai di BadgeCounter untuk membuka halaman ini.
        ),
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
      ),
      body: SafeArea(
        child: itemList.isEmpty
            // ^ CONDITIONAL RENDERING: tampilkan UI BERBEDA
            //   tergantung apakah keranjang kosong atau tidak.
            ? _buildEmptyState()
            : Column(
                children: [
                  // ----------------------------------------
                  // BAGIAN 1: Container "Total Pembayaran"
                  // ----------------------------------------
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ^ mendorong 2 elemen anak ke TEPI KIRI dan
                      //   TEPI KANAN Row (label di kiri, angka di kanan)
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          _formatRupiah(cartProvider.totalPrice),
                          // ^ totalPrice diambil LANGSUNG dari
                          //   getter di CartProvider — akan otomatis
                          //   update setiap kali quantity berubah,
                          //   berkat context.watch() di atas.
                          style: const TextStyle(
                            color: Color(0xFF00A3FF), // biru
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ----------------------------------------
                  // BAGIAN 2: Daftar item keranjang (scrollable)
                  // ----------------------------------------
                  Expanded(
                    // ^ Expanded memaksa bagian ini mengisi SISA
                    //   ruang vertikal yang ada (di antara Container
                    //   Total di atas dan tombol Pesan di bawah).
                    child: SingleChildScrollView(
                      // ^ Membungkus daftar item dengan kemampuan
                      //   SCROLL, mencegah "RenderFlex overflow"
                      //   kalau jumlah item lebih banyak dari
                      //   tinggi layar yang tersedia. Inilah yang
                      //   menjawab poin LKPD "Gunakan widget
                      //   responsif (SingleChildScrollView) untuk
                      //   mencegah layout overflow".
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: itemList
                            .map((cartItem) => CartTile(cartItem: cartItem))
                            .toList(),
                        // ^ .map() mengubah SETIAP CartItem di dalam
                        //   itemList menjadi satu widget CartTile.
                        //   Ini adalah cara "fungsional" (bukan
                        //   for-loop biasa) yang umum dipakai di
                        //   Dart/Flutter untuk mengubah List data
                        //   menjadi List widget.
                      ),
                    ),
                  ),

                  // ----------------------------------------
                  // BAGIAN 3: Tombol "PESAN SEKARANG"
                  // ----------------------------------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          _showOrderConfirmation(context, cartProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF23C16B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'PESAN SEKARANG',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // --------------------------------------------------------
  // WIDGET BANTU: tampilan saat keranjang masih kosong
  // --------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Keranjang belanja kosong',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // FUNGSI BANTU: menampilkan dialog konfirmasi pesanan
  // --------------------------------------------------------
  void _showOrderConfirmation(BuildContext context, CartProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Pesanan Berhasil'),
        content: Text(
          'Total ${_formatRupiah(provider.totalPrice)} akan segera diproses. Terima kasih!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.clearCart();
              // ^ mengosongkan keranjang lewat CartProvider
              Navigator.pop(ctx);      // tutup dialog
              Navigator.pop(context);  // kembali ke CatalogScreen
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF23C16B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

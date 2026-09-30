// ============================================================
// FILE: lib/widgets/cart_tile.dart
// FUNGSI UTAMA: Menampilkan SATU BARIS item di halaman
// keranjang (gambar kecil, nama, harga, tombol +/-). Dipanggil
// berulang kali oleh CartScreen sesuai jumlah item di keranjang.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartTile extends StatelessWidget {
  final CartItem cartItem;
  // ^ Widget ini menerima SATU objek CartItem (bukan Product
  //   biasa) karena butuh informasi quantity yang hanya dimiliki
  //   oleh CartItem.

  const CartTile({super.key, required this.cartItem});

  String _formatRupiah(int price) {
    // (fungsi sama seperti di product_card.dart — format Rupiah)
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
    final cartProvider = context.read<CartProvider>();
    // ^ Diambil SEKALI di awal (bukan watch), karena di file ini
    //   kita hanya perlu MEMANGGIL method-nya (increment/decrement)
    //   saat tombol ditekan — bukan untuk membaca data yang
    //   berubah-ubah terus-menerus. (Data cartItem sendiri sudah
    //   dikirim langsung dari CartScreen yang MEMANG watch().)

    return Container(
      margin: const EdgeInsets.only(bottom: 12), // jarak antar kartu
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        // ^ Row = menyusun widget anak SECARA HORIZONTAL:
        //   gambar | nama+harga | tombol +/-
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              // ⭐ Image.asset karena file gambar lokal
              cartItem.product.imageUrl,
              // ^ Perhatikan: cartItem.product.imageUrl —
              //   CartItem "menembus" ke dalam Product yang
              //   dibungkusnya untuk mengambil imageUrl.
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade100,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: Colors.grey, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            // ^ Expanded memaksa widget ini mengisi SISA ruang
            //   horizontal yang tersedia (supaya nama produk yang
            //   panjang tidak membuat Row overflow/kebocoran layout).
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatRupiah(cartItem.product.price),
                  style: const TextStyle(
                    color: Color(0xFF00A3FF),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            // ^ Kapsul abu-abu berisi tombol (-) angka (+)
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QtyButton(
                  icon: Icons.remove,
                  color: Colors.grey.shade700,
                  onTap: () =>
                      cartProvider.decrementQuantity(cartItem.product.id),
                  // ^ Memanggil method di CartProvider. Method ini
                  //   akan memanggil notifyListeners() di dalamnya,
                  //   sehingga CartScreen (yang watch()) otomatis
                  //   ter-refresh menampilkan quantity & total baru.
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${cartItem.quantity}', // angka quantity saat ini
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                _QtyButton(
                  icon: Icons.add,
                  color: const Color(0xFF00A3FF),
                  onTap: () =>
                      cartProvider.incrementQuantity(cartItem.product.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WIDGET KECIL TAMBAHAN (private, hanya dipakai di file ini)
// ------------------------------------------------------------
// Dipisah menjadi class sendiri karena dipakai 2x (tombol + dan
// tombol -) dengan tampilan mirip, supaya kode tidak ditulis
// dua kali (prinsip DRY: Don't Repeat Yourself).
// ============================================================
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  // ^ VoidCallback = tipe data untuk fungsi yang "tidak menerima
  //   parameter dan tidak mengembalikan nilai apa-apa" — cocok
  //   untuk aksi seperti onTap yang cuma "menjalankan sesuatu".

  const _QtyButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // ^ InkWell = area yang bisa ditekan/tap, dengan efek
      //   "riak air" (ripple) khas Material Design saat disentuh.
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12), // warna transparan tipis
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

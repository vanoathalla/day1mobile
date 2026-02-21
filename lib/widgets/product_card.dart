import 'package:flutter/material.dart';
import '../pages/detail_hape_page.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailHapePage(product: product),
          ),
        );
      },
      // INI PEMBUNGKUS KARTU UTAMA (DARK MODE)
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141414), // Abu-abu gelap bgt
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white12,
            width: 1,
          ), // Border tipis kalcer
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN FOTO & BADGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'image_${product['id']}',
                      child: Image.network(
                        product['image_url'] ??
                            'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // INI BADGE KONDISI (BARU/BEKAS)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: product['condition'] == 'Baru'
                              ? Colors.green.withOpacity(0.9)
                              : Colors.orange.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product['condition'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // BAGIAN TEKS NAMA & HARGA
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'No Name',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${product['price'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF5400), // Warna Electric Orange
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

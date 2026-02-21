import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'success_page.dart'; // Import halaman suksesnya

class DetailHapePage extends StatelessWidget {
  final Map<String, dynamic> product;

  const DetailHapePage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0A0A0A,
      ), // Background utama gelap ala Jaksel
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0A),
            foregroundColor: Colors.white, // Tombol back jadi putih
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'image_${product['id']}',
                child: Image.network(
                  product['image_url'] ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0A), // Nyatu sama background atasnya
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Kondisi
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414), // Abu-abu card
                      border: Border.all(
                        color: Colors.white12,
                      ), // Border tipis kalcer
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Kondisi: ${product['condition'] ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Judul Barang
                  Text(
                    product['name'] ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Harga
                  Text(
                    'Rp ${product['price'] ?? 0}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF5400), // Electric Orange
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dummy Profil Penjual (Vibes Dark Mode)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(
                          0xFFFF5400,
                        ).withOpacity(0.15),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFFFF5400),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Simonk Store',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Aktif 5 menit yang lalu • Yogyakarta',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Color(0xFFFF5400)),
                        ),
                        child: const Text(
                          'Follow',
                          style: TextStyle(color: Color(0xFFFF5400)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 40,
                    thickness: 1,
                    color: Colors.white12,
                  ), // Garis pembatas tipis

                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Isi Deskripsi
                  Text(
                    product['description'] ??
                        'Seller-nya mager nulis deskripsi bre.',
                    style: const TextStyle(
                      fontSize: 15,
                      color:
                          Colors.white70, // Putih agak redup biar enak dibaca
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100), // Spasi aman buat bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      // Sticky Bottom Bar ala E-Commerce Dark Mode
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF141414), // Background bar agak nongol
            border: Border(top: BorderSide(color: Colors.white12)),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0A0A0A),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nanya "Barang ready bang?"'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5400),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    // 1. Keluarin efek loading nutupin layar
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Ga bisa di-cancel pake klik luar
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF5400),
                        ),
                      ),
                    );

                    try {
                      // 2. Tembak data transaksinya ke Supabase
                      await Supabase.instance.client
                          .from('transactions')
                          .insert({
                            'product_name': product['name'],
                            'price': product['price'],
                            'buyer_name': 'Simonk',
                            'status': 'LUNAS',
                          });

                      // 3. Pastiin layar lu masih aktif
                      if (context.mounted) {
                        Navigator.pop(context); // Matiin loading-nya

                        // Pindah ke layar sukses (dan ga bisa di-back ke halaman bayar lagi)
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuccessPage(),
                          ),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      // Kalo misal error atau ga ada internet
                      if (context.mounted) {
                        Navigator.pop(context); // Matiin loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error bre: $e')),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Jokul Sekarang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

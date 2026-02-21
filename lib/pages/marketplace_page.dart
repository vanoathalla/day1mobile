import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/product_card.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  late Future<List<Map<String, dynamic>>> _futureProducts;

  // 1. Bikin controller buat nangkep teks dari Search Bar
  final TextEditingController _searchController = TextEditingController();

  // 2. State buat nyimpen kategori apa yang lagi di-klik
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // 3. Logic narik data yang udah di-upgrade biar dinamis
  void _fetchData() {
    setState(() {
      var query = Supabase.instance.client.from('products').select();

      // Kalo user ngetik di search bar, filter datanya pake fungsi 'ilike'
      if (_searchController.text.isNotEmpty) {
        query = query.ilike('name', '%${_searchController.text}%');
      }

      // Kalo user nge-klik chip kategori, filter kondisinya
      if (_selectedCategory == 'Baru') {
        query = query.eq('condition', 'Baru');
      } else if (_selectedCategory == 'Bekas') {
        query = query.eq('condition', 'Bekas');
      }

      _futureProducts = query.order('created_at', ascending: false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'JokulGadget.',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white70,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white70,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFFFF5400),
        backgroundColor: const Color(0xFF141414),
        onRefresh: () async {
          _fetchData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= SEARCH BAR AKTIF =================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    // Pas di-enter / diketik, langsung nge-refresh data
                    onSubmitted: (value) => _fetchData(),
                    onChanged: (value) {
                      // Opsional: Kalo mau auto-search pas ngetik kaga usah di-enter
                      // _fetchData();
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search, color: Colors.white54),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.white54,
                                size: 18,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _fetchData();
                                FocusScope.of(
                                  context,
                                ).unfocus(); // Nutup keyboard
                              },
                            )
                          : null,
                      hintText: 'Cari iPhone, Samsung, dll...',
                      hintStyle: const TextStyle(color: Colors.white30),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              // ================= KATEGORI CHIPS AKTIF =================
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildChip('Semua'),
                    _buildChip('Bekas'),
                    _buildChip('Baru'),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Rekomendasi Buat Lu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // ================= GRID PRODUK =================
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  // Deteksi lebar layar buat grid
                  final screenWidth = MediaQuery.of(context).size.width;
                  int crossAxisCount = 2;
                  if (screenWidth > 600) crossAxisCount = 3;
                  if (screenWidth > 900) crossAxisCount = 4;

                  // 1. KALO LAGI LOADING: TAMPILIN SHIMMER
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6, // Nampilin 6 kotak loading bayangan
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: const Color(0xFF1A1A1A), // Warna abu gelap
                          highlightColor: const Color(
                            0xFF333333,
                          ), // Warna kilapnya
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  final products = snapshot.data ?? [];

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi buat bikin tombol kategori bisa di-klik dan berubah warna
  Widget _buildChip(String label) {
    final isSelected = _selectedCategory == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = label; // Ubah state kategori
          });
          _fetchData(); // Tarik data ulang berdasarkan kategori baru
        },
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: isSelected
              ? const Color(0xFFFF5400)
              : const Color(0xFF141414),
          side: BorderSide(
            color: isSelected ? const Color(0xFFFF5400) : Colors.white12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

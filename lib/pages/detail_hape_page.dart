import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'success_page.dart';

class DetailHapePage extends StatefulWidget {
  final Map<String, dynamic> product;
  const DetailHapePage({super.key, required this.product});

  @override
  State<DetailHapePage> createState() => _DetailHapePageState();
}

class _DetailHapePageState extends State<DetailHapePage> {
  String _currentAddress =
      "Informatics UPN \"Veteran\" Yogyakarta, Sleman, DIY";

  Future<void> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentAddress =
          "📍 Koordinat GPS: ${position.latitude}, ${position.longitude}";
    });
  }

  Future<void> _prosesBayar(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF5400))),
    );
    try {
      await Supabase.instance.client.from('transactions').insert({
        'product_name': widget.product['name'],
        'price': widget.product['price'],
        'buyer_name': 'Simonk Pulunkkk',
        'status': 'LUNAS',
      });
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SuccessPage()),
            (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal bre: $e')));
      }
    }
  }

  void _showCheckoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Checkout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const Divider(height: 32, color: Colors.white12),
                  const Text('Alamat Pengiriman',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  StatefulBuilder(builder: (context, setSheetState) {
                    return Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Color(0xFFFF5400), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(_currentAddress,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13))),
                        TextButton(
                          onPressed: () async {
                            await _determinePosition();
                            setSheetState(() {});
                          },
                          child: const Text('Ganti Lokasi',
                              style: TextStyle(color: Color(0xFFFF5400))),
                        ),
                      ],
                    );
                  }),
                  const Divider(height: 32, color: Colors.white12),
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                              widget.product['image_url'] ?? '',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: Text(widget.product['name'] ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  const Divider(height: 32, color: Colors.white12),
                  const Text('Ringkasan Pembayaran',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                      'Total Harga', 'Rp ${widget.product['price']}'),
                  _buildPriceRow('Total Ongkir', 'Rp 15.000'),
                  const Divider(height: 24, color: Colors.white12),
                  _buildPriceRow(
                      'Total Tagihan', 'Rp ${widget.product['price']}',
                      isTotal: true),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5400),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () => _prosesBayar(context),
                    child: const Text('Bayar Sekarang',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: isTotal ? Colors.white : Colors.white54,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(price,
              style: TextStyle(
                  color: isTotal ? const Color(0xFFFF5400) : Colors.white,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0A),
            flexibleSpace: FlexibleSpaceBar(
                background: Image.network(widget.product['image_url'] ?? '',
                    fit: BoxFit.cover)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product['name'] ?? '',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Rp ${widget.product['price']}',
                      style: const TextStyle(
                          fontSize: 28,
                          color: Color(0xFFFF5400),
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFF141414),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5400),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () => _showCheckoutSheet(context),
          child: const Text('Jokul Sekarang',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

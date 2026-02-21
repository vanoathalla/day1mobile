import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('History Transaksi'),
        backgroundColor: const Color(0xFF0A0A0A),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Supabase.instance.client
            .from('transactions')
            .select()
            .order('created_at'),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF5400)),
            );
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                leading: const Icon(
                  Icons.shopping_bag,
                  color: Color(0xFFFF5400),
                ),
                title: Text(
                  item['product_name'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Rp ${item['price']}',
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: const Text(
                  'LUNAS',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

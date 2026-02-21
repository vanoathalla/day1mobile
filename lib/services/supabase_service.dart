import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> getProducts() async {
    return await client
        .from('products')
        .select()
        .order('created_at', ascending: false);
  }
}

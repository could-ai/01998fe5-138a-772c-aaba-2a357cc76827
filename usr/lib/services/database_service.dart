import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class DatabaseService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.from('products').select().order('created_at', ascending: false);
      _products = response.map((item) => Product.fromMap(item)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _supabase.from('products').insert(product.toMap());
      await fetchProducts();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding product: $e');
      }
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _supabase.from('products').update(product.toMap()).eq('id', product.id);
      await fetchProducts();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating product: $e');
      }
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _supabase.from('products').delete().eq('id', id);
      await fetchProducts();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting product: $e');
      }
    }
  }
}

import 'dart:convert';

import 'package:api_crud_operation/product_model.dart';
import 'package:api_crud_operation/urls.dart';
import 'package:http/http.dart' as http;

class ProductController {
  List<Data> products = [];

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(Urls.readProduct));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Product_Model model = Product_Model.fromJson(data);
      products = model.data ?? [];
    }
  }

  Future<void> createProducts(
    String productName,
    String productImg,
    int qty,
    int unitPrice,
    int totalPrice,
    String? productId,
    bool isUpdate,
  ) async {
    final response = await http.post(
      Uri.parse(isUpdate ? Urls.updateProduct(productId!) : Urls.createProduct),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "ProductName": productName,
        "ProductCode": DateTime.now().microsecondsSinceEpoch,
        "Img": productImg,
        "Qty": qty,
        "UnitPrice": unitPrice,
        "TotalPrice": totalPrice,
      }),
    );

    if (response.statusCode == 201) {
      fetchProducts();
    }
  }

  Future<bool> deleteProducts(String productId) async {
    final response = await http.get(Uri.parse(Urls.deleteProduct(productId)));

    if (response.statusCode == 200) {
      fetchProducts();
      return true;
    } else {
      return false;
    }
  }
}

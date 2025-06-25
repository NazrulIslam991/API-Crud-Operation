import 'package:api_crud_operation/product_cart.dart';
import 'package:api_crud_operation/product_controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: API_Curd_operation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class API_Curd_operation extends StatefulWidget {
  const API_Curd_operation({super.key});

  @override
  State<API_Curd_operation> createState() => _API_Curd_operationState();
}

class _API_Curd_operationState extends State<API_Curd_operation> {
  final ProductController productController = ProductController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      productController.fetchProducts();
    });
  }

  void productDialog({
    String? id,
    String? name,
    String? img,
    int? qty,
    int? unitPrice,
    int? totalPrice,
    required bool isUpdate,
  }) {
    TextEditingController productNameController = TextEditingController();
    TextEditingController productQNTController = TextEditingController();
    TextEditingController productImageController = TextEditingController();
    TextEditingController productUnitPriceController = TextEditingController();
    TextEditingController productTotalPriceController = TextEditingController();

    productNameController.text = name ?? '';
    productImageController.text = img ?? '';
    productQNTController.text = qty != null ? qty.toString() : '';
    productUnitPriceController.text = unitPrice != null
        ? unitPrice.toString()
        : '';
    productTotalPriceController.text = totalPrice != null
        ? totalPrice.toString()
        : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isUpdate ? "Update Product" : "Add Product"),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Product Name'),
                controller: productNameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Product Quentity'),
                controller: productQNTController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Product Image'),
                controller: productImageController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Product Unit Price'),
                controller: productUnitPriceController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Product Total Price'),
                controller: productTotalPriceController,
              ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Close"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      productController.createProducts(
                        productNameController.text.trim(),
                        productImageController.text.trim(),
                        int.parse(productQNTController.text.trim()),
                        int.parse(productUnitPriceController.text.trim()),
                        int.parse(productTotalPriceController.text.trim()),
                        id,
                        isUpdate,
                      );
                      Navigator.pop(context);
                      await productController.fetchProducts();
                      setState(() {});
                    },
                    child: Text(isUpdate ? "Update Product" : "Add Product"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => productDialog(isUpdate: false),
        child: Icon(Icons.add),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          childAspectRatio: 3 / 4,
          mainAxisSpacing: 5,
        ),
        itemCount: productController.products.length,
        itemBuilder: (context, index) {
          var product = productController.products[index];
          return Product_Card(
            onEdit: () {
              productDialog(
                name: product.productName,
                img: product.img,
                id: product.sId,
                unitPrice: product.unitPrice,
                totalPrice: product.totalPrice,
                qty: product.qty,
                isUpdate: true,
              );
            },
            onDelete: () {
              productController.deleteProducts(product.sId.toString()).then((
                value,
              ) async {
                if (value) {
                  await productController.fetchProducts();

                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("product Delete successfully"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Something Wrong"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              });
            },
            product: product,
          );
        },
      ),
    );
  }
}

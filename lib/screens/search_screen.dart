import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:ecommerce_flutter_admin/models/product_model.dart';
import 'package:ecommerce_flutter_admin/provider/product_provider.dart';
import 'package:ecommerce_flutter_admin/widget/product_widget.dart';
import 'package:ecommerce_flutter_admin/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routName = "/SearchScreen";

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search = TextEditingController();
  List<ProductModel> _searchList = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadOnce();
  }

  Future<void> _loadOnce() async {
    setState(() => _loading = true);
    try {
      await context.read<ProductProvider>().fetchProducts();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductProvider>();
    final List<ProductModel> all = productsProvider.products;

    final String? passedCategory =
        ModalRoute.of(context)?.settings.arguments as String?;
    final baseList = passedCategory == null
        ? all
        : productsProvider.findByCategory(categoryName: passedCategory);

    final showList = _search.text.isNotEmpty ? _searchList : baseList;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
          title: TitleTextWidget(label: passedCategory ?? "All Products"),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : baseList.isEmpty
                ? const Center(child: TitleTextWidget(label: "No product"))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        TextField(
                          controller: _search,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _search.clear();
                                setState(() => _searchList = []);
                                FocusScope.of(context).unfocus();
                              },
                              child: const Icon(Icons.clear, color: Colors.red),
                            ),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              _searchList = productsProvider.searchQuery(
                                searchText: _search.text,
                                passedList: baseList,
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_search.text.isNotEmpty && _searchList.isEmpty)
                          const Center(
                              child:
                                  TitleTextWidget(label: "No products found")),
                        Expanded(
                          child: DynamicHeightGridView(
                            mainAxisSpacing: 12,
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            itemCount: showList.length,
                            builder: (context, index) {
                              return ProductWidget(
                                productId: showList[index].productId,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

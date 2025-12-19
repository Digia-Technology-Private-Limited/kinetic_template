import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/store_provider.dart';
import '../../data/models/catalog_models.dart';
import '../../widgets/common/icon_buttons.dart';
import '../../widgets/product/product_card.dart';
import '../../widgets/common/loading_state.dart';
import '../pdp/product_details_page.dart';

class SelectedCategoryPage extends StatefulWidget {
  final String handle;
  final String title;

  const SelectedCategoryPage({
    Key? key,
    required this.handle,
    required this.title,
  }) : super(key: key);

  @override
  State<SelectedCategoryPage> createState() => _SelectedCategoryPageState();
}

class _SelectedCategoryPageState extends State<SelectedCategoryPage> {
  bool _isLoading = true;
  Collection? _collection;

  @override
  void initState() {
    super.initState();
    _fetchCollection();
  }

  Future<void> _fetchCollection() async {
    final store = context.read<StoreProvider>();
    final col = await store.getCollectionByHandle(widget.handle);
    if (mounted) {
      setState(() {
        _collection = col;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        leading: BackArrowButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          widget.title,
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgLight2,
            ),
            child: const Icon(Icons.search, color: AppColors.black100),
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingState()
          : _collection == null || _collection!.products.isEmpty
          ? const Center(child: Text("No products found"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_collection!.products.length} Products",
                    style: AppTextStyles.bodyLargeBold,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: _collection!.products.length,
                      itemBuilder: (context, index) {
                        final prod = _collection!.products[index];
                        return ProductCard(
                          product: prod,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsPage(product: prod),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

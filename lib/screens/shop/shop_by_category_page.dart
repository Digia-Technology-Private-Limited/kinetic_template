import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/store_provider.dart';
import '../../widgets/common/icon_buttons.dart';
import '../../widgets/product/category_tiles.dart';
import 'selected_category_page.dart';

class ShopByCategoryPage extends StatelessWidget {
  const ShopByCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Expect store to be populated or fetch.
    // Assuming HomePage already fetched collections.
    final store = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        leading: BackArrowButton(onPressed: () => Navigator.pop(context)),
        title: Text(
          "Shop by Categories",
          style: AppTextStyles.h2Medium.copyWith(fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: store.collections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final col = store.collections[index];
          return CategoryVertical(
            title: col.title,
            count:
                0, // Count not available in basic collection query easily without product loop
            imageUrl: col.imageUrl ?? 'https://via.placeholder.com/64',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectedCategoryPage(
                    handle: col.handle ?? '',
                    title: col.title,
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

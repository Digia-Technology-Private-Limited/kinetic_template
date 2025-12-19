import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/store_provider.dart';
import '../../widgets/product/product_card.dart';
import '../../widgets/product/category_tiles.dart';
import '../../widgets/common/loading_state.dart';
import '../../widgets/home/banner_carousel.dart';
import '../../widgets/home/announcement_banner.dart';
import 'package:flutter/services.dart';
import '../cart/cart_page.dart';
import '../shop/selected_category_page.dart';
import '../pdp/product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().loadHomePageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: AppColors.white100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: GestureDetector(
          onTap: () {
            // Navigate to profile or menu
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgLight2,
            ),
            clipBehavior: Clip.hardEdge,
            child: store.avatar != null
                ? Image.network(store.avatar!, fit: BoxFit.cover)
                : const Icon(Icons.person, color: AppColors.black100),
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bgLight2,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Text(
                    store.gender ?? "Men",
                    style: AppTextStyles.bodySmallBold,
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.black100,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: AppColors.primary100,
                radius: 20,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: store.isLoading
          ? const LoadingState()
          : Column(
              children: [
                // Announcement Banner
                const AnnouncementBanner(
                  text:
                      "🎉 Free Shipping on Orders Over \$50! Limited Time Offer",
                  icon: Icons.local_shipping,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        context.read<StoreProvider>().loadHomePageData(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner Carousel
                          BannerCarousel(
                            banners: [
                              BannerItem(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800',
                                title: 'Summer Collection',
                                subtitle: 'Up to 50% Off',
                              ),
                              BannerItem(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
                                title: 'New Arrivals',
                                subtitle: 'Shop the Latest Trends',
                              ),
                              BannerItem(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1445205170230-053b83016050?w=800',
                                title: 'Accessories',
                                subtitle: 'Complete Your Look',
                              ),
                              BannerItem(
                                imageUrl:
                                    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800',
                                title: 'Premium Quality',
                                subtitle: 'Crafted to Perfection',
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Search Bar
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.bgLight2,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search,
                                  color: AppColors.black100,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Search",
                                  style: AppTextStyles.bodyLargeMedium.copyWith(
                                    color: AppColors.black50,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Categories Header
                          Text(
                            "Categories",
                            style: AppTextStyles.h2Medium.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Categories List
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: store.collections.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final col = store.collections[index];
                                return CategoryHorizontal(
                                  title: col.title,
                                  imageUrl:
                                      col.imageUrl ??
                                      'https://via.placeholder.com/64',
                                  onTap: () {
                                    if (col.handle != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SelectedCategoryPage(
                                            handle: col.handle!,
                                            title: col.title,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Repeated Sections for each Category
                          ...store.collections.map((col) {
                            if (col.products.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      col.title,
                                      style: AppTextStyles.h2Medium.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (col.handle != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  SelectedCategoryPage(
                                                    handle: col.handle!,
                                                    title: col.title,
                                                  ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "See All",
                                        style: AppTextStyles.bodyLargeMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 260,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: col.products.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 16),
                                    itemBuilder: (context, index) {
                                      final prod = col.products[index];
                                      return SizedBox(
                                        width: 160,
                                        child: ProductCard(
                                          product: prod,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProductDetailsPage(
                                                      product: prod,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

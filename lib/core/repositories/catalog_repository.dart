import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract interface class CatalogRepository {
  Stream<List<CategoryModel>> watchCategories();
  Stream<List<BannerModel>> watchBanners();
  Stream<List<ProductModel>> watchProducts();
  Stream<ProductModel?> watchProduct(String productId);
}

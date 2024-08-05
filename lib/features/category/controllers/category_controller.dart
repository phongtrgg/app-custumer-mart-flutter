import 'package:stackfood_multivendor/common/models/product_model.dart';
import 'package:stackfood_multivendor/common/models/restaurant_model.dart';
import 'package:stackfood_multivendor/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor/features/category/domain/services/category_service_interface.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;

  CategoryController({required this.categoryServiceInterface});

  List<CategoryModel>? _categoryList;

  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _servicesList;

  List<CategoryModel>? get servicesList => _servicesList;

  List<CategoryModel>? _subCategoryList;

  List<CategoryModel>? get subCategoryList => _subCategoryList;

  List<Product>? _categoryProductList;

  List<Product>? get categoryProductList => _categoryProductList;

  List<Restaurant>? _categoryRestaurantList;

  List<Restaurant>? get categoryRestaurantList => _categoryRestaurantList;

  List<Product>? _searchProductList = [];

  List<Product>? get searchProductList => _searchProductList;

  List<Restaurant>? _searchRestaurantList = [];

  List<Restaurant>? get searchRestaurantList => _searchRestaurantList;

  // List<bool>? _interestCategorySelectedList;
  // List<bool>? get interestCategorySelectedList => _interestCategorySelectedList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int? _pageSize;

  int? get pageSize => _pageSize;

  int? _restaurantPageSize;

  int? get restaurantPageSize => _restaurantPageSize;

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  int _categoryIndex = 0;

  int get categoryIndex => _categoryIndex;

  String? _categoryTitle;

  String get categoryTitle => _categoryTitle ?? '';

  int _subCategoryIndex = 0;

  int get subCategoryIndex => _subCategoryIndex;

  String _type = 'all';

  String get type => _type;

  bool _isRestaurant = false;

  bool get isRestaurant => _isRestaurant;

  String? _searchText = '';

  String? get searchText => _searchText;

  int _offset = 1;

  int get offset => _offset;

  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  // String? _restResultText = '';
  // String? _foodResultText = '';

  Future<void> getCategoryList(bool reload) async {
    if (_categoryList == null || reload) {
      _categoryList = await categoryServiceInterface.getCategoryList(reload, _categoryList);
      // _interestCategorySelectedList = categoryServiceInterface.processCategorySelectedList(_categoryList);
      update();
    }
  }

  Future<void> getServicesList(bool reload) async {
    if (_servicesList == null || reload) {
      _servicesList = await categoryServiceInterface.getServicesList(reload, _servicesList);
      update();
    }
  }

  void getSubCategoryList(String? categoryID) async {
    _subCategoryIndex = 0;
    _subCategoryList = null;
    _categoryProductList = null;
    _isRestaurant = false;
    _subCategoryList = await categoryServiceInterface.getSubCategoryList(categoryID);
    _subCategoryChildrenList = await categoryServiceInterface.getSubCategoryChildrenList(categoryID);
    if (_subCategoryList != null && _subCategoryChildrenList != null) {
      // getCategoryProductList(categoryID, 1, 'all', false);
      setSubCategoryIndex(1, categoryID);
    }
  }

  void setSubCategorySelector(int index) {
    _subCategoryIndex = index;
  }

  void setSubCategoryIndex(int index, String? categoryID) async {
    _subCategoryIndex = index;
    clearSubCategoryChildrenList();
    _subCategoryChildrenList = await categoryServiceInterface.getSubCategoryChildrenList(categoryID);
    if (_subCategoryChildrenList!.length == 0) {
      if (_isRestaurant) {
        getCategoryRestaurantList(_subCategoryIndex == 0 ? categoryID : _subCategoryList![index].id.toString(), 1, _type, true);
      } else {
        getCategoryProductList(_subCategoryIndex == 0 ? categoryID : _subCategoryList![index].id.toString(), 1, _type, true);
      }
    } else {
      getSubCategoryChildrenList(_subCategoryList![index].id.toString());
    }

    update();
  }

  void setCategoryIndexAndTitle(int index, String? title) {
    _categoryIndex = index;
    _categoryTitle = title;
    update();
  }

  void getCategoryProductList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _categoryProductList = null;
    }
    ProductModel? productModel = await categoryServiceInterface.getCategoryProductList(categoryID, offset, type);
    if (productModel != null) {
      if (offset == 1) {
        _categoryProductList = [];
      }
      _categoryProductList!.addAll(productModel.products!);
      _pageSize = productModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  void getCategoryRestaurantList(String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _categoryRestaurantList = null;
    }
    RestaurantModel? restaurantModel = await categoryServiceInterface.getCategoryRestaurantList(categoryID, offset, type);
    if (restaurantModel != null) {
      if (offset == 1) {
        _categoryRestaurantList = [];
      }
      _categoryRestaurantList!.addAll(restaurantModel.restaurants!);
      _restaurantPageSize = restaurantModel.totalSize;
      _isLoading = false;
    }
    update();
  }

  void searchData(String? query, String? categoryID, String type) async {
    if ((_isRestaurant && query!.isNotEmpty /*&& query != _restResultText*/) || (!_isRestaurant && query!.isNotEmpty /* && query != _foodResultText*/)) {
      _searchText = query;
      _type = type;
      if (_isRestaurant) {
        _searchRestaurantList = null;
      } else {
        _searchProductList = null;
      }
      _isSearching = true;
      update();

      Response response = await categoryServiceInterface.getSearchData(query, categoryID, _isRestaurant, type);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          if (_isRestaurant) {
            _searchRestaurantList = [];
          } else {
            _searchProductList = [];
          }
        } else {
          if (_isRestaurant) {
            _searchRestaurantList = [];
            _searchRestaurantList!.addAll(RestaurantModel.fromJson(response.body).restaurants!);
          } else {
            _searchProductList = [];
            _searchProductList!.addAll(ProductModel.fromJson(response.body).products!);
          }
        }
      }
      update();
    }
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    _searchProductList = [];
    if (_categoryProductList != null) {
      _searchProductList!.addAll(_categoryProductList!);
    }
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  // Future<bool> saveInterest(List<int?> interests) async {
  //   _isLoading = true;
  //   update();
  //   bool isSuccess = await categoryServiceInterface.saveUserInterests(interests);
  //   _isLoading = false;
  //   update();
  //   return isSuccess;
  // }

  // void addInterestSelection(int index) {
  //   _interestCategorySelectedList![index] = !_interestCategorySelectedList![index];
  //   update();
  // }

  void setRestaurant(bool isRestaurant) {
    _isRestaurant = isRestaurant;
    update();
  }

  setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    update();
  }

// category Children 3
  int _subCategoryChildrenIndex = 0;

  int get subCategoryChildrenIndex => _subCategoryChildrenIndex;
  List<CategoryModel>? _subCategoryChildrenList;

  List<CategoryModel>? get subCategoryChildrenList => _subCategoryChildrenList;

  //lưu lại vị trí index đã chọn
  int _selectedCategoryChildrenIndex = 0;

  int get selectedCategoryChildrenIndex => _selectedCategoryChildrenIndex;

//call lần đầu để lấy danh sách category 3
  void getSubCategoryChildrenList(String? categoryID) async {
    _subCategoryChildrenIndex = 0;
    _subCategoryChildrenList = null;
    _categoryProductList = null;
    _subCategoryChildrenList = await categoryServiceInterface.getSubCategoryChildrenList(categoryID);
    if (_subCategoryChildrenList!.isNotEmpty && _subCategoryIndex != 0) {
      getCategoryProductList(categoryID, 1, 'all', false);
    }

    if (_isRestaurant) {
      getCategoryRestaurantList(categoryID, 1, 'all', false);
    } else {
      getCategoryProductList(categoryID, 1, 'all', false);
    }
    update();
  }

  //chọn sang cate 3 khác sẽ gọi đến hàm này sẽ lọc trong danh sách cate 3 cũ và render đúng theo ID
  //**lưu ý chỉ sài khi đã có danh sách _subCategoryChildrenList
  void setSubCategoryChildrenIndex(int index, String? categoryID) {
    _subCategoryChildrenIndex = index;
    if (_subCategoryChildrenList == null || _subCategoryChildrenList!.isEmpty) {
      return;
    }

    if (index < 0 || index >= _subCategoryChildrenList!.length) {
      update();
      return;
    }
    if (_isRestaurant) {
      getCategoryRestaurantList(_subCategoryChildrenIndex == 0 ? categoryID : _subCategoryChildrenList![index].id.toString(), 1, _type, true);
    } else {
      getCategoryProductList(_subCategoryChildrenIndex == 0 ? categoryID : _subCategoryChildrenList![index].id.toString(), 1, _type, true);
    }
    update();
  }

  //lưu lại index đang chọn để style
  setSelectedCategoryChildrenIndex(int index) {
    _selectedCategoryChildrenIndex = index;
    update();
  }

  //xoá bỏ category tầng 3
  void clearSubCategoryChildrenList() {
    _selectedCategoryChildrenIndex = 0;
    _subCategoryChildrenList?.clear();
  }
//end category Children 3
}

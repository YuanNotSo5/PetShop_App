import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/controllers/Predict/predict_controller.dart';
import 'package:pet_shop/controllers/Product/filter_controller.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/screen/Product/ProductCategory/component/filter_componet.dart';
import 'package:pet_shop/screen/Product/components/product_loading_grid.dart';
import 'package:pet_shop/screen/Product/components/product_showing_grid.dart';

class ProductCategory extends StatefulWidget {
  final String name;
  final String idCate;
  final bool isSearch;
  final List<Product> productList;

  const ProductCategory({
    Key? key,
    this.productList = const [],
    this.isSearch = false,
    required this.name,
    required this.idCate,
  }) : super(key: key);

  @override
  _ProductCategoryState createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  final ProductController productController = Get.find<ProductController>();
  final FilterController filterController = Get.put(FilterController());
  PredictController predictController = Get.find<PredictController>();

  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;
  bool isFilter = false;
  bool _isLoadingMore = false;
  int currentPage = 1;

  void getMorePage() async {
    if (_isLoadingMore) return;
    if (!isFilter) {
      setState(() {
        currentPage++;
        _isLoadingMore = true;
      });

      List<Product> productNew =
          await productController.getMoreProductByCategory(
        widget.idCate,
        page: currentPage.toString(),
      );

      setState(() {
        widget.productList.addAll(productNew);
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        filterController.updateCurrentPage();
        _isLoadingMore = true;
      });

      List<Product> productNew =
          await filterController.getMoreProductFilter(idCate: widget.idCate);
      // filterController.productListSearch.addAll(productNew);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.offset >= 400) {
        if (!_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = true;
          });
        }
      } else {
        if (_showScrollToTopButton) {
          setState(() {
            _showScrollToTopButton = false;
          });
        }
      }

      if (_scrollController.position.atEdge) {
        bool isBottom = _scrollController.position.pixels != 0;
        if (isBottom) {
          getMorePage();
        }
      }
    });
  }

  void getData() async {
    await productController.getProductsByCategory(widget.idCate);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    predictController.productList.clear();
    productController.productList.clear();
    filterController.productListSearch.clear();
    filterController.updateChanged(false);
    filterController.updateReset(false);
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _refreshData() async {
    // Refresh logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      appBar: AppBar(
        title: Text('Sản phẩm ${widget.name}'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (!widget.isSearch)
                FilterComponet(
                  idCate: widget.idCate,
                ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height -
                                kToolbarHeight -
                                56,
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(
                            () {
                              //todo [Reset]
                              if (filterController.isChanged.value &&
                                  filterController.isReset.value) {
                                filterController.updateChanged(false);
                                isFilter = false;

                                return widget.productList.isNotEmpty
                                    ? ProductShowingGrid(
                                        productList: widget.productList)
                                    : ProductLoadingGrid();
                              }
                              //todo [Thay đổi]
                              else if (filterController.isChanged.value) {
                                isFilter = true;
                                // filterController.updateChanged(false);
                                filterController.updateReset(false);
                                return filterController
                                        .productListSearch.isNotEmpty
                                    ? ProductShowingGrid(
                                        productList:
                                            filterController.productListSearch)
                                    : Center(
                                        child:
                                            Text("Không tìm thấy sản phẩm nào"),
                                      );
                              }
                              return widget.productList.isNotEmpty
                                  ? ProductShowingGrid(
                                      productList: widget.productList)
                                  : ProductLoadingGrid();
                            },
                          ),
                        ),
                        if (_isLoadingMore)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showScrollToTopButton)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                child: Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
    );
  }
}

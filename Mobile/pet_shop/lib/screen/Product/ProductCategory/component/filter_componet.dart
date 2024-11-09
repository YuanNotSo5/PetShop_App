import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/controllers/Product/filter_controller.dart';

class FilterComponet extends StatefulWidget {
  final String idCate;
  const FilterComponet({Key? key, required this.idCate}) : super(key: key);

  @override
  _FilterComponetState createState() => _FilterComponetState();
}

class _FilterComponetState extends State<FilterComponet> {
  final FilterController filterController = Get.put(FilterController());

  //todo [Rating value]
  double ratingVal = 0.0;

  //todo [Range value]
  double minVal = 0.0;
  double maxVal = 0.0;

  //todo [Status chips]
  List<String> _allChips = [
    'Mới nhất',
    'Cũ nhất',
    'Còn hàng',
    'Phổ biến',
  ];
  List<String> _selectedChips = [];

  //todo [Container Chips]
  Map<String, String> _containerContent = {
    'Đánh giá': 'None',
    'Tình trạng': 'None',
    'Giá tiền': 'None',
  };

  void _showSelectionDialog() async {
    final previousSelectedChips = List.from(_selectedChips);

    final Map<String, dynamic>? selected =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return _SelectionDialog(
          allChips: _allChips,
          selectedChips: _selectedChips,
          ratingVal: ratingVal,
          minVal: minVal,
          maxVal: maxVal,
        );
      },
    );

    if (selected != null) {
      setState(
        () {
          //todo [Rating]
          _selectedChips = selected['chips'];
          if (selected['rating'] == 0 || selected['rating'] == null) {
            _containerContent['Đánh giá'] = 'None';
            ratingVal = 0.0;
          } else {
            _containerContent['Đánh giá'] = selected['rating'].toString();
            ratingVal = selected['rating'];
          }

          //todo [Status]
          _containerContent['Tình trạng'] =
              _selectedChips.isNotEmpty ? _selectedChips.join(', ') : 'None';

          //todo [Price]
          double start = selected['priceRange'].start.toDouble();
          double end = selected['priceRange'].end.toDouble();

          minVal = start.roundToDouble();
          maxVal = end.roundToDouble();

          if (start == 0 && end == 0) {
            _containerContent['Giá tiền'] = 'None';
          } else if (start == end) {
            _containerContent['Giá tiền'] =
                '> ${TransformCustomApp().formatCurrency(start.toInt())}';
          } else {
            _containerContent['Giá tiền'] =
                '${TransformCustomApp().formatCurrency(start.round())}-${TransformCustomApp().formatCurrency(end.round())}';
          }
          for (var chip in _selectedChips) {
            if (!previousSelectedChips.contains(chip)) {
              // _showToast("Selected: $chip");
            }
          }

          for (var chip in previousSelectedChips) {
            if (!_selectedChips.contains(chip)) {
              // _showToast("Removed: $chip");
            }
          }
        },
      );
      filterController.updateChanged(true);
      filterController.updateReset(false);
    } else {
      setState(
        () {
          _selectedChips.clear();
          _containerContent['Đánh giá'] = 'None';
          ratingVal = 0.0;
          _containerContent['Tình trạng'] = 'None';
          _containerContent['Giá tiền'] = 'None';
          minVal = 0.0;
          maxVal = 0.0;
        },
      );
      filterController.updateChanged(true);
      filterController.updateReset(true);
    }
    processingDate(_selectedChips, ratingVal, minVal, maxVal);
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  //todo [Handle Data]
  void processingDate(List<String> _selectedChips, double ratingVal,
      double minVal, double maxVal) async {
    filterController.updateFilters(
      chips: _selectedChips,
      rating: ratingVal,
      minPrice: minVal,
      maxPrice: maxVal,
      idCate: widget.idCate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // ! Body
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // todo [List Container Chips]
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _containerContent.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.purple,
                                  size: 20.0,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  '${entry.key}:',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0),
                                ),
                                SizedBox(width: 4.0),
                                Chip(
                                  label: Text(
                                    entry.value,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  deleteIcon: Icon(Icons.close),
                                  // onDeleted: entry.value != 'None'
                                  //     ? () {
                                  //         setState(
                                  //           () {
                                  //             if (entry.key == 'Giá tiền') {
                                  //               _containerContent['Giá tiền'] =
                                  //                   'None';

                                  //               minVal = 0.0;
                                  //               maxVal = 0.0;
                                  //             }
                                  //             if (entry.key == 'Tình trạng') {
                                  //               _selectedChips.clear();

                                  //               _containerContent[
                                  //                   'Tình trạng'] = 'None';
                                  //             }
                                  //             if (entry.key == 'Đánh giá') {
                                  //               _containerContent['Đánh giá'] =
                                  //                   'None';
                                  //               ratingVal = 0.0;
                                  //             }
                                  //           },
                                  //         );
                                  //         processingDate(_selectedChips,
                                  //             ratingVal, minVal, maxVal);
                                  //         filterController.updateChanged(true);
                                  //         filterController.updateReset(false);
                                  //       }
                                  //     : null,
                                  onDeleted: entry.value != 'None'
                                      ? () {
                                          setState(() {
                                            if (entry.key == 'Giá tiền') {
                                              _containerContent['Giá tiền'] =
                                                  'None';
                                              minVal = 0.0;
                                              maxVal = 0.0;
                                            }
                                            if (entry.key == 'Tình trạng') {
                                              _selectedChips.clear();
                                              _containerContent['Tình trạng'] =
                                                  'None';
                                            }
                                            if (entry.key == 'Đánh giá') {
                                              _containerContent['Đánh giá'] =
                                                  'None';
                                              ratingVal = 0.0;
                                            }

                                            // Check if all conditions for reset are met
                                            bool allReset = _containerContent[
                                                        'Giá tiền'] ==
                                                    'None' &&
                                                _containerContent[
                                                        'Tình trạng'] ==
                                                    'None' &&
                                                _containerContent['Đánh giá'] ==
                                                    'None' &&
                                                minVal == 0.0 &&
                                                maxVal == 0.0 &&
                                                ratingVal == 0.0 &&
                                                _selectedChips.isEmpty;

                                            if (allReset) {
                                              filterController
                                                  .updateReset(true);
                                            } else {
                                              filterController
                                                  .updateReset(false);
                                            }

                                            // Update filter changes
                                            processingDate(_selectedChips,
                                                ratingVal, minVal, maxVal);
                                            filterController
                                                .updateChanged(true);
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                //todo [Filter Button]
                Align(
                  alignment: Alignment.bottomRight,
                  child: FilterButton(
                      "assets/images/_project/Icons/Filter/fill_filter.png"),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  //todo [Filter button]
  MouseRegion FilterButton(String imgPath) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _showSelectionDialog,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(8),
            color: Color(0xffFD5D20),
          ),
          child: Image(
            image: AssetImage(imgPath),
            height: 25,
          ),
        ),
      ),
    );
  }
}

class _SelectionDialog extends StatefulWidget {
  final List<String> allChips;
  final List<String> selectedChips;
  double ratingVal;
  double minVal;
  double maxVal;

  _SelectionDialog({
    required this.allChips,
    required this.selectedChips,
    required this.ratingVal,
    required this.minVal,
    required this.maxVal,
  });

  @override
  __SelectionDialogState createState() => __SelectionDialogState();
}

class __SelectionDialogState extends State<_SelectionDialog> {
  late List<String> _tempSelectedChips;

  //todo [Rating dropdown]
  List<double> listRating = [1.0, 2.0, 3.0, 4.0, 5.0];
  double? selectedRating;

  //todo [Slide Range]
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _tempSelectedChips = List.from(widget.selectedChips);
    _currentRangeValues = RangeValues(widget.minVal, widget.maxVal);
  }

  @override
  Widget build(BuildContext context) {
    //todo [Popup]
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //todo [Popup - Header]
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bộ Lọc',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            //todo [Popup - Rating]
            Text(
              'Đánh giá',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField2<double>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                    ),
                    hint: widget.ratingVal == null || widget.ratingVal == 0
                        ? Text(
                            'Sản phẩm được đánh giá',
                            style: TextStyle(fontSize: 12),
                          )
                        : null,
                    value: widget.ratingVal == 0 ? null : widget.ratingVal,
                    items: listRating
                        .map(
                          (item) => DropdownMenuItem<double>(
                            value: item,
                            child: Row(
                              children: [
                                Text(
                                  item.toString(),
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRating = value;
                        widget.ratingVal = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            //todo [Popup - Status]

            SizedBox(height: 16),
            Text(
              'Tình trạng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            Wrap(
              spacing: 4.0,
              children: widget.allChips.map((chip) {
                return Container(
                  margin: EdgeInsets.all(2),
                  child: ChoiceChip(
                    label: Text(chip),
                    selected: _tempSelectedChips.contains(chip),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          if (chip == 'Mới nhất' &&
                              _tempSelectedChips.contains('Cũ nhất')) {
                            _tempSelectedChips.remove('Cũ nhất');
                          } else if (chip == 'Cũ nhất' &&
                              _tempSelectedChips.contains('Mới nhất')) {
                            _tempSelectedChips.remove('Mới nhất');
                          }
                          _tempSelectedChips.add(chip);
                        } else {
                          _tempSelectedChips
                              .removeWhere((item) => item == chip);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            //todo [Popup - SlideRange]
            SizedBox(height: 16),
            Text(
              'Giá tiền',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),
            RangeSlider(
              values: _currentRangeValues,
              min: 0,
              max: 1000000,
              divisions: 100,
              labels: RangeLabels(
                TransformCustomApp()
                    .formatCurrency(_currentRangeValues.start.round()),
                TransformCustomApp()
                    .formatCurrency(_currentRangeValues.end.round()),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
            //todo [Popup - Button Apply]

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //todo [Button Apply - Cancel]
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
                SizedBox(width: 8),
                //todo [Button Apply - Apply]
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                        {
                          'chips': _tempSelectedChips,
                          'rating': widget.ratingVal,
                          'priceRange': _currentRangeValues,
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: CustomAppColor.primaryColorOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Tìm sản phẩm",
                          style: GoogleFonts.raleway().copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

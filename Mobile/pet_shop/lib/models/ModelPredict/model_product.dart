import 'dart:convert';

class ModelProduct {
  final String label;
  final double probability;

  ModelProduct({required this.label, required this.probability});

  factory ModelProduct.fromJson(Map<String, dynamic> data) {
    return ModelProduct(
      label: data['label'],
      probability: data['probability']
          .toDouble(), // Ensure probability is converted to double
    );
  }
  @override
  String toString() {
    return 'ModelProduct{label: $label, probability: $probability}';
  }
}

List<ModelProduct> predListFromJson(String val) {
  final parsed = json.decode(val)['result'];
  return List<ModelProduct>.from(
      parsed.map((pred) => ModelProduct.fromJson(pred)));
}

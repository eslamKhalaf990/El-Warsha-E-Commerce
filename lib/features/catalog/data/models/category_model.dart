import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.description,
    super.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['categoryId'] ?? json['id'] ?? 0) as int,
      name: (json['name'] ?? '').toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': id,
      'name': name,
      if (description != null) 'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

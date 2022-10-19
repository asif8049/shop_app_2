class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavourite': isFavorite,
      };

//from json
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'] ?? "",
        description: json['description'] ?? "",
        price: double.parse((json['price'] ?? 0).toString()),
        imageUrl: json['imageUrl'] ?? "",
        isFavorite: json['isFavourite'] ?? false,
      );

  factory Product.empty() {
    return Product(
      id: '',
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
      isFavorite: false,
    );
  }
}

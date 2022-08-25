class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});



  static List<Product> products = [
    Product(name: 'Pepsi',
        price: 2.99,
        imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?cs=srgb&dl=pexels-mali-maeder-102104.jpg&fm=jpg'),


    Product(name: 'Coke',
        price: 4.99,
        imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?cs=srgb&dl=pexels-mali-maeder-102104.jpg&fm=jpg'),

    Product(name: 'Sprite',
        price: 5.99,
        imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?cs=srgb&dl=pexels-mali-maeder-102104.jpg&fm=jpg'),

    Product(name: 'Sprite',
        price: 5.99,
        imageUrl: 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?cs=srgb&dl=pexels-mali-maeder-102104.jpg&fm=jpg')


  ];
}
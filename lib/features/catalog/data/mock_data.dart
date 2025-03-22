import 'category_model.dart';
import 'product_model.dart';

final mockCategories = [
  Category(
    id: 'fish',
    name: 'Рыба',
    imageUrl: 'https://picsum.photos/200?random=1',
  ),
  Category(
    id: 'shrimp',
    name: 'Креветки',
    imageUrl: 'https://picsum.photos/200?random=2',
  ),
  Category(
    id: 'octopus',
    name: 'Осьминоги',
    imageUrl: 'https://picsum.photos/200?random=3',
  ),
];

final mockProducts = [
  Product(
    id: '1',
    name: 'Лосось',
    imageUrl: 'https://picsum.photos/200?random=4',
    price: 19.99,
    categoryId: 'fish',
  ),
  Product(
    id: '2',
    name: 'Креветки тигровые',
    imageUrl: 'https://picsum.photos/200?random=5',
    price: 24.99,
    categoryId: 'shrimp',
  ),
  Product(
    id: '3',
    name: 'Осьминог baby',
    imageUrl: 'https://picsum.photos/200?random=6',
    price: 29.99,
    categoryId: 'octopus',
  ),
];

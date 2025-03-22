import 'category_model.dart';
import 'product_model.dart';

final mockCategories = [
  Category(
      id: 'fish', name: 'Рыба', imageUrl: 'https://via.placeholder.com/150'),
  Category(
      id: 'shrimp',
      name: 'Креветки',
      imageUrl: 'https://via.placeholder.com/150'),
  Category(
      id: 'octopus',
      name: 'Осьминоги',
      imageUrl: 'https://via.placeholder.com/150'),
];

final mockProducts = [
  Product(
    id: '1',
    name: 'Лосось',
    imageUrl: 'https://via.placeholder.com/300',
    price: 19.99,
    categoryId: 'fish',
  ),
  Product(
    id: '2',
    name: 'Креветки тигровые',
    imageUrl: 'https://via.placeholder.com/300',
    price: 24.99,
    categoryId: 'shrimp',
  ),
  Product(
    id: '3',
    name: 'Осьминог baby',
    imageUrl: 'https://via.placeholder.com/300',
    price: 29.99,
    categoryId: 'octopus',
  ),
];

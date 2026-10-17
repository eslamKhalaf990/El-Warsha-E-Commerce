import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/product.dart';

final List<Category> mockCategories = [
  const Category(
    id: 1,
    name: 'خواتم',
    description: 'تشكيلة فاخرة من الخواتم المرصعة بالأحجار الكريمة والزركون',
  ),
  const Category(
    id: 2,
    name: 'أساور',
    description: 'أساور راقية بتصاميم عصرية وكلاسيكية تناسب جميع الإطلالات',
  ),
  const Category(
    id: 3,
    name: 'قلائد',
    description: 'قلائد وسلاسل أنيقة تضفي لمسة من السحر والأنوثة',
  ),
  const Category(
    id: 4,
    name: 'أقراط',
    description: 'أقراط متألقة تجمع بين البساطة والفخامة',
  ),
  const Category(
    id: 5,
    name: 'أطقم',
    description: 'أطقم إكسسوارات متكاملة للمناسبات الخاصة والعرائس',
  ),
];

final List<Product> mockProducts = [
  // 1: Ring 450 (Cart item 1) - imageUrl: null for fallback testing
  const Product(
    id: 1,
    name: 'خاتم الزمرد الملكي',
    description:
        'خاتم فاخر مرصع بحجر زمرد صناعي أخضر جذاب وإطار مطلي بالذهب عيار 18.',
    buyingPrice: 28000, // 280.00 EGP (internal cost, NEVER displayed in UI)
    sellingPrice: 45000, // 450.00 EGP
    discount: 0,
    totalPrice: 45000, // 450.00 EGP
    imageUrl: null, // Tests fallback UI
    sku: 'RNG-001',
    quantity: 8,
    categoryName: 'خواتم',
    categoryId: 1,
  ),
  // 2: Bracelet 650 (Cart item 2)
  const Product(
    id: 2,
    name: 'سوار اللؤلؤ الراقي',
    description:
        'سوار ناعم من حبات اللؤلؤ الطبيعي مع قفل مغناطيسي مطلي بالذهب.',
    buyingPrice: 40000, // 400.00 EGP
    sellingPrice: 65000, // 650.00 EGP
    discount: 0,
    totalPrice: 65000, // 650.00 EGP
    imageUrl:
        'https://images.unsplash.com/photo-1611591475819-797de1a72638?w=500',
    sku: 'BRC-002',
    quantity: 5,
    categoryName: 'أساور',
    categoryId: 2,
  ),
  // 3: Ring 350 (Cart item 3)
  const Product(
    id: 3,
    name: 'خاتم الزهور المرصع',
    description: 'تصميم أنثوي على شكل زهرة مرصعة بأحجار الزركون اللامعة.',
    buyingPrice: 20000, // 200.00 EGP
    sellingPrice: 35000, // 350.00 EGP
    discount: 0,
    totalPrice: 35000, // 350.00 EGP
    imageUrl:
        'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=500',
    sku: 'RNG-003',
    quantity: 12,
    categoryName: 'خواتم',
    categoryId: 1,
  ),
  // 4: Necklace with discount
  const Product(
    id: 4,
    name: 'قلادة الشفق الذهبية',
    description: 'قلادة رقيقة بتعليقة دائرية لامعة مطلية بالذهب الوردي.',
    buyingPrice: 50000,
    sellingPrice: 85000, // 850.00 EGP
    discount: 15000, // 150.00 EGP discount
    totalPrice: 70000, // 700.00 EGP
    imageUrl:
        'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=500',
    sku: 'NCK-004',
    quantity: 4,
    categoryName: 'قلائد',
    categoryId: 3,
  ),
  // 5: Earrings
  const Product(
    id: 5,
    name: 'أقراط الياقوت الكريستالية',
    description: 'أقراط متدلية بأحجار زجاجية براقة ذات بريق ماسي ملفت.',
    buyingPrice: 16000,
    sellingPrice: 28000, // 280.00 EGP
    discount: 0,
    totalPrice: 28000,
    imageUrl:
        'https://images.unsplash.com/photo-1630019852942-f89202989a59?w=500',
    sku: 'EAR-005',
    quantity: 15,
    categoryName: 'أقراط',
    categoryId: 4,
  ),
  // 6: Bridal Set with discount
  const Product(
    id: 6,
    name: 'طقم الأميرة الماسي',
    description: 'طقم فاخر يشمل قلادة وسوار وأقراط وخاتم للمناسبات الراقية.',
    buyingPrice: 120000,
    sellingPrice: 195000, // 1,950.00 EGP
    discount: 25000, // 250.00 EGP discount
    totalPrice: 170000, // 1,700.00 EGP
    imageUrl:
        'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=500',
    sku: 'SET-006',
    quantity: 3,
    categoryName: 'أطقم',
    categoryId: 5,
  ),
  // 7: Topaz Ring (OUT OF STOCK - quantity = 0)
  const Product(
    id: 7,
    name: 'خاتم التوباز السماوي',
    description: 'خاتم كلاسيكي بحجر توباز أزرق صافي محاط بهالة زركونية.',
    buyingPrice: 25000,
    sellingPrice: 42000, // 420.00 EGP
    discount: 0,
    totalPrice: 42000,
    imageUrl:
        'https://images.unsplash.com/photo-1603561591411-07134e71a2a9?w=500',
    sku: 'RNG-007',
    quantity: 0, // Out of stock!
    categoryName: 'خواتم',
    categoryId: 1,
  ),
  // 8: Tennis Bracelet with discount
  const Product(
    id: 8,
    name: 'سوار التنس البراق',
    description: 'سوار التنس الشهير المرصع بالكامل بأحجار زركونيا سويسرية.',
    buyingPrice: 60000,
    sellingPrice: 95000, // 950.00 EGP
    discount: 10000, // 100.00 EGP discount
    totalPrice: 85000, // 850.00 EGP
    imageUrl:
        'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=500',
    sku: 'BRC-008',
    quantity: 6,
    categoryName: 'أساور',
    categoryId: 2,
  ),
  // 9: Rose Heart Necklace (imageUrl: null)
  const Product(
    id: 9,
    name: 'قلادة القلب الوردي',
    description: 'قلادة رومانسية بتعليقة قلب من الكريستال الوردي اللامع.',
    buyingPrice: 32000,
    sellingPrice: 52000, // 520.00 EGP
    discount: 0,
    totalPrice: 52000,
    imageUrl: null, // Tests fallback UI
    sku: 'NCK-009',
    quantity: 9,
    categoryName: 'قلائد',
    categoryId: 3,
  ),
  // 10: Dangling Pearl Earrings with discount
  const Product(
    id: 10,
    name: 'أقراط اللؤلؤ المتدلية',
    description:
        'أقراط أنيقة بتصميم متدلٍ يجمع بين اللؤلؤ الأبيض وأحجار البافيه.',
    buyingPrice: 21000,
    sellingPrice: 39000, // 390.00 EGP
    discount: 5000, // 50.00 EGP discount
    totalPrice: 34000, // 340.00 EGP
    imageUrl:
        'https://images.unsplash.com/photo-1535632787350-4e68ef0ac584?w=500',
    sku: 'EAR-010',
    quantity: 11,
    categoryName: 'أقراط',
    categoryId: 4,
  ),
  // 11: Evening Star Set
  const Product(
    id: 11,
    name: 'طقم النجوم المسائية',
    description: 'طقم ناعم مستوحى من بريق النجوم في السماء الصافية.',
    buyingPrice: 85000,
    sellingPrice: 140000, // 1,400.00 EGP
    discount: 0,
    totalPrice: 140000,
    imageUrl:
        'https://images.unsplash.com/photo-1611591475819-797de1a72638?w=500',
    sku: 'SET-011',
    quantity: 4,
    categoryName: 'أطقم',
    categoryId: 5,
  ),
  // 12: Charm Bracelet with discount
  const Product(
    id: 12,
    name: 'سوار السحر الفضي',
    description: 'سوار فضي مطلي بالروديوم مع تعليقات متنوعة ترمز للحب والأمل.',
    buyingPrice: 27000,
    sellingPrice: 48000, // 480.00 EGP
    discount: 8000, // 80.00 EGP discount
    totalPrice: 40000, // 400.00 EGP
    imageUrl:
        'https://images.unsplash.com/photo-1611591475819-797de1a72638?w=500',
    sku: 'BRC-012',
    quantity: 7,
    categoryName: 'أساور',
    categoryId: 2,
  ),
];

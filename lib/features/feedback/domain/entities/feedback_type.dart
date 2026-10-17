enum FeedbackType {
  general,
  product,
  service,
  order,
  suggestion,
  complaint;

  String get labelAr {
    switch (this) {
      case FeedbackType.general:
        return 'عام';
      case FeedbackType.product:
        return 'تقييم منتج';
      case FeedbackType.service:
        return 'خدمة العملاء';
      case FeedbackType.order:
        return 'طلب وتوصيل';
      case FeedbackType.suggestion:
        return 'اقتراح';
      case FeedbackType.complaint:
        return 'شكوى';
    }
  }

  String get apiValue {
    switch (this) {
      case FeedbackType.general:
        return 'GENERAL';
      case FeedbackType.product:
        return 'PRODUCT';
      case FeedbackType.service:
        return 'SERVICE';
      case FeedbackType.order:
        return 'ORDER';
      case FeedbackType.suggestion:
        return 'SUGGESTION';
      case FeedbackType.complaint:
        return 'COMPLAINT';
    }
  }

  static FeedbackType fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'PRODUCT':
        return FeedbackType.product;
      case 'SERVICE':
        return FeedbackType.service;
      case 'ORDER':
        return FeedbackType.order;
      case 'SUGGESTION':
        return FeedbackType.suggestion;
      case 'COMPLAINT':
        return FeedbackType.complaint;
      case 'GENERAL':
      default:
        return FeedbackType.general;
    }
  }
}

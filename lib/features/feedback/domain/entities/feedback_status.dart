enum FeedbackStatus {
  pending,
  approved,
  rejected,
  resolved;

  String get labelAr {
    switch (this) {
      case FeedbackStatus.pending:
        return 'قيد المراجعة';
      case FeedbackStatus.approved:
        return 'تم النشر';
      case FeedbackStatus.resolved:
        return 'تم الحل';
      case FeedbackStatus.rejected:
        return 'مرفوض';
    }
  }

  String get apiValue {
    switch (this) {
      case FeedbackStatus.pending:
        return 'PENDING';
      case FeedbackStatus.approved:
        return 'APPROVED';
      case FeedbackStatus.rejected:
        return 'REJECTED';
      case FeedbackStatus.resolved:
        return 'RESOLVED';
    }
  }

  static FeedbackStatus fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'APPROVED':
        return FeedbackStatus.approved;
      case 'RESOLVED':
        return FeedbackStatus.resolved;
      case 'REJECTED':
        return FeedbackStatus.rejected;
      case 'PENDING':
      default:
        return FeedbackStatus.pending;
    }
  }
}

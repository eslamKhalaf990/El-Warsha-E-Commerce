import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Represents a deposit payment receipt or screenshot uploaded by the customer.
class ReceiptAttachment extends Equatable {
  final String fileName;
  final int fileSizeBytes;
  final Uint8List bytes;
  final String? mimeType;

  const ReceiptAttachment({
    required this.fileName,
    required this.fileSizeBytes,
    required this.bytes,
    this.mimeType,
  });

  String get formattedSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [fileName, fileSizeBytes];
}

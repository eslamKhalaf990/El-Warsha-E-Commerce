// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:warsha_commerce/features/checkout/domain/entities/receipt_attachment.dart';

Future<ReceiptAttachment?> pickReceiptFile() {
  final completer = Completer<ReceiptAttachment?>();
  final uploadInput = html.FileUploadInputElement()
    ..accept = 'image/png,image/jpeg,image/jpg,image/webp'
    ..click();

  uploadInput.onChange.listen((event) {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) {
      completer.complete(null);
      return;
    }
    final file = files[0];
    final reader = html.FileReader();
    reader.onLoadEnd.listen((e) {
      final result = reader.result;
      Uint8List? bytes;
      if (result is Uint8List) {
        bytes = result;
      } else if (result is ByteBuffer) {
        bytes = Uint8List.view(result);
      }
      if (bytes != null) {
        completer.complete(
          ReceiptAttachment(
            fileName: file.name,
            fileSizeBytes: file.size,
            bytes: bytes,
            mimeType: file.type,
          ),
        );
      } else {
        completer.complete(null);
      }
    });
    reader.onError.listen((_) => completer.complete(null));
    reader.readAsArrayBuffer(file);
  });

  return completer.future;
}

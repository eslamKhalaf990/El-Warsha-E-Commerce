import 'package:warsha_commerce/features/checkout/domain/entities/receipt_attachment.dart';

import 'package:warsha_commerce/core/utils/receipt_picker/receipt_picker_stub.dart'
    if (dart.library.html) 'package:warsha_commerce/core/utils/receipt_picker/receipt_picker_web.dart'
    as picker;

Future<ReceiptAttachment?> pickReceiptFile() => picker.pickReceiptFile();

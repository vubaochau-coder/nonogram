import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'ad_service.dart';

final _none = NoAdService();

extension AdServiceContext on BuildContext {
  /// Dịch vụ quảng cáo của app; không có (test dựng widget lẻ) thì coi như
  /// không có quảng cáo.
  AdService get ads {
    try {
      return read<AdService>();
    } on ProviderNotFoundException {
      return _none;
    }
  }
}

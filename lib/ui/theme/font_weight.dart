part of 'theme.dart';

enum AppFontWeight {
  thin,
  extraLight,
  light,
  regular,
  medium,
  semiBold,
  bold,
  extraBold,
  black,
}

extension ConvertAppFontWeight on AppFontWeight {
  // ignore: unnecessary_this
  FontWeight convert<AppFontWeight>() => FontWeight.values[this.index];
}

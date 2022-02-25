part of 'theme.dart';

class AppShadows {
  static const easy = BoxShadow(
    color: Color(0x08000000),
    blurRadius: 8,
    offset: Offset(0, 2), // changes position of shadow
  );

  static const medium = BoxShadow(
    color: Color(0x08000000),
    blurRadius: 30,
    offset: Offset(0, 15), // changes position of shadow
  );

  static const dashboard = BoxShadow(
    color: Color(0x10000000),
    blurRadius: 2,
    offset: Offset(0, 2), // changes position of shadow
  );

  static const marker = BoxShadow(
    color: Color(0x25000000),
    blurRadius: 4,
    offset: Offset(0, 4), // changes position of shadow
  );
}

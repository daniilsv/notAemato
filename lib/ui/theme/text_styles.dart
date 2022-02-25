part of 'theme.dart';

class AppStyles extends TextStyle {
  const AppStyles({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.darkText,
    double height = 1.0,
  }) : super(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        );

  static const TextStyle text = AppStyles(height: 1.4);
  static const TextStyle repeatDay = AppStyles(fontWeight: FontWeight.w500);
  static const TextStyle textTile = AppStyles(height: 1.4, fontSize: 16);
  static const TextStyle textTileCaption =
      AppStyles(height: 1.4, fontSize: 13, color: AppColors.lightText);
  static const TextStyle textSemi = AppStyles(height: 1.4, fontWeight: FontWeight.w600);
  static const TextStyle textLabel = AppStyles(fontSize: 15);
  static const TextStyle textSecondary =
      AppStyles(fontSize: 14, color: AppColors.lightText);
  static const TextStyle textCallWhite18 = AppStyles(color: AppColors.whiteText);
  static const TextStyle caption = AppStyles(fontSize: 14, color: AppColors.lightText);
  static const TextStyle light12 = AppStyles(fontSize: 12, color: AppColors.lightText);
  static const TextStyle textError = AppStyles(fontSize: 12, color: AppColors.error);
  static const TextStyle textCheckbox = AppStyles(fontSize: 16, height: 1.4);
  static const TextStyle textLinkCheckbox =
      AppStyles(fontSize: 13, color: AppColors.primary, height: 1.4);
  static const TextStyle captionDarkSemiBold =
      AppStyles(fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle h1 = AppStyles(fontSize: 32, fontWeight: FontWeight.bold);
  static const TextStyle h1White =
      AppStyles(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.whiteText);
  static const TextStyle h1Normal = AppStyles(fontSize: 32);
  static const TextStyle h2 = AppStyles(fontSize: 24, fontWeight: FontWeight.w700);
  static const TextStyle titleCard = AppStyles(fontWeight: FontWeight.w700);
  static const TextStyle secondaryCard = AppStyles(fontSize: 14);
  static const TextStyle whiteTextLabel =
      AppStyles(color: AppColors.whiteText, fontSize: 15, height: 1.3);
  static const TextStyle whiteTextButton =
      AppStyles(color: AppColors.whiteText, fontWeight: FontWeight.w500, fontSize: 15);
  static const TextStyle healthTileTiltle =
      AppStyles(fontWeight: FontWeight.w300, fontSize: 21);
  static const TextStyle healthTileSubtitle =
      AppStyles(color: AppColors.gray80, fontSize: 14);
  static const TextStyle iconButton =
      AppStyles(fontWeight: FontWeight.w500, fontSize: 11);
  static const TextStyle textButton =
      AppStyles(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14);
  static const TextStyle primaryTextButton =
      AppStyles(color: AppColors.primaryText, fontWeight: FontWeight.w500, fontSize: 14);
  static const TextStyle sos = AppStyles(color: AppColors.green, fontSize: 12);
}

import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_header_action.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class ITAppbar extends StatelessWidget {
  const ITAppbar(
      {Key? key,
      this.onPop,
      this.title,
      this.bg,
      this.implyLeading = true,
      this.leadingRight = false,
      this.actions})
      : super(key: key);
  final String? title;
  final Function? onPop;
  final bool implyLeading;
  final bool leadingRight;
  final Color? bg;
  final List<AppHeaderAction>? actions;

  @override
  Widget build(BuildContext context) {
    final hasLeading = implyLeading && Navigator.canPop(context) || onPop != null;
    final toolbarHeight = kToolbarHeight * 1.5;
    return SliverAppBar(
      expandedHeight: toolbarHeight,
      pinned: true,
      elevation: 4,
      automaticallyImplyLeading: false,
      backgroundColor: bg ?? AppColors.bg,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final FlexibleSpaceBarSettings settings =
              context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

          final double deltaExtent = settings.maxExtent - settings.minExtent;

          // 0.0 -> Expanded
          // 1.0 -> Collapsed to toolbar
          final double t =
              (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                  .clamp(0.0, 1.0);

          final double paddingValue = Tween<double>(begin: 14, end: 0).transform(t);
          final double textSizeValue = Tween<double>(begin: 32, end: 20).transform(t);
          final double scaleValue = Tween<double>(begin: 1.5, end: 1.0).transform(t);
          final double leadingTitlePadding =
              Tween<double>(begin: 16, end: 68).transform(t);
          final Matrix4 scaleTransform = Matrix4.identity()..translate(scaleValue);
          final Alignment titleAlignment =
              AlignmentTween(begin: Alignment.topLeft, end: Alignment.center)
                  .transform(t);

          return SafeArea(
            child: Stack(
              children: [
                if (hasLeading)
                  Align(
                    alignment: leadingRight ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: EdgeInsets.only(
                        left: leadingRight ? 0 : 16,
                        right: leadingRight ? 16 : 0,
                        top: 10,
                      ),
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gray10,
                      ),
                      child: Material(
                        child: InkWell(
                          onTap: onPop as void Function()? ?? () => Navigator.pop(context),
                          child: Icon(
                            leadingRight ? Icons.close : Icons.arrow_back_ios_rounded,
                            size: 18,
                            color: AppColors.gray100,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (actions != null)
                  Align(
                      alignment: Alignment.topRight,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end, children: actions!)),
                Padding(
                  padding: EdgeInsets.only(
                    top: paddingValue,
                    left: hasLeading
                        ? leadingRight
                            ? leadingTitlePadding
                            : 68
                        : 16,
                    right: hasLeading
                        ? leadingRight
                            ? 68
                            : leadingTitlePadding
                        : 16,
                  ),
                  child: Transform(
                    alignment: titleAlignment,
                    transform: scaleTransform,
                    child: Container(
                      alignment: titleAlignment,
                      width: constraints.maxWidth / scaleValue,
                      child: Text(
                        title!,
                        style: AppStyles.h2.copyWith(fontSize: textSizeValue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

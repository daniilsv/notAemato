import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';

import 'app_scaffold.dart';
import 'loading_screen.dart';

class SliverAppBarWithMap extends StatefulWidget {
  const SliverAppBarWithMap({
    required this.map,
    required this.body,
    this.onPop,
    this.isBusy,
  });
  final Widget map;
  final Function? onPop;
  final Widget body;
  final bool? isBusy;

  @override
  _SliverAppBarWithMapState createState() => _SliverAppBarWithMapState();
}

class _SliverAppBarWithMapState extends State<SliverAppBarWithMap>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> headerNegativeOffset = ValueNotifier<double>(0);
  final ValueNotifier<double> t = ValueNotifier<double>(0);
  final ValueNotifier<bool> appbarShadow = ValueNotifier<bool>(false);

  final double maxHeaderHeight = kToolbarHeight * 6;
  final double minHeaderHeight = kToolbarHeight;
  final double bodyContentRatioMin = .7;
  final double bodyContentRatioMax = 1.0;
  final double bodyContentRatioParallax = .9;
  late AnimationController _animationController;
  late Animation<Color?> _animationColorBarIcon;
  late Animation<Color?> _animationColorBarButton;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animationColorBarIcon = ColorTween(begin: AppColors.gray10, end: AppColors.gray100)
        .animate(_animationController);
    _animationColorBarButton =
        ColorTween(begin: AppColors.black.withOpacity(0.5), end: AppColors.gray10)
            .animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    headerNegativeOffset.dispose();
    appbarShadow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: <Widget>[
          Stack(children: [
            ValueListenableBuilder<double>(
                valueListenable: headerNegativeOffset,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: Offset(0, offset * -1),
                    child: SizedBox(height: maxHeaderHeight, child: widget.map),
                  );
                }),
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                if (notification.extent == bodyContentRatioMin) {
                  appbarShadow.value = false;
                  headerNegativeOffset.value = 0;
                } else if (notification.extent == bodyContentRatioMax) {
                  appbarShadow.value = true;
                  headerNegativeOffset.value = maxHeaderHeight - minHeaderHeight;
                } else {
                  double newValue = (maxHeaderHeight - minHeaderHeight) -
                      ((maxHeaderHeight - minHeaderHeight) *
                          ((bodyContentRatioParallax - (notification.extent)) /
                              (bodyContentRatioMax - bodyContentRatioParallax)));
                  appbarShadow.value = false;
                  if (newValue >= maxHeaderHeight) {
                    appbarShadow.value = true;
                    newValue = maxHeaderHeight;
                  } else if (newValue < 0) {
                    appbarShadow.value = false;
                    newValue = 0;
                  }
                  headerNegativeOffset.value = newValue;
                }

                return true;
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 36),
                child: DraggableScrollableSheet(
                  initialChildSize: bodyContentRatioMin,
                  minChildSize: bodyContentRatioMin,
                  maxChildSize: bodyContentRatioMax,
                  builder: (BuildContext context, ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: widget.body,
                    );
                  },
                ),
              ),
            )
          ]),
          ValueListenableBuilder<bool>(
              valueListenable: appbarShadow,
              builder: (context, value, child) {
                if (value == true) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                return Positioned(
                  top: 0,
                  right: 0.0,
                  left: 0.0,
                  child: AppBar(
                    leading: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(
                          left: 16,
                          top: 10,
                        ),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _animationColorBarButton.value,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 18,
                              color: _animationColorBarIcon.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    backgroundColor: value && _animationController.isCompleted
                        ? AppColors.bg
                        : Colors.transparent,
                    elevation: _animationController.isCompleted ? 4 : 0,
                  ),
                );
              }),
          if (widget.isBusy!) const Positioned.fill(child: LoadingScreen()),
        ],
      ),
    );
  }
}

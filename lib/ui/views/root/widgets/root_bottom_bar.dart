import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/root/root_viewmodel.dart';
import 'package:notaemato/ui/widgets/keyboard_visibility_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RootBottomBar extends ViewModelWidget<RootViewModel> {
  @override
  Widget build(BuildContext context, RootViewModel model) {
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return AnimatedCrossFade(
          crossFadeState:
              isKeyboardVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 150),
          firstChild: const SizedBox(),
          secondChild: Material(
            color: AppColors.bottomBar,
            child: SafeArea(
              top: false,
              child: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white54),
                  child: Row(
                    children: List.generate(
                      4,
                      (index) => Expanded(
                        child: InkWell(
                          onTap: () => model.navigatorService.changePage(index),
                          child: Column(
                            children: [
                              const SizedBox(height: 9),
                              if (model.navigatorService.indexPage == index)
                                IconTheme(
                                  data: const IconThemeData(color: Colors.white),
                                  child: icon(index, model),
                                )
                              else
                                icon(index, model),
                              const SizedBox(height: 7),
                              Text(text(index)),
                              const SizedBox(height: 7),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget icon(int index, RootViewModel model) {
    switch (index) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        if ((model.messagesCount ?? 0) == 0) return const Icon(Icons.messenger);
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.messenger),
            Positioned(
              top: -7,
              left: 10,
              child: Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 3, bottom: 1, left: 3, right: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.bottomBarBorder, width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red,
                ),
                child: Text(
                  model.messagesCount.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.white, fontSize: 10),
                ),
              ),
            )
          ],
        );
      case 2:
        return const Icon(Icons.notifications);
      case 3:
        return const Icon(Icons.more_horiz_rounded);
      default:
        return const SizedBox();
    }
  }

  String text(int index) {
    switch (index) {
      case 0:
        return 'Дашборд';
      case 1:
        return 'Сообщения';
      case 2:
        return 'События';
      case 3:
        return 'Меню';
      default:
        return '';
    }
  }
}

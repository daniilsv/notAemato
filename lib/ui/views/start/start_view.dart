import 'dart:math';

import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/start/start_view_model.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_button_outlined.dart';
import 'package:notaemato/ui/widgets/support_button.dart';
import 'package:notaemato/ui/widgets/tappable.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ViewModelBuilder<StartViewModel>.reactive(
      viewModelBuilder: () => StartViewModel(),
      builder: (_, model, __) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    if (size.height > 600)
                      SizedBox(height: min(size.height * 0.0665, 43))
                    else
                      SizedBox(height: min(size.height * 0.037, 24)),
                    GestureDetector(
                      onTap: () => model.onImageTap(context),
                      child: Container(
                        width: size.height * 0.295,
                        height: size.height * 0.295,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: min(size.height * 0.037, 24)),
                    SizedBox(
                      height: 38,
                      child: AutoSizeText(
                        Strings.current.title,
                        style: AppStyles.h1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: min(size.height * 0.0247, 16)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: SizedBox(
                        height: 75,
                        child: AutoSizeText(
                          Strings.current.start_screen_hint,
                          style: AppStyles.text,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      AppButton(
                        onPressed: () {
                          model.onRegisterTap(context);
                        },
                        text: Strings.current.create_account,
                      ),
                      const SizedBox(height: 12),
                      AppButtonOutlined(
                        onPressed: () {
                          model.onLoginTap(context);
                        },
                        text: Strings.current.i_have_account,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tappable(
                            onPressed: () {
                              model.onChangeLangTap(context);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.earth,
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: DottedDecoration(dash: const [2, 2]),
                                  child: Text(
                                    Strings.current.lang,
                                    style: AppStyles.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SupportButton(),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

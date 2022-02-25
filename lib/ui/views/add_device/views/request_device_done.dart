import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_button.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestDeviceDoneRoute extends CupertinoPageRoute<String> {
  RequestDeviceDoneRoute() : super(builder: (context) => const _RequestDeviceDone());
}

class _RequestDeviceDone extends StatelessWidget {
  const _RequestDeviceDone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: AppPaddings.h24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.done,
                        color: AppColors.white,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('${Strings.current.done}!', style: AppStyles.h1),
                    const SizedBox(height: 8),
                    Text(
                      Strings.of(context).request_sending,
                      style: const AppStyles().copyWith(height: 1.4),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AppButton(
                    text: Strings.current.okay,
                    onPressed: () => Navigator.of(context)
                      ..popUntil(
                        (route) => route.isFirst,
                      ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

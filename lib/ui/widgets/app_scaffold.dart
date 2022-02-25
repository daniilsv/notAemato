import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_header_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading_screen.dart';
import 'sliver_app_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.onPop,
    this.onWillPop,
    this.bg = AppColors.bg,
    this.implyLeading = true,
    this.leadingRight = false,
    this.isBusy = false,
    this.actions,
  });
  final Widget body;
  final String? title;

  final Function? onPop;
  final Future<bool> Function()? onWillPop; 
  final bool implyLeading;
  final bool leadingRight;
  final Color bg;
  final bool isBusy;
  final List<AppHeaderAction>? actions;

  @override
  Widget build(BuildContext context) {
    

    Widget _body = GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: body,
    );
    if (title?.isNotEmpty ?? false)
      _body = NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            ITAppbar(
                title: title,
                implyLeading: implyLeading,
                onPop: onPop,
                leadingRight: leadingRight,
                bg: bg,
                actions: actions)
          ];
        },
        body: _body,
      );
    final _scaf = Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          _body,
          if (isBusy) const Positioned.fill(child: LoadingScreen()),
        ],
      ),
    );
    if (onWillPop != null) return WillPopScope(onWillPop: onWillPop, child: _scaf);
    return _scaf;
  }
}

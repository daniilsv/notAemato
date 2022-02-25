import 'package:notaemato/data/services/janus.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'call_viewmodel.dart';
import 'screens/incoming.dart';
import 'screens/outgoing.dart';
import 'screens/progress.dart';

class CallView extends StatelessWidget {
  const CallView();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CallViewModel>.reactive(
      viewModelBuilder: () => CallViewModel(context),
      builder: (context, model, child) {
        Widget body = const Center(
          child: CircularProgressIndicator(),
        );
        // Column(
        //   children: [
        //     CallButton(
        //       icon: Icons.call_made,
        //       color: AppColors.accentYellow,
        //       onTap: model.register,
        //     ),
        //     CallButton(
        //       icon: Icons.videocam,
        //       color: AppColors.green,
        //       onTap: model.call,
        //     ),
        //   ],
        // );
        if (model.state == CallingState.incoming) {
          body = const IncomingCallView();
        } else if (model.state == CallingState.outgoing) {
          body = const OutgoingCallView();
        } else if (model.state == CallingState.progress) {
          body = const ProgressCallView();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(platform: TargetPlatform.android),
          home: WillPopScope(
            onWillPop: model.onWillPop,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Scaffold(
                backgroundColor: AppColors.darkText,
                body: SafeArea(child: body),
              ),
            ),
          ),
        );
      },
    );
  }
}

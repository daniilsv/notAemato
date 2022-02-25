import 'package:notaemato/data/model/device.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/views/chat/widgets/alien_text_message.dart';
import 'package:notaemato/ui/views/chat/widgets/self_text_message.dart';
import 'package:notaemato/ui/widgets/app_header_action.dart';
import 'package:notaemato/ui/widgets/back_button.dart';
import 'package:notaemato/ui/widgets/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'chat_viewmodel.dart';
import 'widgets/input_row/input_row_view.dart';

class ChatViewRoute extends MaterialPageRoute {
  ChatViewRoute({DeviceModel? device})
      : super(
          builder: (context) => const _ChatView(),
          settings: RouteSettings(
            arguments: device,
            name: 'chat',
          ),
        );
}

class _ChatView extends StatelessWidget {
  const _ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => ChatViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.bg,
            leading: const AppBackButton(),
            title: Text(
              model.person?.name ?? 'Устройство',
              style: AppStyles.h1Normal,
            ),
            actions: [
              AppHeaderAction(
                onTap: model.onVideoCallTap,
                icon: Icons.videocam,
                topPadding: 0,
              ),
              AppHeaderAction(
                onTap: model.onCallTap,
                icon: Icons.phone,
                topPadding: 0,
              )
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: Navigator.of(context).focusScopeNode.unfocus,
                      child: ListView.builder(
                        controller: model.controller,
                        reverse: true,
                        padding: const EdgeInsets.only(top: 120),
                        itemCount: model.messages.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          final message = model.messages[index];
                          if (!message.inbound!)
                            return SelfTextMessage(message: message);
                          else {
                            return AlienTextMessage(message: message);

                            // if (index - pendingCount + 1 == model.messages.length) return view;
                            // final prevMessage = model.messages[index - pendingCount + 1];
                            // if (prevMessage.created.day != message.created.day &&
                            //     DateTime.now().difference(message.created) < 1.days)
                            //   return Column(children: <Widget>[TimeLabelWidget(time: message.created), view]);

                          }
                        },
                      ),
                    ),
                  ),
                  InputRowView(
                    onSendText: model.send,
                    onSendAudio: model.sendAudio,
                  ),
                  // SafeArea(
                  //   top: false,
                  //   child: DecoratedBox(
                  //     decoration: const BoxDecoration(color: AppColors.gray30),
                  //     child: SizedBox(
                  //       height: 54,
                  //       child: Row(
                  //         children: [
                  //           Expanded(
                  //             child: TextField(
                  //               onSubmitted: model.send,
                  //               controller: model.textEditingController,
                  //               keyboardType: TextInputType.multiline,
                  //               maxLength: 15,
                  //               textInputAction: TextInputAction.newline,
                  //             ),
                  //           ),
                  //           Tappable(
                  //             onPressed: model.sendAudio,
                  //             child: const Icon(
                  //               Icons.mic,
                  //               size: 26,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              if (model.isBusy) const Positioned.fill(child: LoadingScreen()),
            ],
          ),
        );
      },
    );
  }
}

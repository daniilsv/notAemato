import 'package:notaemato/data/model/enum/is_accepted.dart';
import 'package:notaemato/l10n/generated/l10n.dart';
import 'package:notaemato/ui/theme/theme.dart';
import 'package:notaemato/ui/widgets/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/person_tile.dart';
import 'general_access_viewmodel.dart';

class GeneralAccessViewRoute extends CupertinoPageRoute {
  GeneralAccessViewRoute() : super(builder: (context) => GeneralAccessView());
}

class GeneralAccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeneralAccessViewModel>.reactive(
      viewModelBuilder: () => GeneralAccessViewModel(context),
      onModelReady: (model) => model.onReady(),
      builder: (context, model, child) {
        return AppScaffold(
          isBusy: model.isBusy,
          title: Strings.current.general_access,
          body: ListView(
            shrinkWrap: true,
            padding: AppPaddings.h24,
            children: [
              if (model.newUsers.isNotEmpty) ...[
                Text(
                  'Новые запросы',
                  style: AppStyles.textSemi,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: model.newUsers.length,
                  itemBuilder: (context, index) => PersonTile(
                    photoUrl: model.newUsers[index].userPhotoUrl,
                    value: true,
                    title:
                        '${model.newUsers[index].userName} (${model.newUsers[index].roleTitle})',
                    subtitle: model.newUsers[index].email ?? '',
                    persons: model.personsMap[model.newUsers[index].personId]!.name ?? '',
                    onAccept: () => model.onAccept(context, model.newUsers[index]),
                    onReject: () => model.onReject(context, model.newUsers[index]),
                  ),
                ),
                const Divider(
                  height: 32,
                )
              ],
              if (model.trustUsers.isNotEmpty) ...[
                Text(
                  'Доступ предоставлен',
                  style: AppStyles.textSemi,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  padding: const EdgeInsets.only(top: 16),
                  shrinkWrap: true,
                  itemCount: model.trustUsers.length,
                  itemBuilder: (context, index) {
                    final user = model.trustUsers.keys.elementAt(index);
                    return PersonTile(
                      photoUrl: user.photo,
                      value: true,
                      title: user.skytag ?? '',
                      subtitle: user.email ?? '',
                      persons: model.getPersonsName(model.trustUsers[user]),
                      onMenu: () => model.onMenuTap(
                        context: context,
                        requests: model.trustUsers[user]!,
                        isAccepted: IsAccepted.declined,
                      ),
                    );
                  },
                ),
                const Divider(
                  height: 32,
                )
              ],
              if (model.rejectedUsers.isNotEmpty) ...[
                Text(
                  'Отклоненные',
                  style: AppStyles.textSemi,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  padding: const EdgeInsets.only(top: 16),
                  shrinkWrap: true,
                  itemCount: model.rejectedUsers.length,
                  itemBuilder: (context, index) {
                    final user = model.rejectedUsers.keys.elementAt(index);
                    return PersonTile(
                      photoUrl: user.photo,
                      value: true,
                      title: user.skytag ?? '',
                      subtitle: user.email ?? '',
                      persons: model.getPersonsName(model.rejectedUsers[user]),
                      onMenu: () => model.onMenuTap(
                        context: context,
                        requests: model.rejectedUsers[user]!,
                        isAccepted: IsAccepted.active,
                      ),
                    );
                  },
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

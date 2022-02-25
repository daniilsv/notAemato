import 'app_dialog.dart';

void switchError(int? error) {
  switch (error) {
    case 4000:
      showAppDialog(
          title: 'Устройство не на связи, повторите попытку',
          subtitle: 'код для службы поддержки: 4000');
      break;
    case 4001:
      showAppDialog(
          title: 'Команда не отправлена, повторите попытку',
          subtitle: 'код для службы поддержки: 4001');
      break;
    case 4002:
      showAppDialog(
          title: 'Ответ не получен, повторите попытку',
          subtitle: 'код для службы поддержки: 4002');
      break;
    case 9000:
      showAppDialog(
          title: 'Внутренняя ошибка сервера, повторите попытку',
          subtitle: 'код для службы поддержки: 9000');
      break;
    case 9002:
      showAppDialog(
          title: 'Недостаточно прав', subtitle: 'код для службы поддержки: 9002');
      break;
  }
}

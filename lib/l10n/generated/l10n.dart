// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Strings {
  Strings();

  static Strings? _current;

  static Strings get current {
    assert(_current != null,
        'No instance of Strings was loaded. Try to initialize the Strings delegate before accessing Strings.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Strings> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Strings();
      Strings._current = instance;

      return instance;
    });
  }

  static Strings of(BuildContext context) {
    final instance = Strings.maybeOf(context);
    assert(instance != null,
        'No instance of Strings present in the widget tree. Did you add Strings.delegate in localizationsDelegates?');
    return instance!;
  }

  static Strings? maybeOf(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  /// `Ру`
  String get lang {
    return Intl.message(
      'Ру',
      name: 'lang',
      desc: '',
      args: [],
    );
  }

  /// `Русский`
  String get russian {
    return Intl.message(
      'Русский',
      name: 'russian',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `noaemato`
  String get title {
    return Intl.message(
      'noaemato',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Проверьте email`
  String get check_email {
    return Intl.message(
      'Проверьте email',
      name: 'check_email',
      desc: '',
      args: [],
    );
  }

  /// `Пользователь с таким email не зарегистрирован.`
  String get no_user_with_this_email {
    return Intl.message(
      'Пользователь с таким email не зарегистрирован.',
      name: 'no_user_with_this_email',
      desc: '',
      args: [],
    );
  }

  /// `Окей`
  String get okay {
    return Intl.message(
      'Окей',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Ок`
  String get ok {
    return Intl.message(
      'Ок',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось отправить письмо`
  String get couldnt_send_letter {
    return Intl.message(
      'Не удалось отправить письмо',
      name: 'couldnt_send_letter',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось войти`
  String get couldnt_login {
    return Intl.message(
      'Не удалось войти',
      name: 'couldnt_login',
      desc: '',
      args: [],
    );
  }

  /// `Проверьте соединение и повторите.`
  String get check_connection_and_try_again {
    return Intl.message(
      'Проверьте соединение и повторите.',
      name: 'check_connection_and_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Повторить`
  String get retry {
    return Intl.message(
      'Повторить',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Отмена`
  String get cancel {
    return Intl.message(
      'Отмена',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка`
  String get error {
    return Intl.message(
      'Ошибка',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Эл. почта`
  String get e_mail {
    return Intl.message(
      'Эл. почта',
      name: 'e_mail',
      desc: '',
      args: [],
    );
  }

  /// `Пароль`
  String get password {
    return Intl.message(
      'Пароль',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Проверьте правильность ввода.`
  String get check_input {
    return Intl.message(
      'Проверьте правильность ввода.',
      name: 'check_input',
      desc: '',
      args: [],
    );
  }

  /// `Введите эл. почту на которую зарегистрирован ваш аккаунт и получите инструкции по сбросу пароля.`
  String get enter_email_for_restore {
    return Intl.message(
      'Введите эл. почту на которую зарегистрирован ваш аккаунт и получите инструкции по сбросу пароля.',
      name: 'enter_email_for_restore',
      desc: '',
      args: [],
    );
  }

  /// `Восстановить пароль`
  String get restore_password {
    return Intl.message(
      'Восстановить пароль',
      name: 'restore_password',
      desc: '',
      args: [],
    );
  }

  /// `Неправильная пара email и пароль. Попробуйте еще раз.`
  String get wrong_pair_login_password_try_again {
    return Intl.message(
      'Неправильная пара email и пароль. Попробуйте еще раз.',
      name: 'wrong_pair_login_password_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Вход`
  String get sign_in {
    return Intl.message(
      'Вход',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Войти`
  String get to_sign_in {
    return Intl.message(
      'Войти',
      name: 'to_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Забыли пароль`
  String get forgot_password {
    return Intl.message(
      'Забыли пароль',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось зарегистрироваться`
  String get couldnt_register {
    return Intl.message(
      'Не удалось зарегистрироваться',
      name: 'couldnt_register',
      desc: '',
      args: [],
    );
  }

  /// `Email уже используется`
  String get email_in_use {
    return Intl.message(
      'Email уже используется',
      name: 'email_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Войдите, если регистрировались ранее или используйте другой email.`
  String get sign_in_if_registered_before {
    return Intl.message(
      'Войдите, если регистрировались ранее или используйте другой email.',
      name: 'sign_in_if_registered_before',
      desc: '',
      args: [],
    );
  }

  /// `Регистрация через эл. почту`
  String get register_by_email {
    return Intl.message(
      'Регистрация через эл. почту',
      name: 'register_by_email',
      desc: '',
      args: [],
    );
  }

  /// `Я принимаю `
  String get i_agree {
    return Intl.message(
      'Я принимаю ',
      name: 'i_agree',
      desc: '',
      args: [],
    );
  }

  /// `Условия использования`
  String get user_agreement {
    return Intl.message(
      'Условия использования',
      name: 'user_agreement',
      desc: '',
      args: [],
    );
  }

  /// `https://notaemato.tech/external/notaemato-connect/docs/?doc=user_agreement&lang=ru`
  String get user_agreement_url {
    return Intl.message(
      'https://notaemato.tech/external/notaemato-connect/docs/?doc=user_agreement&lang=ru',
      name: 'user_agreement_url',
      desc: '',
      args: [],
    );
  }

  /// ` и даю согласие Notaemato на обработку моей персональной информации на условиях, определенных `
  String get and_grant_agreement_bla_bla_bla {
    return Intl.message(
      ' и даю согласие Notaemato на обработку моей персональной информации на условиях, определенных ',
      name: 'and_grant_agreement_bla_bla_bla',
      desc: '',
      args: [],
    );
  }

  /// `Политикой в отношении персональных данных`
  String get about_privacy_policy {
    return Intl.message(
      'Политикой в отношении персональных данных',
      name: 'about_privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `https://notaemato.tech/external/notaemato-connect/docs/?doc=privacy_policy&lang=ru`
  String get privacy_policy_url {
    return Intl.message(
      'https://notaemato.tech/external/notaemato-connect/docs/?doc=privacy_policy&lang=ru',
      name: 'privacy_policy_url',
      desc: '',
      args: [],
    );
  }

  /// `Создать аккаунт`
  String get create_account {
    return Intl.message(
      'Создать аккаунт',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `У меня уже есть аккаунт`
  String get i_have_account {
    return Intl.message(
      'У меня уже есть аккаунт',
      name: 'i_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Я согласен получать информацию о новостях и акциях Notaemato по эл. почте.`
  String get i_want_to_receive_spam {
    return Intl.message(
      'Я согласен получать информацию о новостях и акциях Notaemato по эл. почте.',
      name: 'i_want_to_receive_spam',
      desc: '',
      args: [],
    );
  }

  /// `Готово`
  String get done {
    return Intl.message(
      'Готово',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Для завершения регистрации следуйте инструкциям в отправленном письме.`
  String get to_finish_register_bla_bla_bla {
    return Intl.message(
      'Для завершения регистрации следуйте инструкциям в отправленном письме.',
      name: 'to_finish_register_bla_bla_bla',
      desc: '',
      args: [],
    );
  }

  /// `Перейти к экрану входа`
  String get to_sign_in_screen {
    return Intl.message(
      'Перейти к экрану входа',
      name: 'to_sign_in_screen',
      desc: '',
      args: [],
    );
  }

  /// `Проверьте почту`
  String get check_mail {
    return Intl.message(
      'Проверьте почту',
      name: 'check_mail',
      desc: '',
      args: [],
    );
  }

  /// `Инструкция для сброса пароля отравлена на {email}`
  String instructions_sent_to(Object email) {
    return Intl.message(
      'Инструкция для сброса пароля отравлена на $email',
      name: 'instructions_sent_to',
      desc: '',
      args: [email],
    );
  }

  /// `Выберите язык приложения`
  String get select_app_lang {
    return Intl.message(
      'Выберите язык приложения',
      name: 'select_app_lang',
      desc: '',
      args: [],
    );
  }

  /// `Выберите сервер`
  String get select_server {
    return Intl.message(
      'Выберите сервер',
      name: 'select_server',
      desc: '',
      args: [],
    );
  }

  /// `Уникальный сервис, который позволит вам быть рядом с близкими и проявлять заботу даже если вы далеко.`
  String get start_screen_hint {
    return Intl.message(
      'Уникальный сервис, который позволит вам быть рядом с близкими и проявлять заботу даже если вы далеко.',
      name: 'start_screen_hint',
      desc: '',
      args: [],
    );
  }

  /// `Служба поддержки`
  String get support_service {
    return Intl.message(
      'Служба поддержки',
      name: 'support_service',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось открыть {what}`
  String couldnt_open(Object what) {
    return Intl.message(
      'Не удалось открыть $what',
      name: 'couldnt_open',
      desc: '',
      args: [what],
    );
  }

  /// `Выберите удобный способ связи`
  String get select_preffered_conn {
    return Intl.message(
      'Выберите удобный способ связи',
      name: 'select_preffered_conn',
      desc: '',
      args: [],
    );
  }

  /// `Написать в {what}`
  String write_to(Object what) {
    return Intl.message(
      'Написать в $what',
      name: 'write_to',
      desc: '',
      args: [what],
    );
  }

  /// `Написать на {what}`
  String write_on(Object what) {
    return Intl.message(
      'Написать на $what',
      name: 'write_on',
      desc: '',
      args: [what],
    );
  }

  /// `почту`
  String get to_mail {
    return Intl.message(
      'почту',
      name: 'to_mail',
      desc: '',
      args: [],
    );
  }

  /// `Выберите вашу роль по отношению к пользователю, который будет носить устройство. Например, «папа», «мама» или «няня».`
  String get add_device_role_description {
    return Intl.message(
      'Выберите вашу роль по отношению к пользователю, который будет носить устройство. Например, «папа», «мама» или «няня».',
      name: 'add_device_role_description',
      desc: '',
      args: [],
    );
  }

  /// `Регистрационный код устройства`
  String get add_device_code_label {
    return Intl.message(
      'Регистрационный код устройства',
      name: 'add_device_code_label',
      desc: '',
      args: [],
    );
  }

  /// `Регистрационный код`
  String get add_device_code_title {
    return Intl.message(
      'Регистрационный код',
      name: 'add_device_code_title',
      desc: '',
      args: [],
    );
  }

  /// `Сканировать QR-код`
  String get scan_qr {
    return Intl.message(
      'Сканировать QR-код',
      name: 'scan_qr',
      desc: '',
      args: [],
    );
  }

  /// `Где найти код?`
  String get where_code {
    return Intl.message(
      'Где найти код?',
      name: 'where_code',
      desc: '',
      args: [],
    );
  }

  /// `Добавить устройство`
  String get add_device_title_line1 {
    return Intl.message(
      'Добавить устройство',
      name: 'add_device_title_line1',
      desc: '',
      args: [],
    );
  }

  /// `Ваша роль`
  String get you_role {
    return Intl.message(
      'Ваша роль',
      name: 'you_role',
      desc: '',
      args: [],
    );
  }

  /// `Продолжить`
  String get continue_button {
    return Intl.message(
      'Продолжить',
      name: 'continue_button',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать роль`
  String get choose_role {
    return Intl.message(
      'Выбрать роль',
      name: 'choose_role',
      desc: '',
      args: [],
    );
  }

  /// `Общий доступ`
  String get general_access {
    return Intl.message(
      'Общий доступ',
      name: 'general_access',
      desc: '',
      args: [],
    );
  }

  /// `Проверьте рег. код`
  String get check_code {
    return Intl.message(
      'Проверьте рег. код',
      name: 'check_code',
      desc: '',
      args: [],
    );
  }

  /// `Мы не нашли код в базе. Проверьте правильность ввода или обратитесь в поддержку.`
  String get no_code_in_base {
    return Intl.message(
      'Мы не нашли код в базе. Проверьте правильность ввода или обратитесь в поддержку.',
      name: 'no_code_in_base',
      desc: '',
      args: [],
    );
  }

  /// `Устройство уже добавлено`
  String get device_alrady_added {
    return Intl.message(
      'Устройство уже добавлено',
      name: 'device_alrady_added',
      desc: '',
      args: [],
    );
  }

  /// `Устройство добавлено другим пользователем. Запросите к нему доступ.`
  String get device_added_another_user {
    return Intl.message(
      'Устройство добавлено другим пользователем. Запросите к нему доступ.',
      name: 'device_added_another_user',
      desc: '',
      args: [],
    );
  }

  /// `Запросить доступ`
  String get request_access {
    return Intl.message(
      'Запросить доступ',
      name: 'request_access',
      desc: '',
      args: [],
    );
  }

  /// `Папа`
  String get father {
    return Intl.message(
      'Папа',
      name: 'father',
      desc: '',
      args: [],
    );
  }

  /// `Мама`
  String get mother {
    return Intl.message(
      'Мама',
      name: 'mother',
      desc: '',
      args: [],
    );
  }

  /// `Дедушка`
  String get grandpa {
    return Intl.message(
      'Дедушка',
      name: 'grandpa',
      desc: '',
      args: [],
    );
  }

  /// `Бабушка`
  String get grandma {
    return Intl.message(
      'Бабушка',
      name: 'grandma',
      desc: '',
      args: [],
    );
  }

  /// `Введите свой вариант`
  String get enter_you_option {
    return Intl.message(
      'Введите свой вариант',
      name: 'enter_you_option',
      desc: '',
      args: [],
    );
  }

  /// `Введите роль`
  String get enter_role {
    return Intl.message(
      'Введите роль',
      name: 'enter_role',
      desc: '',
      args: [],
    );
  }

  /// `Или выберите из готовых`
  String get choose_from_ready {
    return Intl.message(
      'Или выберите из готовых',
      name: 'choose_from_ready',
      desc: '',
      args: [],
    );
  }

  /// `Устройство не добавлено`
  String get device_not_added {
    return Intl.message(
      'Устройство не добавлено',
      name: 'device_not_added',
      desc: '',
      args: [],
    );
  }

  /// `Проверьте интернет-соединение и повторите попытку`
  String get check_you_internet {
    return Intl.message(
      'Проверьте интернет-соединение и повторите попытку',
      name: 'check_you_internet',
      desc: '',
      args: [],
    );
  }

  /// `Запрос отправлен, как только администратор одобрит вашу заявку – вы получите уведомление.`
  String get request_sending {
    return Intl.message(
      'Запрос отправлен, как только администратор одобрит вашу заявку – вы получите уведомление.',
      name: 'request_sending',
      desc: '',
      args: [],
    );
  }

  /// `Ваш аккаунт`
  String get your_account {
    return Intl.message(
      'Ваш аккаунт',
      name: 'your_account',
      desc: '',
      args: [],
    );
  }

  /// `Геозоны`
  String get geozones {
    return Intl.message(
      'Геозоны',
      name: 'geozones',
      desc: '',
      args: [],
    );
  }

  /// `Добавить устройство`
  String get add_device {
    return Intl.message(
      'Добавить устройство',
      name: 'add_device',
      desc: '',
      args: [],
    );
  }

  /// `Настройка уведомлений`
  String get setting_notifications {
    return Intl.message(
      'Настройка уведомлений',
      name: 'setting_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Персоны и устройства`
  String get persons_and_devices {
    return Intl.message(
      'Персоны и устройства',
      name: 'persons_and_devices',
      desc: '',
      args: [],
    );
  }

  /// `Меню`
  String get menu {
    return Intl.message(
      'Меню',
      name: 'menu',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Strings> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

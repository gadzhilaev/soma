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

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Russian`
  String get languageRussian {
    return Intl.message('Russian', name: 'languageRussian', desc: '', args: []);
  }

  /// `English`
  String get languageEnglish {
    return Intl.message('English', name: 'languageEnglish', desc: '', args: []);
  }

  /// `Spanish`
  String get languageSpanish {
    return Intl.message('Spanish', name: 'languageSpanish', desc: '', args: []);
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Enter your email`
  String get emailHint {
    return Intl.message(
      'Enter your email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameLabel {
    return Intl.message('Name', name: 'nameLabel', desc: '', args: []);
  }

  /// `Enter your name`
  String get nameHint {
    return Intl.message(
      'Enter your name',
      name: 'nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get repeatPasswordLabel {
    return Intl.message(
      'Repeat password',
      name: 'repeatPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `I agree with the terms of processing of `
  String get agreePrefix {
    return Intl.message(
      'I agree with the terms of processing of ',
      name: 'agreePrefix',
      desc: '',
      args: [],
    );
  }

  /// `personal data`
  String get personalData {
    return Intl.message(
      'personal data',
      name: 'personalData',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerSubmit {
    return Intl.message('Register', name: 'registerSubmit', desc: '', args: []);
  }

  /// `I already have an account`
  String get haveAccount {
    return Intl.message(
      'I already have an account',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Enter your email address that was specified when registering your account`
  String get restoreLabel {
    return Intl.message(
      'Enter your email address that was specified when registering your account',
      name: 'restoreLabel',
      desc: '',
      args: [],
    );
  }

  /// `Restore password`
  String get restorePass {
    return Intl.message(
      'Restore password',
      name: 'restorePass',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `No active questions`
  String get noActiveQuestions {
    return Intl.message(
      'No active questions',
      name: 'noActiveQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifTitle {
    return Intl.message(
      'Notifications',
      name: 'notifTitle',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to allow the app to send push notifications?`
  String get notifSubtitle {
    return Intl.message(
      'Would you like to allow the app to send push notifications?',
      name: 'notifSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get allow {
    return Intl.message('Allow', name: 'allow', desc: '', args: []);
  }

  /// `No`
  String get noBtn {
    return Intl.message('No', name: 'noBtn', desc: '', args: []);
  }

  /// `Premium account`
  String get premiumTitle {
    return Intl.message(
      'Premium account',
      name: 'premiumTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start your path to harmony now!`
  String get premiumSubtitle {
    return Intl.message(
      'Start your path to harmony now!',
      name: 'premiumSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Exclusive programs`
  String get feature1Title {
    return Intl.message(
      'Exclusive programs',
      name: 'feature1Title',
      desc: '',
      args: [],
    );
  }

  /// `unique techniques for deep relaxation and personal growth`
  String get feature1Desc {
    return Intl.message(
      'unique techniques for deep relaxation and personal growth',
      name: 'feature1Desc',
      desc: '',
      args: [],
    );
  }

  /// `Personalized recommendations`
  String get feature2Title {
    return Intl.message(
      'Personalized recommendations',
      name: 'feature2Title',
      desc: '',
      args: [],
    );
  }

  /// `content tailored to your goals and needs`
  String get feature2Desc {
    return Intl.message(
      'content tailored to your goals and needs',
      name: 'feature2Desc',
      desc: '',
      args: [],
    );
  }

  /// `Habit building`
  String get feature3Title {
    return Intl.message(
      'Habit building',
      name: 'feature3Title',
      desc: '',
      args: [],
    );
  }

  /// `gentle reminders help you stay consistent`
  String get feature3Desc {
    return Intl.message(
      'gentle reminders help you stay consistent',
      name: 'feature3Desc',
      desc: '',
      args: [],
    );
  }

  /// `YEARLY`
  String get yearly {
    return Intl.message('YEARLY', name: 'yearly', desc: '', args: []);
  }

  /// `3,400 ₽`
  String get oldPriceYear {
    return Intl.message('3,400 ₽', name: 'oldPriceYear', desc: '', args: []);
  }

  /// `1,999 ₽`
  String get newPriceYear {
    return Intl.message('1,999 ₽', name: 'newPriceYear', desc: '', args: []);
  }

  /// `MOST POPULAR`
  String get mostPopular {
    return Intl.message(
      'MOST POPULAR',
      name: 'mostPopular',
      desc: '',
      args: [],
    );
  }

  /// `166 ₽ `
  String get perMonthPrice {
    return Intl.message('166 ₽ ', name: 'perMonthPrice', desc: '', args: []);
  }

  /// `per month`
  String get perMonthTail {
    return Intl.message('per month', name: 'perMonthTail', desc: '', args: []);
  }

  /// `MONTHLY`
  String get monthly {
    return Intl.message('MONTHLY', name: 'monthly', desc: '', args: []);
  }

  /// `299 ₽ `
  String get monthlyPrice {
    return Intl.message('299 ₽ ', name: 'monthlyPrice', desc: '', args: []);
  }

  /// `Become premium member`
  String get becomePremium {
    return Intl.message(
      'Become premium member',
      name: 'becomePremium',
      desc: '',
      args: [],
    );
  }

  /// `Continue for free`
  String get continueFree {
    return Intl.message(
      'Continue for free',
      name: 'continueFree',
      desc: '',
      args: [],
    );
  }

  /// `Enter email and password`
  String get errEnterEmailAndPassword {
    return Intl.message(
      'Enter email and password',
      name: 'errEnterEmailAndPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get errFillAllFields {
    return Intl.message(
      'Please fill in all fields',
      name: 'errFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get errPasswordsNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'errPasswordsNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Please accept the data processing agreement`
  String get errAgreeRequired {
    return Intl.message(
      'Please accept the data processing agreement',
      name: 'errAgreeRequired',
      desc: '',
      args: [],
    );
  }

  /// `No active user session`
  String get errNoSession {
    return Intl.message(
      'No active user session',
      name: 'errNoSession',
      desc: '',
      args: [],
    );
  }

  /// `Please select one option`
  String get errSelectOption {
    return Intl.message(
      'Please select one option',
      name: 'errSelectOption',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load questions`
  String get errLoadQuestions {
    return Intl.message(
      'Failed to load questions',
      name: 'errLoadQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load options`
  String get errLoadOptions {
    return Intl.message(
      'Failed to load options',
      name: 'errLoadOptions',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save answer`
  String get errSaveAnswer {
    return Intl.message(
      'Failed to save answer',
      name: 'errSaveAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Error:`
  String get errorPrefix {
    return Intl.message('Error:', name: 'errorPrefix', desc: '', args: []);
  }

  /// `Recommended for you`
  String get homeForYou {
    return Intl.message(
      'Recommended for you',
      name: 'homeForYou',
      desc: '',
      args: [],
    );
  }

  /// `Daily recommendations`
  String get homeDaily {
    return Intl.message(
      'Daily recommendations',
      name: 'homeDaily',
      desc: '',
      args: [],
    );
  }

  /// `Helpful articles`
  String get homeArticles {
    return Intl.message(
      'Helpful articles',
      name: 'homeArticles',
      desc: '',
      args: [],
    );
  }

  /// `More articles`
  String get homeMoreArticles {
    return Intl.message(
      'More articles',
      name: 'homeMoreArticles',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get articleComments {
    return Intl.message(
      'Comments',
      name: 'articleComments',
      desc: '',
      args: [],
    );
  }

  /// `Leave a comment`
  String get articleLeaveComment {
    return Intl.message(
      'Leave a comment',
      name: 'articleLeaveComment',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get minShort {
    return Intl.message('min', name: 'minShort', desc: '', args: []);
  }

  /// `h`
  String get hourShort {
    return Intl.message('h', name: 'hourShort', desc: '', args: []);
  }

  /// `d`
  String get dayShort {
    return Intl.message('d', name: 'dayShort', desc: '', args: []);
  }

  /// `ago`
  String get ago {
    return Intl.message('ago', name: 'ago', desc: '', args: []);
  }

  /// `No comments yet`
  String get commentsEmpty {
    return Intl.message(
      'No comments yet',
      name: 'commentsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Show more`
  String get showMore {
    return Intl.message('Show more', name: 'showMore', desc: '', args: []);
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Attention!`
  String get reportTitle {
    return Intl.message('Attention!', name: 'reportTitle', desc: '', args: []);
  }

  /// `Are you sure you want to report another user's comment?`
  String get reportBody {
    return Intl.message(
      'Are you sure you want to report another user\'s comment?',
      name: 'reportBody',
      desc: '',
      args: [],
    );
  }

  /// `REPORT`
  String get reportSubmit {
    return Intl.message('REPORT', name: 'reportSubmit', desc: '', args: []);
  }

  /// `Thanks! We'll review your report.`
  String get complaintThanks {
    return Intl.message(
      'Thanks! We\'ll review your report.',
      name: 'complaintThanks',
      desc: '',
      args: [],
    );
  }

  /// `Enter a message`
  String get enterMessage {
    return Intl.message(
      'Enter a message',
      name: 'enterMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your message`
  String get yourMessage {
    return Intl.message(
      'Your message',
      name: 'yourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Comment sent`
  String get commentSent {
    return Intl.message(
      'Comment sent',
      name: 'commentSent',
      desc: '',
      args: [],
    );
  }

  /// `Attention!`
  String get validationTitle {
    return Intl.message(
      'Attention!',
      name: 'validationTitle',
      desc: '',
      args: [],
    );
  }

  /// `The message cannot be empty or contain fewer than 12 characters.`
  String get validationBodyTooShort {
    return Intl.message(
      'The message cannot be empty or contain fewer than 12 characters.',
      name: 'validationBodyTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get listen {
    return Intl.message('Listen', name: 'listen', desc: '', args: []);
  }

  /// `LISTEN`
  String get listenUpper {
    return Intl.message('LISTEN', name: 'listenUpper', desc: '', args: []);
  }

  /// `Step {n}`
  String stepN(int n) {
    return Intl.message('Step $n', name: 'stepN', desc: '', args: [n]);
  }

  /// `For sleep`
  String get musicForSleep {
    return Intl.message('For sleep', name: 'musicForSleep', desc: '', args: []);
  }

  /// `For inspiration`
  String get musicForInspiration {
    return Intl.message(
      'For inspiration',
      name: 'musicForInspiration',
      desc: '',
      args: [],
    );
  }

  /// `For relaxation`
  String get musicForRelaxation {
    return Intl.message(
      'For relaxation',
      name: 'musicForRelaxation',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get profileSubscribe {
    return Intl.message(
      'Subscribe',
      name: 'profileSubscribe',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get profileNotifications {
    return Intl.message(
      'Notifications',
      name: 'profileNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get profileFavorites {
    return Intl.message(
      'Favorites',
      name: 'profileFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get profileEdit {
    return Intl.message(
      'Edit profile',
      name: 'profileEdit',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get profileLanguage {
    return Intl.message(
      'Change language',
      name: 'profileLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Terms of service`
  String get profileTerms {
    return Intl.message(
      'Terms of service',
      name: 'profileTerms',
      desc: '',
      args: [],
    );
  }

  /// `Contact support`
  String get profileSupport {
    return Intl.message(
      'Contact support',
      name: 'profileSupport',
      desc: '',
      args: [],
    );
  }

  /// `Admin panel`
  String get profileAdmin {
    return Intl.message(
      'Admin panel',
      name: 'profileAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get profileLogout {
    return Intl.message('Logout', name: 'profileLogout', desc: '', args: []);
  }

  /// `Are you sure you want to sign out of your account? You can simply close the app`
  String get logoutConfirmBody {
    return Intl.message(
      'Are you sure you want to sign out of your account? You can simply close the app',
      name: 'logoutConfirmBody',
      desc: '',
      args: [],
    );
  }

  /// `Login successful`
  String get loginSuccessTitle {
    return Intl.message(
      'Login successful',
      name: 'loginSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully logged into your account`
  String get loginSuccessBody {
    return Intl.message(
      'You have successfully logged into your account',
      name: 'loginSuccessBody',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful`
  String get registerSuccessTitle {
    return Intl.message(
      'Registration successful',
      name: 'registerSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully registered`
  String get registerSuccessBody {
    return Intl.message(
      'You have successfully registered',
      name: 'registerSuccessBody',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Enter your new name`
  String get enterNewName {
    return Intl.message(
      'Enter your new name',
      name: 'enterNewName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new email`
  String get enterNewEmail {
    return Intl.message(
      'Enter your new email',
      name: 'enterNewEmail',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get oldPassword {
    return Intl.message(
      'Old password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message(
      'Delete account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to change your name in the app?`
  String get confirmChangeNameBody {
    return Intl.message(
      'Are you sure you want to change your name in the app?',
      name: 'confirmChangeNameBody',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to change your email?`
  String get confirmChangeEmailBody {
    return Intl.message(
      'Are you sure you want to change your email?',
      name: 'confirmChangeEmailBody',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? All your account data will be lost`
  String get confirmDeleteAccountBody {
    return Intl.message(
      'Are you sure you want to delete your account? All your account data will be lost',
      name: 'confirmDeleteAccountBody',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `You have no new notifications`
  String get notificationsEmpty {
    return Intl.message(
      'You have no new notifications',
      name: 'notificationsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get notificationsAction {
    return Intl.message(
      'Open',
      name: 'notificationsAction',
      desc: '',
      args: [],
    );
  }

  /// `New program!`
  String get notificationsSampleTitle {
    return Intl.message(
      'New program!',
      name: 'notificationsSampleTitle',
      desc: '',
      args: [],
    );
  }

  /// `🌿 Dive into the Mindfulness Path!\nMake time for yourself—start a meditation practice to gain clarity, maximum focus, and deep awareness.`
  String get notificationsSampleDescription {
    return Intl.message(
      '🌿 Dive into the Mindfulness Path!\nMake time for yourself—start a meditation practice to gain clarity, maximum focus, and deep awareness.',
      name: 'notificationsSampleDescription',
      desc: '',
      args: [],
    );
  }

  /// `Go to program`
  String get notificationsSampleAction {
    return Intl.message(
      'Go to program',
      name: 'notificationsSampleAction',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
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

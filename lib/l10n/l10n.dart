import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_es.dart';
import 'l10n_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ru'),
  ];

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameHint;

  /// No description provided for @repeatPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPasswordLabel;

  /// No description provided for @agreePrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree with the terms of processing of '**
  String get agreePrefix;

  /// No description provided for @personalData.
  ///
  /// In en, this message translates to:
  /// **'personal data'**
  String get personalData;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerSubmit;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get haveAccount;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @restoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address that was specified when registering your account'**
  String get restoreLabel;

  /// No description provided for @restorePass.
  ///
  /// In en, this message translates to:
  /// **'Restore password'**
  String get restorePass;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noActiveQuestions.
  ///
  /// In en, this message translates to:
  /// **'No active questions'**
  String get noActiveQuestions;

  /// No description provided for @notifTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifTitle;

  /// No description provided for @notifSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Would you like to allow the app to send push notifications?'**
  String get notifSubtitle;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @noBtn.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noBtn;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium account'**
  String get premiumTitle;

  /// No description provided for @premiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your path to harmony now!'**
  String get premiumSubtitle;

  /// No description provided for @feature1Title.
  ///
  /// In en, this message translates to:
  /// **'Exclusive programs'**
  String get feature1Title;

  /// No description provided for @feature1Desc.
  ///
  /// In en, this message translates to:
  /// **'unique techniques for deep relaxation and personal growth'**
  String get feature1Desc;

  /// No description provided for @feature2Title.
  ///
  /// In en, this message translates to:
  /// **'Personalized recommendations'**
  String get feature2Title;

  /// No description provided for @feature2Desc.
  ///
  /// In en, this message translates to:
  /// **'content tailored to your goals and needs'**
  String get feature2Desc;

  /// No description provided for @feature3Title.
  ///
  /// In en, this message translates to:
  /// **'Habit building'**
  String get feature3Title;

  /// No description provided for @feature3Desc.
  ///
  /// In en, this message translates to:
  /// **'gentle reminders help you stay consistent'**
  String get feature3Desc;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'YEARLY'**
  String get yearly;

  /// No description provided for @oldPriceYear.
  ///
  /// In en, this message translates to:
  /// **'3,400 ₽'**
  String get oldPriceYear;

  /// No description provided for @newPriceYear.
  ///
  /// In en, this message translates to:
  /// **'1,999 ₽'**
  String get newPriceYear;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'MOST POPULAR'**
  String get mostPopular;

  /// No description provided for @perMonthPrice.
  ///
  /// In en, this message translates to:
  /// **'166 ₽ '**
  String get perMonthPrice;

  /// No description provided for @perMonthTail.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonthTail;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY'**
  String get monthly;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'299 ₽ '**
  String get monthlyPrice;

  /// No description provided for @becomePremium.
  ///
  /// In en, this message translates to:
  /// **'Become premium member'**
  String get becomePremium;

  /// No description provided for @continueFree.
  ///
  /// In en, this message translates to:
  /// **'Continue for free'**
  String get continueFree;

  /// No description provided for @errEnterEmailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter email and password'**
  String get errEnterEmailAndPassword;

  /// No description provided for @errFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get errFillAllFields;

  /// No description provided for @errPasswordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errPasswordsNotMatch;

  /// No description provided for @errAgreeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the data processing agreement'**
  String get errAgreeRequired;

  /// No description provided for @errNoSession.
  ///
  /// In en, this message translates to:
  /// **'No active user session'**
  String get errNoSession;

  /// No description provided for @errSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Please select one option'**
  String get errSelectOption;

  /// No description provided for @errLoadQuestions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questions'**
  String get errLoadQuestions;

  /// No description provided for @errLoadOptions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load options'**
  String get errLoadOptions;

  /// No description provided for @errSaveAnswer.
  ///
  /// In en, this message translates to:
  /// **'Failed to save answer'**
  String get errSaveAnswer;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @homeForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get homeForYou;

  /// No description provided for @homeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily recommendations'**
  String get homeDaily;

  /// No description provided for @homeArticles.
  ///
  /// In en, this message translates to:
  /// **'Helpful articles'**
  String get homeArticles;

  /// No description provided for @homeMoreArticles.
  ///
  /// In en, this message translates to:
  /// **'More articles'**
  String get homeMoreArticles;

  /// No description provided for @articleComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get articleComments;

  /// No description provided for @articleLeaveComment.
  ///
  /// In en, this message translates to:
  /// **'Leave a comment'**
  String get articleLeaveComment;

  /// No description provided for @minShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minShort;

  /// No description provided for @hourShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hourShort;

  /// No description provided for @dayShort.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get dayShort;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @commentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get commentsEmpty;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Attention!'**
  String get reportTitle;

  /// No description provided for @reportBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to report another user\'s comment?'**
  String get reportBody;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'REPORT'**
  String get reportSubmit;

  /// No description provided for @complaintThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks! We\'ll review your report.'**
  String get complaintThanks;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a message'**
  String get enterMessage;

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @commentSent.
  ///
  /// In en, this message translates to:
  /// **'Comment sent'**
  String get commentSent;

  /// No description provided for @validationTitle.
  ///
  /// In en, this message translates to:
  /// **'Attention!'**
  String get validationTitle;

  /// No description provided for @validationBodyTooShort.
  ///
  /// In en, this message translates to:
  /// **'The message cannot be empty or contain fewer than 12 characters.'**
  String get validationBodyTooShort;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @listenUpper.
  ///
  /// In en, this message translates to:
  /// **'LISTEN'**
  String get listenUpper;

  /// No description provided for @stepN.
  ///
  /// In en, this message translates to:
  /// **'Step {n}'**
  String stepN(int n);

  /// No description provided for @musicForSleep.
  ///
  /// In en, this message translates to:
  /// **'For sleep'**
  String get musicForSleep;

  /// No description provided for @musicForInspiration.
  ///
  /// In en, this message translates to:
  /// **'For inspiration'**
  String get musicForInspiration;

  /// No description provided for @musicForRelaxation.
  ///
  /// In en, this message translates to:
  /// **'For relaxation'**
  String get musicForRelaxation;

  /// No description provided for @profileSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get profileSubscribe;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get profileFavorites;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get profileLanguage;

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get profileTerms;

  /// No description provided for @profileSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get profileSupport;

  /// No description provided for @profileAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin panel'**
  String get profileAdmin;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of your account? You can simply close the app'**
  String get logoutConfirmBody;

  /// No description provided for @loginSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessTitle;

  /// No description provided for @loginSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'You have successfully logged into your account'**
  String get loginSuccessBody;

  /// No description provided for @registerSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccessTitle;

  /// No description provided for @registerSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'You have successfully registered'**
  String get registerSuccessBody;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @enterNewName.
  ///
  /// In en, this message translates to:
  /// **'Enter your new name'**
  String get enterNewName;

  /// No description provided for @enterNewEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your new email'**
  String get enterNewEmail;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @confirmChangeNameBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change your name in the app?'**
  String get confirmChangeNameBody;

  /// No description provided for @confirmChangeEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change your email?'**
  String get confirmChangeEmailBody;

  /// No description provided for @confirmDeleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? All your account data will be lost'**
  String get confirmDeleteAccountBody;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no new notifications'**
  String get notificationsEmpty;

  /// No description provided for @notificationsAction.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get notificationsAction;

  /// No description provided for @notificationsSampleTitle.
  ///
  /// In en, this message translates to:
  /// **'New program!'**
  String get notificationsSampleTitle;

  /// No description provided for @notificationsSampleDescription.
  ///
  /// In en, this message translates to:
  /// **'🌿 Dive into the Mindfulness Path!\nMake time for yourself—start a meditation practice to gain clarity, maximum focus, and deep awareness.'**
  String get notificationsSampleDescription;

  /// No description provided for @notificationsSampleAction.
  ///
  /// In en, this message translates to:
  /// **'Go to program'**
  String get notificationsSampleAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

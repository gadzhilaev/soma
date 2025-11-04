// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get ok => 'Хорошо';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageSpanish => 'Испанский';

  @override
  String get emailLabel => 'Электронная почта';

  @override
  String get emailHint => 'Введите почту';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordHint => 'Введите пароль';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get nameLabel => 'Имя';

  @override
  String get nameHint => 'Введите Имя';

  @override
  String get repeatPasswordLabel => 'Повторите пароль';

  @override
  String get agreePrefix => 'Я согласен(-на) с условиями обработки ';

  @override
  String get personalData => 'персональных данных';

  @override
  String get registerSubmit => 'Зарегистрироваться';

  @override
  String get haveAccount => 'У меня уже есть аккаунт';

  @override
  String get cancel => 'Отменить';

  @override
  String get restoreLabel =>
      'Введите вашу электронную почту, которую указывали при регистрации вашего аккаунта';

  @override
  String get restorePass => 'Восстановить пароль';

  @override
  String get next => 'Далее';

  @override
  String get noActiveQuestions => 'Нет активных вопросов';

  @override
  String get notifTitle => 'Уведомления';

  @override
  String get notifSubtitle =>
      'Хотите ли вы разрешить приложению присылать всплывающие уведомления?';

  @override
  String get allow => 'Разрешить';

  @override
  String get noBtn => 'Нет';

  @override
  String get premiumTitle => 'Премиум аккаунт';

  @override
  String get premiumSubtitle => 'Начните путь к гармонии прямо сейчас!';

  @override
  String get feature1Title => 'Эксклюзивные программы';

  @override
  String get feature1Desc =>
      'уникальные техники для глубокого расслабления и личного роста';

  @override
  String get feature2Title => 'Персональные рекомендации';

  @override
  String get feature2Desc =>
      'контент, подобранный специально для ваших целей и задач';

  @override
  String get feature3Title => 'Развитие привычки';

  @override
  String get feature3Desc =>
      'заботливые уведомления помогут вам поддерживать регулярность';

  @override
  String get yearly => 'ГОДОВОЙ';

  @override
  String get oldPriceYear => '3 400 ₽';

  @override
  String get newPriceYear => '1 999 ₽';

  @override
  String get mostPopular => 'САМЫЙ ПОПУЛЯРНЫЙ';

  @override
  String get perMonthPrice => '166 ₽ ';

  @override
  String get perMonthTail => 'в месяц';

  @override
  String get monthly => 'ЕЖЕМЕСЯЧНЫЙ';

  @override
  String get monthlyPrice => '299 ₽ ';

  @override
  String get becomePremium => 'Стать премиум участником';

  @override
  String get continueFree => 'Продолжить бесплатно';

  @override
  String get errEnterEmailAndPassword => 'Введите почту и пароль';

  @override
  String get errFillAllFields => 'Заполните все поля';

  @override
  String get errPasswordsNotMatch => 'Пароли не совпадают';

  @override
  String get errAgreeRequired => 'Подтвердите согласие на обработку данных';

  @override
  String get errNoSession => 'Нет активной сессии пользователя';

  @override
  String get errSelectOption => 'Выберите один из вариантов';

  @override
  String get errLoadQuestions => 'Ошибка загрузки вопросов';

  @override
  String get errLoadOptions => 'Ошибка загрузки вариантов';

  @override
  String get errSaveAnswer => 'Не удалось сохранить ответ';

  @override
  String get errorPrefix => 'Ошибка:';

  @override
  String get homeForYou => 'Рекомендации для вас';

  @override
  String get homeDaily => 'Ежедневные рекомендации';

  @override
  String get homeArticles => 'Полезные статьи';

  @override
  String get homeMoreArticles => 'Больше статей';

  @override
  String get articleComments => 'Комментарии';

  @override
  String get articleLeaveComment => 'Оставить комментарий';

  @override
  String get minShort => 'мин';

  @override
  String get hourShort => 'ч';

  @override
  String get dayShort => 'дн';

  @override
  String get ago => 'назад';

  @override
  String get commentsEmpty => 'Комментарии отсутствуют';

  @override
  String get showMore => 'Показать ещё';

  @override
  String get report => 'Пожаловаться';

  @override
  String get reportTitle => 'Внимание!';

  @override
  String get reportBody =>
      'Вы уверены, что хотите пожаловаться на комментарий другого пользователя?';

  @override
  String get reportSubmit => 'ПОЖАЛОВАТЬСЯ';

  @override
  String get complaintThanks => 'Спасибо! Мы рассмотрим жалобу.';

  @override
  String get enterMessage => 'Введите сообщение';

  @override
  String get yourMessage => 'Ваше сообщение';

  @override
  String get send => 'Отправить';

  @override
  String get commentSent => 'Комментарий отправлен';

  @override
  String get validationTitle => 'Внимание!';

  @override
  String get validationBodyTooShort =>
      'Сообщение не может быть пустым или содержать менее 12 символов в своем теле';

  @override
  String get listen => 'Слушать';

  @override
  String get listenUpper => 'СЛУШАТЬ';

  @override
  String stepN(int n) {
    return 'Шаг $n';
  }

  @override
  String get musicForSleep => 'Для сна';

  @override
  String get musicForInspiration => 'Для вдохновения';

  @override
  String get musicForRelaxation => 'Для расслабления';

  @override
  String get profileSubscribe => 'Оформить подписку';

  @override
  String get profileNotifications => 'Уведомления';

  @override
  String get profileFavorites => 'Избранное';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get profileLanguage => 'Смена языка';

  @override
  String get profileTerms => 'Пользовательское соглашение';

  @override
  String get profileSupport => 'Написать в поддержку';

  @override
  String get profileAdmin => 'Админ панель';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get logoutConfirmBody =>
      'Вы уверены, что хотите выйти из вашего аккаунта? Вы можете просто закрыть приложение';
}

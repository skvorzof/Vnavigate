# Vnavigate

Приложение для социальной сети – дипломная работа в рамках обучения "Нетологии", курс iOS разработчик. 

Цель проекта – научиться использовать основные технологии реализации приложений для iOS, iPad.

### Функционал приложения

При первом запуске приложения пользователь попадает на экран выбора авторизации Зарегистрироться/Войти. (Тестовый аккаунт: телефон +79000000000, sms код 000000)

После авторизации открывается главный экран, на котором вверху располагаются аватары друзей, и все статьи в хронологическом порядке.

При тапе на аватар выполняется переход на экран со всеми фотографиями и статьями этого пользователя и возможностью добавить/удалить его из друзей.

Экран Профиль отображает ваши фотографии, посты и кнопку выхода из аккаунта.

Экран Избранное отображает все статьи которые вы отмечаете как избранное.

### Реализация

- UIKit
- MVVM
- Dependency injection
- Coordinator
- CoreData
- UserDefaults
- Generics
- Optional
- Decoding
- Type-casting
- AutoLayout
- Delegate
- Closures
- UICollectionViewDiffableDataSource, NSDiffableDataSourceSnapshot, NSCollectionLayoutEnvironment
- JSON Parse
- SPM
- Firebase SDK

### Экраны

|               Авторизация               |          Главный экран / профиль          |                   Избранное                   |
| :-------------------------------------: | :---------------------------------------: | :-------------------------------------------: |
| ![Авторизация](https://github.com/skvorzof/Vnavigate/blob/main/READMEAssets/start.gif?raw=true)| ![Главный экран / профиль](https://github.com/skvorzof/Vnavigate/blob/main/READMEAssets/friend.gif?raw=true) | ![Избранное](https://github.com/skvorzof/Vnavigate/blob/main/READMEAssets/favorite.gif?raw=true) |

### Требования

- iOS 16.2+
- Xcode 14.2+
- Swift 5.7.2+


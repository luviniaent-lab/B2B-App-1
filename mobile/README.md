# EventXchange B2B (Flutter Mobile)

This is a Flutter starter for the existing web app, targeting Android and iOS.
It includes:
- Properties list with horizontal media scroller
- Property details with Agent section and associated Events/Offers
- Events and Offers lists (linked to properties)
- Riverpod for state management; GoRouter for navigation

## Prerequisites
- Flutter SDK set up for Android/iOS
- Android Studio or Xcode configured

## Getting started

1) Create a Flutter project in this folder

```
cd mobile
flutter create .
```

2) Replace dependencies in pubspec.yaml (see below), then install

```
flutter pub get
```

3) Run the app

```
flutter run -d <device_id>
```

> Find device IDs with: `flutter devices`

## pubspec.yaml (dependencies)

Add these under `dependencies:`

```
flutter_riverpod: ^2.5.1
go_router: ^14.2.7
hive: ^2.2.3
hive_flutter: ^1.1.0
path_provider: ^2.1.3
http: ^1.2.2
image_picker: ^1.1.2
video_player: ^2.9.1
intl: ^0.19.0
```

Under `dev_dependencies:` add (optional for Hive code gen later):

```
build_runner: ^2.4.11
hive_generator: ^2.0.1
```

## Files to copy
Copy the files in `lib/` provided in this folder into your project `lib/`.

- lib/main.dart
- lib/app_router.dart
- lib/data/app_state.dart
- lib/models/property.dart
- lib/models/event.dart
- lib/models/offer.dart
- lib/pages/properties_page.dart
- lib/pages/property_details_page.dart
- lib/pages/events_page.dart
- lib/pages/offers_page.dart
- lib/widgets/media_scroller.dart

## Notes
- This starter uses in-memory state to get you going. Swap to Hive persistence when ready.
- Image generation (OpenRouter) is deferred; you can integrate later behind a secure backend.
- UI is Material 3; feel free to customize theming and widgets.


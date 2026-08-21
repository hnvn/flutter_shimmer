# Shimmer example

Demo app for the [`shimmer`](https://pub.dev/packages/shimmer) package.

## Screens

- **Loading List** — one `Shimmer.fromColors` wrapping a column of skeleton
  placeholders (`BannerPlaceholder`, `TitlePlaceholder`, `ContentPlaceholder`).
- **Slide To Unlock** — a highlight passing over a call-to-action row.

## Run

From this directory:

```bash
flutter pub get
flutter run
```

The demo imports Material from `package:material_ui/material_ui.dart` (Flutter
3.44+). The app depends on the package via a path dependency in `pubspec.yaml`:

```yaml
shimmer:
  path: ..
```

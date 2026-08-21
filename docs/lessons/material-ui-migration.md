# Lessons: material_ui migration

## Add the package before trusting dart fix pubspec edits

`dart fix --apply --code=migrate_design_widgets` rewrites imports correctly, but
it may add `material_ui: any` to `example/pubspec.yaml`. Replace that with a
semver range (`^1.0.1`) after `flutter pub add material_ui`.

## Import order

The fix inserts `package:material_ui/material_ui.dart` where
`package:flutter/material.dart` was. Re-sort so `package:flutter/...` imports
stay together above `material_ui` (`directives_ordering`).

## Package major version

Treat the move off SDK Material as a breaking release. Consumers on Flutter
older than 3.44 cannot resolve `material_ui` 1.x.

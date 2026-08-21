# Optimization notes

Changes already applied in this pass are listed first. Items below that are
suggestions: they improve the package but change behavior, pub constraints, or
the public API enough to confirm before shipping.

## Applied

- Start infinite loops with `AnimationController.repeat()` instead of one
  `forward()` cycle then `repeat()`.
- Update `controller.duration` when `period` changes.
- Restart cleanly when `enabled` goes from `false` to `true`, including after
  a finite `loop` has finished.
- `direction` calls `markNeedsPaint()` rather than `markNeedsLayout()`.
- Extract `shimmerHighlightRect` so highlight travel can be unit-tested.
- Remove leftover `lib/main.dart` (default Flutter counter, not part of the
  package API).

## Rendering

1. **One shimmer per screen, not per row.** The example already does this.
   Document it in app code reviews: each `Shimmer` owns a ticker and a
   compositing layer.
2. **Optional `RepaintBoundary` around `Shimmer`.** Isolates the shader
   animation from ancestors. Apps can wrap it; adding it inside the package
   can surprise layout that relies on parent layer merging.
3. **Reuse the `Shader` when only `percent` is unchanged.** Today
   `createShader` runs every paint, which is required because the rect moves.
   If `percent` and `size` are unchanged, skip shader creation (the existing
   setters already avoid extra paints).
4. **Avoid `saveLayer` elsewhere in the child.** `BlendMode.srcIn` already
   composites; extra opacity/save layers on the child increase GPU cost.

## Animation

5. **`loop == 1` vs `loop == 0`.** Finite loops still use `forward` plus a
   status listener. That is correct; do not switch finite loops to `repeat`
   with a counter unless you also handle `enabled` mid-cycle.
6. **Reset `_count` when `loop` shrinks** while the widget is still mounted
   and enabled. Current code only restarts when the controller is idle.
7. **Honor `Duration.zero` / negative `loop`.** Guard with asserts so bad
   values fail in debug instead of hanging a ticker.

## API (confirm before adding)

8. **Theme-aware defaults.** A `Shimmer.theme(context)` helper that reads
   `ColorScheme` would reduce boilerplate for skeleton screens, but it is a
   new constructor.
9. **`Semantics` / accessibility.** Announce “Loading” while `enabled` is
   true. Must be opt-in so existing trees do not get duplicate semantics.
10. **`fromColors` diagonal gradient.** `begin: topLeft` and
    `end: centerRight` is slightly diagonal. A true horizontal band would
    use `Alignment.centerLeft` → `Alignment.centerRight`. Changing it would
    visually break apps that depend on the current slant.

## Project hygiene

11. **CI** still used `actions/checkout@v1`, Java 12, and the Flutter beta
    channel. Unit tests for this package do not need Android toolchains.
12. **`analysis_options.yaml`** is a dated Flutter-repo snapshot. Rules such
    as `iterable_contains_unrelated_type` were removed from the linter.
    Prefer `package:flutter_lints` once you are ready to fix new findings.
13. **`example` pubspec** is still named `new_example` with a default
    description. Rename for pub.dev example scoring if you republish.
14. **LICENSE** text is the Dart project BSD header (Google Inc., 2013), not
    a project-specific copyright. Confirm with the maintainer before editing.
15. **Minimum Flutter SDK** is `>=1.9.1`, which is far below what current
    `super.key` / Material 3 examples need. Raising it documents reality and
    unlocks newer Dart syntax.

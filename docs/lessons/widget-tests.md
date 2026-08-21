# Lessons

## Widget tests need Directionality for Text

Pumping `Text` (or any `RichText`) under `Shimmer` alone fails with
`No Directionality widget found`. Wrap the widget under test in
`Directionality` (or `MaterialApp`) inside the test helper, even when
the production widget does not require it.

## Do not assert animation completion at exactly `period`

`AnimationController` may still be running after `pump(period)` because
the ticker starts on a later frame. For finite `loop` tests, use
`pumpAndSettle()`. To prove `period` updates without restarting, lengthen
the duration near the end of a cycle and assert it finishes in the
remaining fraction of the **new** duration.

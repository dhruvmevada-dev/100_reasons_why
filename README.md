# 100 Reasons 💕

A minimal, cozy Flutter web app: 100 swipeable cards, each with a reason.
Card #100 gets special styling for the finale.

## Run it

```bash
flutter pub get
flutter run -d chrome
```

## Build for the web (to host anywhere)

```bash
flutter build web
```
The output lands in `build/web` — upload that folder to any static host
(GitHub Pages, Netlify, Vercel, Firebase Hosting, etc).

## Edit the reasons

Everything lives in `assets/data/reasons.json`. Just edit the `text` field
for any `number`, add more objects, or change `title` / `subtitle`. No code
changes needed. Card `100` has an extra `"special": true` flag that gives it
the deeper-colored finale look — add that flag to any card you want styled
that way.

```json
{ "number": 7, "text": "Because you somehow manage to make boring days fun." }
```

## Structure

```
lib/
  main.dart                 – app entry point
  theme/app_theme.dart      – the 60-30-10 color palette + ThemeData
  models/reason.dart        – JSON → Reason model
  screens/home_screen.dart  – PageView, animations, progress bar, nav
  widgets/reason_card.dart  – the card UI itself
assets/data/reasons.json    – all 100 reasons (edit this freely)
```

## Interactions

- Swipe / drag on touch devices
- Left/right chevron buttons for mouse users
- Left/Right arrow keys on desktop/web
- "Start over" button appears on the last card

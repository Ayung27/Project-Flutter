# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`food_app` — a Flutter food-ordering app with an Indonesian-language UI (browse menu, cart, checkout, order history, address book, profile). Targets Flutter SDK `>=3.1.0`. Firebase project: `food-cdb6b`.

## Commands

```bash
flutter pub get                       # install dependencies
flutter run                           # run on a connected device/emulator
flutter analyze                       # lint (rules: package:flutter_lints/flutter.yaml)
flutter test                          # run all tests
flutter test test/widget_test.dart    # run a single test file
flutter test --plain-name "name"      # run a single test by name
flutter build apk                     # release Android build

dart run flutter_launcher_icons       # regenerate app launcher icons after changing assets/images/app_icon.png
dart run flutter_native_splash:create # regenerate the native splash screen
```

## Architecture

**State management is Provider; app data persists locally via `shared_preferences`.** `main.dart` awaits `SharedPreferences.getInstance()`, wraps it in `StorageService`, then registers two `ChangeNotifier`s via `MultiProvider`, each created with `(storage: storage)..load()` so data is restored synchronously at startup:

- `providers/cart_providers.dart` (`CartProvider`) — holds the cart (`List<CartItem>`), order history (`List<Order>`), and the applied `Voucher?`. `addOrder()` snapshots the cart into history, clears it, and clears the voucher. Every mutator persists. Cart items are typed models (`models/product.dart`, `models/cart_item.dart`) with **price as `int`**; `totalBayar` sums `CartItem.subtotal`; `discount` = `appliedVoucher?.discountFor(totalBayar)`. `Product.available == false` renders as "Habis" (badge + disabled add) in `home_screen.dart`. Vouchers are a hardcoded list (`models/voucher.dart`, `kAvailableVouchers`, percent/fixed), applied at checkout via `applyVoucher(code)`.
- `providers/alamat_provider.dart` (`AlamatProvider`) — saved-address list (`List<Alamat>`), seeded with two defaults only on first run (uses `StorageService.containsKey` to tell "never saved" from "saved empty").

**Persistence layer:** `services/storage_service.dart` (`StorageService`) is a thin wrapper over `SharedPreferences` that reads/writes JSON lists by key (`cart`, `orders`, `alamat`, `voucher`). Per-entity (de)serialization lives in the models' `toJson`/`fromJson` (not in the service or screens — don't duplicate it). Providers take an **optional** `StorageService`; when null they run pure in-memory (used by unit/widget tests). Rupiah formatting/parsing is centralized in `utils/currency.dart` (`formatRupiah`/`parseRupiah`) — do not re-inline it in screens.

**Design system (reuse these — don't re-inline styles):** `lib/theme/` holds tokens (`app_colors.dart`, `app_spacing.dart` → `AppSpacing`/`AppRadius`) and `app_theme.dart` (`AppTheme.light`, green seed, Material 3, light-only — no dark mode by request). `lib/widgets/` holds shared widgets: `AppCard`, `EmptyState`, `SectionTitle`, `PrimaryButton`, `QuantitySelector` (animated +/−), `OrderStatusBadge`, `FoodCard` (the menu card — image/habis-overlay/favorite/add, used by Home + Favorite), `FavoriteButton` (heart, scoped via `context.select`), `CategoryChip`, `AuthTextField` (auth fields: prefix icon, focus state, password toggle). Prefer these over hand-rolled styling.

**Menu & categories are centralized** in `lib/data/menu_data.dart` (`kMenu` = `List<Product>` with `category`; `kCategories` = `List<FoodCategory>`; `kAllCategory`). Home filters locally via `setState` (category × realtime search). When the menu becomes dynamic, swap the source here.

**Favorites:** `providers/favorites_provider.dart` (`FavoritesProvider`) keys by product **name**, persists a string list via `StorageService` (`favorites` key). Bottom nav has a Favorit tab (`screens/favorite_screen.dart`); Home shows a "Favorit Kamu" section only when non-empty.

**Orders carry an `OrderStatus`** (`lib/models/order_status.dart`: diproses/disiapkan/dikirim/selesai/dibatalkan) and optional `notes`. New orders default to `diproses`; `Order.fromJson` falls back to `selesai` (status) and `''` (notes) for legacy data (backward-compat). `CartProvider.addOrder(total, {notes})` captures the checkout note. Detail screen renders a vertical progress timeline + a dummy ETA (`utils/delivery.dart`, deterministic by item count, null when selesai/dibatalkan) + a "Catatan Pesanan" card when notes exist; history shows `OrderStatusBadge`. Reorder logic lives in `utils/reorder.dart`; "Pernah Dipesan" recommendations in `utils/recommendations.dart` (both pure, order-history-based).

**`cloud_firestore` is listed in `pubspec.yaml` but is not used anywhere in Dart code.** Only Firebase Auth is wired up. `shared_preferences` is the only persistence; it's a key-value store, fine for the current scale — see the note below on when to graduate to a real database.

**Authentication** lives in `services/auth_service.dart` (`AuthService`), wrapping Firebase Auth (email/password + Google Sign-In) — also `register(email, password, {name})` (sets `displayName`) and `changePassword()` (reauthenticates first; rejects Google-only accounts). `firebase_options.dart` is FlutterFire-generated — do not hand-edit; regenerate with `flutterfire configure`. `screens/login_screen.dart` navigates to `/home` on success; the Register button routes to `/register` (`screens/register_screen.dart`). "Ganti Password" lives in `screens/info_pribadi_screen.dart`. Form validation is centralized in `utils/validators.dart` (`emailError`/`passwordError`).

**Navigation** is named routes declared in `main.dart`'s `MaterialApp.routes`; `initialRoute` is `/login`. Note two patterns coexist:
- The bottom navigation bar in `screens/home_screen.dart` swaps between Home/Cart/Profile by **list index** (`_selectedIndex`), not by route.
- Several screens return a value via `Navigator.pop` that the caller awaits — e.g. checkout awaits a selected address from `/alamat` and a payment method from `PembayaranScreen`.

**The menu is hardcoded**, not fetched. The active food list is the `allFoods` list inside the `_HomeContentState` in `screens/home_screen.dart`. The home screen also reverse-geocodes the device location (geolocator + geocoding) to show the user's city in the header.

**Theme**: Material 3 with green seed color `0xFF43A047`; the recurring accent green across screens is `0xFF4CAF50`.

## Gotchas

- **The home screen's `HomeContent` lives inside `home_screen.dart`** (a `StatefulWidget` nested in the same file), not in its own file. Edit it there for home-screen changes.
- **`test/widget_test.dart` covers `CartProvider` logic and a `CartScreen` widget smoke test.** It deliberately avoids `MyApp`/`LoginScreen` because those touch `FirebaseAuth.instance`, which throws in tests when Firebase isn't initialized. Keep new widget tests free of Firebase/geolocation, or mock those platform channels first.

# 📝 Notes App

A beautiful, fully offline notes app built with **Flutter**, powered by **Provider** for state management, **Hive** for local storage, and structured with **Clean Architecture** principles. Create, organise, search, and tag your notes — with full dark/light mode support.

---

## 📱 App Screens

<p align="center">
  <img src="./screenshots/home_dark.png" width="30%" />
  <img src="./screenshots/editor.png" width="30%" />
  <img src="./screenshots/home_light.png" width="30%" />
</p>

---

## 🚀 Features

* 📝 Create, edit and delete notes
* 🔍 Real-time search — matches title, content, and tags (300ms debounce)
* 🏷️ Tags / Categories — add from suggestions or type custom tags
* 🎨 8 note colour themes — per-note colour with matching accents
* 📌 Pin notes — pinned notes always float to the top
* 🌙 Dark / Light mode toggle — persisted across sessions
* 📊 Grid / List view toggle — 2-column grid or full-width list
* ↕️ Sort by — last modified (newest / oldest), title (A → Z / Z → A)
* 🔖 Tag filter bar — tap any tag to filter all notes by it
* ✅ Auto-save on back press — never lose a note accidentally
* 💾 Fully offline — all data stored locally with **Hive** (zero network)
* 🗑️ Long-press options — pin, edit, or delete from a bottom sheet

---

## 🏗️ Architecture

This project follows **Clean Architecture** with a feature-based folder structure:

```
lib/
 ├── core/
 │   ├── theme/              # Full dark + light themes, 8 note colour palettes
 │   ├── utils/              # Hive constants, 8 default tag suggestions
 │   └── error/              # Failure types
 ├── features/
 │   └── notes/
 │       ├── data/
 │       │   ├── models/         # NoteModel (Hive HiveObject)
 │       │   │                   # NoteModelAdapter (hand-written, no build_runner)
 │       │   ├── datasources/    # NotesLocalDataSource (Hive box CRUD)
 │       │   └── repositories/   # NotesRepositoryImpl (search, tag filter, CRUD)
 │       ├── domain/
 │       │   ├── entities/       # Note entity (id, title, content, tags, colorIndex, isPinned)
 │       │   ├── repositories/   # NotesRepository (abstract, 8 methods)
 │       │   └── usecases/       # 8 use cases (GetAll, Search, GetByTag, GetById,
 │       │                       #              Save, Delete, DeleteAll, GetAllTags)
 │       └── presentation/
 │           ├── providers/      # NotesProvider (ChangeNotifier) — search, sort, filter, CRUD
 │           │                   # ThemeProvider (ChangeNotifier) — dark/light + persistence
 │           ├── pages/          # HomePage, NoteEditorPage
 │           └── widgets/        # NoteCard, TagFilterBar, NotesSearchBar
 ├── injection_container.dart    # Manual DI wiring
 └── main.dart                   # Hive init + MultiProvider + MaterialApp with themeMode
```

### 🔁 State Management

* Uses **Provider** (`ChangeNotifier`) with two providers — `NotesProvider` and `ThemeProvider`
* `NotesProvider` manages: all notes, search with 300ms debounce, active tag filter, sort order, grid/list toggle
* `ThemeProvider` manages: dark/light mode state, toggle, persistence via `SharedPreferences`
* Both providers are registered at the root via `MultiProvider` and available anywhere in the tree

---

## 🎨 UI Highlights

* 🌑 Deep dark navy background (`#0F0F14`) with translucent card surfaces
* ☀️ Clean off-white light theme with subtle shadows
* 💜 Purple accent (`#7C6EF7`) for FAB, selection, and pin indicators
* 🎨 8 note colour themes — each with a matching accent colour for tags and borders
* 📌 Pinned section visually separated from regular notes
* 🔖 Horizontal scrollable tag filter chips beneath the search bar
* ↔️ Smooth animated colour picker bottom sheet
* ✏️ Distraction-free editor — borderless title and content fields
* 🏷️ Tag suggestions sheet with preset tags + custom input
* 🎯 FAB with edit icon for quick note creation

---

## 🎨 Note Colours

| Index | Name | Dark Card | Light Card | Accent |
|---|---|---|---|---|
| 0 | Default | `#1E1E2C` | `#FFFFFF` | Purple |
| 1 | Purple | `#2D1B2E` | `#F3E8FF` | Violet |
| 2 | Teal | `#1B2D2D` | `#E0F7F6` | Teal |
| 3 | Amber | `#2D2518` | `#FFF8E1` | Amber |
| 4 | Red | `#2D1B1B` | `#FFEBEB` | Red |
| 5 | Green | `#1B2520` | `#E8F5E9` | Green |
| 6 | Blue | `#1B1F2D` | `#E8EAF6` | Blue |
| 7 | Pink | `#2D1F2A` | `#FCE4EC` | Pink |

---

## 🏷️ Default Tag Suggestions

`Personal` · `Work` · `Ideas` · `Todo` · `Important` · `Study` · `Shopping` · `Travel`

Custom tags can be typed in the tag input field and are automatically saved with the note.

---

## 🧪 Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | Flutter |
| Language | Dart |
| State | Provider (ChangeNotifier) |
| Local DB | Hive (hive_flutter) |
| Persistence | SharedPreferences (theme + view prefs) |
| IDs | uuid |
| Architecture | Clean Architecture |

---

## 📦 Dependencies

```yaml
provider: ^6.1.2
equatable: ^2.0.5
hive: ^2.2.3
hive_flutter: ^1.1.0
uuid: ^4.4.0
intl: ^0.19.0
shared_preferences: ^2.3.2
```

> ✅ No `build_runner` required — the Hive `TypeAdapter` is hand-written in `note_model.g.dart`, so the app compiles immediately with just `flutter pub get`.

---

## 🚀 Getting Started

```bash
git clone <repo-url>
cd notes_app
flutter pub get
flutter run
```

No API keys, no setup — just run. All data is stored locally on the device.

---

## 🗂️ Note Entity

```dart
class Note {
  final String      id;           // UUID v4
  final String      title;        // Note title (can be empty)
  final String      content;      // Note body
  final List<String> tags;        // User-defined tags
  final int         colorIndex;   // 0–7, maps to colour palette
  final bool        isPinned;     // Pinned notes appear at the top
  final DateTime    createdAt;    // Creation timestamp
  final DateTime    updatedAt;    // Last modified timestamp
}
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to fork this repo and submit a PR.

---

## 📄 License

This project is licensed under the MIT License.

# 📖 TechVeda

**TechVeda** is a free learning app for students who want clear, practical programming guides in one place. Browse curated PDF courses, search by topic, get unstuck with **TechVeda AI** (built by **Suresh Yadav**), and learn at your own pace—with a modern, easy-to-use interface.

---

## ✨ Features

- **Course library** — Horizontal cards with search and category filters
- **Offline PDF guides** — Read in-app (no extra apps needed)
- **TechVeda AI** — Ask questions when you’re stuck (powered by Gemini Flash)
- **Topics covered** — C, Dart, Flutter, Android, Python, databases, ethical hacking basics
- **Developer profile** — Contact Suresh Yadav, portfolio, and published Play Store apps
- **Auto-update check** — Notifies when a newer app version is available

---

## 🌟 Learn

- **Basics** — C Programming
- **App Development** — Dart, Flutter, Flutter Basics, Android (Java)
- **Python** — Learn Python, Web Python
- **Hacking (educational)** — Python for hackers, ethical hacking roadmap, Kali Linux commands
- **Database** — MySQL, MongoDB, PostgreSQL, SQLite

---

## 📱 Screenshots

### Preview

<center>
<div style="display:flex;gap:20px;">
<img src="https://github.com/0sureshyadav0/techVeda/blob/master/assets/images/img1-removebg-preview.png?raw=true" height = "30%" width="30%">
<img src="https://github.com/0sureshyadav0/techVeda/blob/master/assets/images/img2-removebg-preview.png?raw=true" height = "30%" width="30%">
<img src="https://github.com/0sureshyadav0/techVeda/blob/master/assets/images/img3-removebg-preview.png?raw=true" height = "30%" width="30%">
</div>

</center>

---

## 🚀 Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/0sureshyadav0/techVeda.git
   ```

2. Navigate to the project directory:

   ```bash
   cd techVeda
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app (debug):
   ```bash
   flutter run
   ```

---

## 📦 Production / release build

### Run on device in release mode
```bash
flutter run --release
```

Or in VS Code / Cursor: choose **TechVeda (release)** from the Run and Debug panel.

### Build release APK (Play Store / distribution)

1. Create an upload keystore under `android/app/` (once), or use your existing `android/app/upload-keystore.jks`:
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Copy `android/key.properties.example` → `android/key.properties` and set passwords. Keep `storeFile=upload-keystore.jks` (path is relative to `android/app/`).

3. Build:
   ```bash
   chmod +x scripts/build_release_apk.sh
   ./scripts/build_release_apk.sh
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`

   Manual equivalent:
   ```bash
   flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
   ```

4. For Google Play (App Bundle):
   ```bash
   flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
   ```

> Without `android/key.properties`, release builds still compile but are signed with the **debug** key (not valid for Play Store upload).

---

## 🤖 AI Study Assistant (Gemini Flash)

Students can tap **Ask AI** on the home screen to get help when stuck.

1. Create an API key at [Google AI Studio](https://aistudio.google.com/apikey).
2. Copy the env template and add your key (`.env` is gitignored):

   ```bash
   cp .env.example .env
   # Edit .env and set: GEMINI_API_KEY=your_actual_key
   flutter pub get
   flutter run
   ```

3. Optional CI/release override:

   ```bash
   flutter build apk --release --dart-define=GEMINI_API_KEY=your_key
   ```

> **Security:** `.env` is not committed to git, but it is bundled in the app assets at build time — keys can still be extracted from an APK. For Play Store production, use a backend proxy when possible.

---

## 📢 AdMob

Configured in `lib/config/ad_config.dart`:

| Unit | ID |
|------|-----|
| App | `ca-app-pub-6713635279268340~6940175415` |
| Interstitial | `.../4139741934` |
| Banner 1–3 | `.../1869332040`, `.../1322006909`, `.../3108741617` |

- **Banners:** after the first 3 course sections on home + sticky bottom (banner 3).
- **Interstitial:** before **every** course PDF open; Ask AI / Developer use a 90s cooldown.
- **Debug builds** use Google test ad units automatically.

Link the app in [AdMob](https://admob.google.com/) and complete payment profile before live ads serve.

---

## 🛠️ Technologies Used

- **Flutter** & **Dart**
- **Firebase** — Firestore, Auth, Cloud Messaging
- **Google Mobile Ads** — Banner & interstitial (AdMob)
- **Gemini Flash** — AI study assistant
- **Get** — Navigation
- **Provider** — App state
- **Syncfusion PDF Viewer** — In-app PDF reading
- **flutter_dotenv** — Secure API key loading

---

## 📂 Project Structure

```plaintext
techVeda/
├── lib/
│   ├── main.dart
│   ├── bootstrap.dart
│   ├── config/          # API keys, AdMob IDs
│   ├── data/            # Course catalog
│   ├── features/
│   │   ├── ai_assistant/
│   │   └── version/
│   ├── screens/         # Home, PDF, Developer
│   ├── services/        # AdMob
│   ├── theme/
│   └── widgets/
├── assets/
│   ├── images/
│   └── pdfs/
├── android/
└── pubspec.yaml
```

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/0sureshyadav0/techVeda/blob/master/LICENSE.txt?raw=true) file for details.

---

## 🧑‍💻 Developer

- **🧔Suresh Yadav**
- 🌐 [sureshyadav.info.np](http://sureshyadav.info.np)

---

## 🙌 Contribution

Contributions are welcome! Feel free to open an issue or submit a pull request.

---

## 📞 Support

For any issues or feedback, contact [Suresh Yadav](mailto:sureshyadav.info.np@gmail.com).

---

Enjoy **TechVeda**! 📖

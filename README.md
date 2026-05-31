# 📖TechVeda

TechVeda is a app that offers guide for various programming languages, helping users learn and compare languages like Python, Java, Flutter, Dart, and more in an interactive and user-friendly way.

---

## 🌟 Learn

- **App Development**: Dart, Flutter, Android
- **Python**: Basics Python, Web Python
- **Hacking Basic Guide**:Learn Python, Ethical Hacking Roadmap, Kali linux commands
- **Database**: MySQL,MongoDB,PostgreSQL and SQLite

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

## 🛠️ Technologies Used

- **Flutter**: The app framework.
- **Dart**: Programming language.
- **Get Package**: For navigation and snackbars.
- **syncfusion_flutter_pdfviewer** Package: To show pdf file
---

## 📂 Project Structure

```plaintext
techVeda/
├── lib/
│   ├── screens/
│   │   ├── home_page.dart
│   │   ├── pdf_view.dart
│   ├── providers/
│   │   └── music_provider.dart
│   ├── consts/
│   │   └── consts.dart
│   └── main.dart
│   ├── widgets/
│   │   └── text.dart
├── assets/
│   ├── images/
│   │   └── dart.png
│   ├── pdfs/
│       └── Commands.pdf
│       └── ......
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

# 🌱 Farmpoa

Farmpoa is a **smart agriculture assistant** built with **Flutter**.  
It leverages **AI (TensorFlow Lite)** and device sensors to help farmers detect plant diseases, monitor farm conditions, and make better farming decisions.

---

## ✨ Features
- 📸 **Plant Disease Detection** – Capture images of crops and run them through a TensorFlow Lite model.
- 🛰️ **Geolocation Support** – Track farm location and environmental data.
- 🌐 **Cloud Sync** – Save results to the server for later analysis.
- 🔔 **Notifications** – Get instant feedback when scans are processed.
- 📊 **Reports** – View past scans and insights on crop health.

---

## 🛠️ Tech Stack
- **Framework:** Flutter (Dart)
- **AI:** TensorFlow Lite (via `tflite_flutter`)
- **Plugins Used:**
  - `camera`
  - `geolocator`
  - `image_picker`
  - `shared_preferences`
  - `google_maps_flutter`
- **Backend (optional):** REST API for saving results

---

## 📦 Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/<your-username>/farmpoa.git
   cd farmpoa
````

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run on device (USB debugging or emulator):**

   ```bash
   flutter run
   ```

---

## ⚙️ Android Setup

* Minimum SDK: **26**
* Compile SDK: **36**
* NDK Version: **27.0.12077973**

Make sure your `android/app/build.gradle` includes:

```gradle
android {
    defaultConfig {
        minSdkVersion 26
    }
    compileSdk 36
    ndkVersion "27.0.12077973"
}
```

---

## 📂 Project Structure

```
farmpoa/
 ┣ lib/
 ┃ ┣ ai/                # TensorFlow Lite runner and models
 ┃ ┣ screens/           # Flutter UI screens
 ┃ ┣ src/ui/vision/     # Vision screen (camera + prediction)
 ┃ ┣ main.dart          # Entry point
 ┃ ┗ ...
 ┣ android/             # Android-specific code
 ┣ ios/                 # iOS-specific code
 ┣ pubspec.yaml         # Dependencies
 ┗ README.md            # Project documentation
```

---

## 🚀 Roadmap

* [ ] Add offline disease prediction
* [ ] Expand dataset for more crops
* [ ] Add farmer community features
* [ ] Integration with weather APIs

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit changes (`git commit -m "Add my feature"`)
4. Push to branch (`git push origin feature/my-feature`)
5. Open a Pull Request 🎉

---

## 📜 License

This project is licensed under the **MIT License**.
Feel free to use and modify it for your own projects.

---

## 👨‍💻 Author

**Eugene Muhua Odweso**
📧 [eugenemuhua@gmail.com](mailto:eugenemuhua@gmail.com)
🌍 Nairobi, Kenya

---

### 🌟 If you like this project, give it a star on GitHub!

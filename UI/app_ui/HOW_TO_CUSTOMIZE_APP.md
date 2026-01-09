# How to Add Custom Name and Logo to Your Flutter App

## 📱 Change App Name

### Method 1: Change Display Name (What Users See)

The app name users see on their home screen is configured differently for each platform:

#### **Android** 📱

**File:** `android/app/src/main/AndroidManifest.xml`

Find this line (around line 8):

```xml
<application
    android:label="expense_tracker_ui"
    ...>
```

Change to your custom name:

```xml
<application
    android:label="MoneyTrack"
    ...>
```

#### **iOS** 🍎

**File:** `ios/Runner/Info.plist`

Find these lines:

```xml
<key>CFBundleDisplayName</key>
<string>expense_tracker_ui</string>
```

Change to:

```xml
<key>CFBundleDisplayName</key>
<string>MoneyTrack</string>
```

#### **Web** 🌐

**File:** `web/index.html`

Find this line (around line 28):

```html
<title>expense_tracker_ui</title>
```

Change to:

```html
<title>MoneyTrack - Personal Finance Tracker</title>
```

**File:** `web/manifest.json`

```json
{
  "name": "MoneyTrack",
  "short_name": "MoneyTrack",
  "description": "Personal Finance Tracker"
}
```

#### **Windows** 🪟

**File:** `windows/runner/Runner.rc`

Find and change the app name in the version info section.

---

### Method 2: Change Package Name (Internal Identifier)

**⚠️ Warning:** This is more complex and should be done early in development.

The package name is like `com.yourcompany.expense_tracker_ui`

**Use the `change_app_package_name` package:**

```bash
# Add package
flutter pub add change_app_package_name

# Change package name
flutter pub run change_app_package_name:main com.yourcompany.moneytrack
```

---

## 🎨 Add Custom App Icon/Logo

### Method 1: Use Flutter Launcher Icons Package (RECOMMENDED) ⭐

This is the **easiest and most reliable** method!

#### Step 1: Install Package

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1 # Add this line
```

#### Step 2: Prepare Your Logo

**Requirements:**

- **Size:** 1024x1024 pixels (minimum 512x512)
- **Format:** PNG with transparency
- **Location:** Put in `assets/icon/` folder

Create the folder:

```bash
mkdir -p assets/icon
```

Add your icon file:

```
assets/icon/app_icon.png  (1024x1024)
```

#### Step 3: Configure in pubspec.yaml

Add this configuration at the bottom of `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
  windows:
    generate: true
  image_path: "assets/icon/app_icon.png"

  # Optional: Adaptive icon for Android (with background)
  adaptive_icon_background: "#6366F1" # Your primary color
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"

  # Optional: Different icons for different platforms
  # image_path_android: "assets/icon/icon_android.png"
  # image_path_ios: "assets/icon/icon_ios.png"
```

#### Step 4: Generate Icons

Run this command:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

**Output:**

```
Creating icons for Android...
Creating icons for iOS...
Creating icons for Web...
Creating icons for Windows...
✓ Successfully generated launcher icons
```

#### Step 5: Clean and Rebuild

```bash
flutter clean
flutter pub get
flutter run
```

---

### Method 2: Manual Icon Setup (Advanced)

If you want full control, here's how to do it manually:

#### **Android Icons**

Create multiple sizes and place in these folders:

```
android/app/src/main/res/
  ├── mipmap-mdpi/ic_launcher.png      (48x48)
  ├── mipmap-hdpi/ic_launcher.png      (72x72)
  ├── mipmap-xhdpi/ic_launcher.png     (96x96)
  ├── mipmap-xxhdpi/ic_launcher.png    (144x144)
  ├── mipmap-xxxhdpi/ic_launcher.png   (192x192)
```

#### **iOS Icons**

Place in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Sizes needed: 20x20, 29x29, 40x40, 60x60, 76x76, 83.5x83.5, 1024x1024

Edit `Contents.json` to reference your images.

#### **Web Icons**

Place in `web/icons/`:

```
web/icons/
  ├── Icon-192.png
  ├── Icon-512.png
  └── Icon-maskable-192.png
  └── Icon-maskable-512.png
```

Update `web/manifest.json`:

```json
{
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

---

## 🎯 Quick Setup Guide (Recommended Path)

### For Your Expense Tracker App:

**1. Create Your Logo:**

- Design a 1024x1024 PNG icon
- Simple, recognizable design
- Works well at small sizes
- Example: Money bag icon, dollar sign, wallet icon

**2. Add flutter_launcher_icons:**

Edit `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1
```

**3. Add configuration:**

At the bottom of `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
  windows:
    generate: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#6366F1"
```

**4. Create folder and add icon:**

```bash
mkdir assets
mkdir assets/icon
# Place your app_icon.png (1024x1024) in assets/icon/
```

**5. Generate icons:**

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

**6. Test:**

```bash
flutter clean
flutter run
```

---

## 🖼️ Icon Design Tips

### Good App Icons:

- ✅ Simple and recognizable
- ✅ Works at small sizes (48x48)
- ✅ Consistent with app branding
- ✅ High contrast
- ✅ No text (looks bad when small)

### Bad App Icons:

- ❌ Too detailed (hard to see when small)
- ❌ Text-heavy
- ❌ Low contrast
- ❌ Generic stock images

### For Expense Tracker, Consider:

- 💰 Money bag icon
- 📊 Bar chart
- 💵 Dollar sign
- 📱 Wallet icon
- 📈 Trend line
- 🏦 Bank building (simple)

---

## 🎨 Design Tools for Creating Icons

### Free Online Tools:

1. **Canva** - Easy icon design

   - https://www.canva.com
   - Templates for app icons

2. **Figma** - Professional design

   - https://www.figma.com
   - Free tier available

3. **Flat Icon** - Download free icons

   - https://www.flaticon.com
   - PNG, SVG formats

4. **Icons8** - Icon library
   - https://icons8.com
   - Customize colors

### AI-Generated Icons:

- Use DALL-E, Midjourney, or similar
- Prompt: "Modern minimalist app icon for expense tracker, flat design, simple geometric shapes, professional"

---

## 📋 Complete Example for Your Project

Let's set up "MoneyTrack" with a custom icon:

### 1. Update pubspec.yaml:

```yaml
name: expense_tracker_ui
description: "Personal Expense Tracker"

# ... existing configuration ...

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  flutter_launcher_icons: ^0.13.1 # Add this

# Add this at the bottom
flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
  windows:
    generate: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#6366F1" # Your primary color
  min_sdk_android: 21
```

### 2. Create icon folder:

```bash
mkdir assets
mkdir assets\icon
```

### 3. Add your icon:

Place `app_icon.png` (1024x1024) in `assets/icon/`

### 4. Update AndroidManifest.xml:

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<application
    android:label="MoneyTrack"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

### 5. Update iOS Info.plist:

**File:** `ios/Runner/Info.plist`

```xml
<key>CFBundleDisplayName</key>
<string>MoneyTrack</string>
<key>CFBundleName</key>
<string>MoneyTrack</string>
```

### 6. Update web index.html:

**File:** `web/index.html`

```html
<head>
  <meta charset="UTF-8" />
  <meta name="description" content="Personal Finance Tracker" />
  <title>MoneyTrack</title>

  <!-- Add favicon -->
  <link rel="icon" type="image/png" href="icons/Icon-192.png" />
</head>
```

### 7. Generate and test:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
flutter clean
flutter run -d chrome
```

---

## 🔍 Verify Your Changes

### Check App Name:

- **Android:** Look at app drawer after installing
- **iOS:** Look at home screen
- **Web:** Look at browser tab title

### Check App Icon:

- **Android:** App drawer icon
- **iOS:** Home screen icon
- **Web:** Browser tab favicon, PWA icon
- **Windows:** Taskbar icon

---

## 🐛 Troubleshooting

### Issue: Icons not showing

**Solution:**

```bash
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
# Then rebuild app
```

### Issue: Android icon not changing

**Solution:**

- Uninstall app completely
- Clear emulator cache
- Reinstall app

### Issue: iOS icon not updating

**Solution:**

- Clean iOS build folder
- Delete app from simulator
- Rebuild

### Issue: Wrong app name showing

**Solution:**

- Check you edited the correct platform file
- Sometimes need to uninstall and reinstall

---

## ✅ Checklist for Custom Name & Logo

- [ ] Created 1024x1024 PNG icon
- [ ] Created `assets/icon/` folder
- [ ] Added icon file to folder
- [ ] Added `flutter_launcher_icons` to pubspec.yaml
- [ ] Configured flutter_launcher_icons in pubspec.yaml
- [ ] Ran `flutter pub get`
- [ ] Ran `flutter pub run flutter_launcher_icons`
- [ ] Updated AndroidManifest.xml with app name
- [ ] Updated iOS Info.plist with app name
- [ ] Updated web index.html with app name
- [ ] Ran `flutter clean`
- [ ] Tested app on target platform
- [ ] Verified icon shows correctly
- [ ] Verified name shows correctly

---

## 🎉 Result

After following these steps, your app will have:

- ✅ Custom app name ("MoneyTrack" or your choice)
- ✅ Custom icon on all platforms
- ✅ Professional branding
- ✅ Consistent identity across platforms

---

## 📚 Additional Resources

**Packages:**

- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) - For splash screens
- [change_app_package_name](https://pub.dev/packages/change_app_package_name)

**Icon Guidelines:**

- [Android Icon Design](https://developer.android.com/guide/practices/ui_guidelines/icon_design)
- [iOS App Icon](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Material Design Icons](https://m3.material.io/styles/icons/designing-icons)

**Tools:**

- [App Icon Generator](https://appicon.co/)
- [Make App Icon](https://makeappicon.com/)
- [Icon Kitchen](https://icon.kitchen/)

---

**Need help?** Just ask! I can help you:

- Design an icon concept
- Write the configuration
- Troubleshoot issues
- Create a splash screen

Good luck branding your expense tracker app! 🚀

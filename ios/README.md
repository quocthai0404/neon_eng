# Neon English iOS

Native iPhone SwiftUI prototype for **Neon English**, targeting iOS 17 (`com.neonenglish.app`). The project uses Apple SwiftUI and SF Symbols only. All learning content and interactions are local presentation samples; there is no backend, cloud DB, Study4 integration, imported course data, persistence, or tracking algorithm.

The 19 MOBILE screens from the Codex Stitch project have been inspected and used to shape the SwiftUI screens and navigation. See [STITCH-REFERENCE.md](STITCH-REFERENCE.md) for the screen map, design contract, and exact image assets. Pixel-level verification remains pending because this Windows workspace cannot run an iOS Simulator and Stitch did not return screen screenshots through MCP.

## Implemented Screens & Source Files

- **App shell:** `NeonEnglish/App/NeonEnglishApp.swift`, `NeonEnglish/App/RootTabView.swift` — four native tabs and shared local navigation for detail/practice routes.
- **Theme and samples:** `NeonEnglish/Theme/NeonTheme.swift`, `NeonEnglish/Models/MockModels.swift` — Stitch-derived colors/shapes plus Vietnamese/English sample content.
- **Top-level tabs:** Today plan, course library, review queue, and a progress preview in `Screens/Today`, `Screens/Learn`, `Screens/Review`, and `Screens/Progress`.
- **Vocabulary:** catalog, topic detail, flashcard, MCQ, matching, fill-blank, and listen-word screens in `Screens/Vocabulary`.
- **Grammar:** topic catalog, theory, and practice in `Screens/Grammar`.
- **Dictation:** lesson/mode picker and NORMAL, HARD, SENTENCE practice in `Screens/Dictation`.
- **Listening/Reading:** one local sample for each Part 1–7, including picture, response, conversation, talk, sentence, passage, and reading formats in `Screens/ListeningReading`.
- **Results:** shared answer review screen in `Screens/Results`, reachable from local practice flows. Audio buttons are presentation controls only and do not play archived media yet.

## Project Generation & Build

The repository tracks `project.yml` (XcodeGen specification) and the Swift sources under `ios/NeonEnglish/`. This Windows workspace has no Xcode; project generation and compilation run in GitHub Actions on a macOS runner. To build locally on a Mac:

```sh
brew install xcodegen
cd ios
xcodegen generate
open NeonEnglish.xcodeproj
```

## GitHub Actions And Device Signing

The `Neon English iOS` workflow runs on pushes to `main`, pull requests, and manual dispatch. It generates the Xcode project, builds the iPhone target, and uploads `neon-english-ios-unsigned-ipa` for 14 days. This unsigned IPA proves the device-target build but **cannot be installed directly on an iPhone**.

To have CI also upload an installable IPA, add these repository Actions secrets:

- `IOS_CERTIFICATE_BASE64`: base64-encoded Apple signing certificate exported as `.p12`.
- `IOS_CERTIFICATE_PASSWORD`: password used when exporting that `.p12`.
- `IOS_PROVISIONING_PROFILE_BASE64`: base64-encoded provisioning profile for `com.neonenglish.app`.
- `IOS_TEAM_ID`: Apple Developer Team ID.
- `IOS_EXPORT_METHOD`: `development` or `ad-hoc`, matching the certificate/profile type.

For a review build installed on a specific iPhone, register that device's UDID in the Apple Developer account and include it in the provisioning profile. Use an Apple Development certificate with a development profile, or an Apple Distribution certificate with an Ad Hoc profile. Keep all signing files and values in GitHub secrets; never commit them. When all five secrets are configured, CI also uploads `neon-english-ios-signed-ipa`.

## Configuration Summary

- iOS deployment target: `17.0` (`TARGETED_DEVICE_FAMILY: "1"`, iPhone)
- Bundle identifier: `com.neonenglish.app`
- Display name: `Neon English`
- External Swift packages: none
- Assets: `NeonEnglish/Assets.xcassets` (AccentColor `#1D4ED8`, Stitch-derived vocabulary and Part 1 photos; app icon export still pending)
- Next: generate/build on macOS, inspect all 19 screens in iPhone Simulator, and make any visual corrections. Keep backend/data integration out until separately requested.

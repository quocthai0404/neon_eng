# Neon English

Native iPhone learning app prototype for Neon English. The current app is a SwiftUI presentation prototype with local sample content; backend, cloud storage, imported course data, and persistent progress tracking are not implemented yet.

## iOS app

- App source and XcodeGen specification: [`ios/`](ios/)
- Bundle identifier: `com.neonenglish.app`
- Minimum iOS version: 17.0
- UI reference map: [`ios/STITCH-REFERENCE.md`](ios/STITCH-REFERENCE.md)

## CI artifacts

GitHub Actions builds the iPhone target on macOS for pushes to `main`, pull requests, and manual runs. It always uploads an unsigned IPA for build review. An unsigned IPA cannot be installed directly on an iPhone; see [`ios/README.md`](ios/README.md#github-actions-and-device-signing) for the signing setup required to produce an installable IPA.

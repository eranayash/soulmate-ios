# Soul Mate (iOS)

Anonymous, gamified peer-to-peer emotional support app built with SwiftUI.

## Phase 1 MVP

- Anonymous onboarding (< 3 taps)
- Seeker dashboard with mood filter + mock penpal matching
- Text chat with live mock replies
- Token economy: 1 token = 6 minutes, charged at chunk boundaries
- Wallet with mock top-up + transaction history
- Penpal availability toggle (incoming requests in Phase 2)

## Architecture

```
SoulMateApp/
├── App/              Entry point + navigation coordinator
├── Core/             Theme, components, extensions
├── Features/         Auth, Dashboard, Chat, Wallet
├── Services/         Chat, token economy, session state
└── Models/           User, ChatSession, TokenTransaction
```

## Requirements

- macOS with **Xcode 15+** (not Command Line Tools only)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) for project generation

## Quick Start

```bash
# 1. Generate Xcode project
./scripts/bootstrap.sh

# 2. Open in Xcode
open SoulMateApp.xcodeproj

# 3. Run full local CI pipeline
./scripts/ci.sh
```

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/bootstrap.sh` | Generate Xcode project via XcodeGen |
| `scripts/lint.sh` | Structure + Swift parse checks |
| `scripts/build.sh` | Build for iOS Simulator |
| `scripts/test.sh` | Run unit tests |
| `scripts/ci.sh` | Full local CI pipeline |

## Token Economy Rules

- 1 token = 6 minutes (360 seconds)
- Balance check before starting a chat
- Token deducted at end of each chunk
- 30-second grace period when balance hits zero mid-session
- Penpal earns 1 token per completed chunk (seeker side)

## CI/CD

GitHub Actions workflow: `.github/workflows/ios-ci.yml`

Runs on push/PR to `main` and `develop`:
1. Lint
2. Bootstrap (XcodeGen)
3. Build
4. Test

## Roadmap

- [ ] Firebase anonymous auth + Firestore chat
- [ ] Real penpal matching queue
- [ ] StoreKit token purchases
- [ ] Voice chat
- [ ] Report / block / safety flows

## Disclaimer

This app provides casual peer support only. It is **not** a substitute for professional mental health care.

# Notch Teleprompter

**A tiny, instant teleprompter for macOS that sits right under your webcam, so you read while looking straight into the lens.**

No browser tabs, no URL bar, no window chrome. Just a borderless black strip glued to the top-center of your screen (right below the MacBook notch), always on top, and invisible to screen recordings and video calls.

[Leia em português](README.pt-BR.md)

<!-- Add a screenshot or GIF here: docs/demo.gif -->

## Why

Web teleprompters work, but they live inside a browser window: tab bar, address bar, and a text area in the middle of the screen. You end up looking at the middle of the display instead of the camera, and it shows on video.

Notch Teleprompter moves the text to the one place that matters: directly below the camera. The first line you read is the one closest to the lens, and the text fades out as it goes down so your eyes stay at the top.

## Features

- **Camera-adjacent:** auto-positions at the top-center of the display with the notch (or the main display on Macs without one), starting right below the notch.
- **Borderless & always on top:** no title bar, floats above every app, including full-screen apps and all Spaces.
- **Hidden from screen capture:** Zoom, Meet, Teams, QuickTime, and screenshots do not see it (toggle with `C`).
- **Hyper fast:** native AppKit window + `WKWebView`, scrolling driven by `requestAnimationFrame` on the compositor. Launches instantly, no Dock icon.
- **On-screen control bar** below the reading area: play/pause, reset, speed, font size, window height and width, script editor.
- **Full keyboard control**, so you never leave the script while recording.
- **Persistent:** script and settings are saved in `~/.teleprompter/`.
- **Tiny and hackable:** ~100 lines of Swift + one HTML file. No dependencies, no Xcode project.

## Install

Requires macOS 12+ and the Xcode Command Line Tools (`xcode-select --install`).

```bash
git clone https://github.com/valvesss/notch-teleprompter.git
cd notch-teleprompter
./build.sh
open Teleprompter.app
```

Tip: drag `Teleprompter.app` to `/Applications` to launch it from Spotlight, Raycast, or Alfred.

## Usage

Press `E` to open the editor, paste your script (Cmd+V), then press `Esc` to save and go back. Press `Space` to start.

| Key | Action |
|---|---|
| `Space` | Play / pause |
| `↑` `↓` | Speed |
| `-` `=` | Font size |
| `[` `]` | Window height |
| `,` `.` | Window width |
| `R` / `Home` | Back to the start |
| `PageUp` `PageDown` | Jump three lines |
| `E` | Edit script (`Esc` saves and closes) |
| `C` | Toggle visibility in screen recordings and screen sharing |
| `Esc` / `Cmd+Q` | Quit |

The mouse wheel scrolls the text, and every setting is also available on the control bar.

## How it works

- `Teleprompter.swift` creates a borderless `NSWindow` at status-bar level, positions it using `NSScreen.safeAreaInsets` (the notch height), disables its capture with `sharingType = .none`, and hosts a `WKWebView`.
- `index.html` renders the script and the control bar. Scrolling is time-based (`dt` per frame), so speed stays constant regardless of frame rate.
- The two talk through a small `WKScriptMessageHandler` bridge (resize, save, quit, capture).

## Notes

- The UI text is currently in Brazilian Portuguese. Strings are all in `index.html`, so translating is a quick edit.
- The app picks the display that has a notch. If you record with an external webcam on a non-notch monitor, adjust the `screen` property in `Teleprompter.swift`.

## Roadmap

- [ ] 3-2-1 countdown before scrolling
- [ ] Voice-following scroll (speech recognition)
- [ ] Mirror mode for beam-splitter prompters
- [ ] Multiple scripts
- [ ] Remote control from a phone

## License

[MIT](LICENSE)

<!-- Keywords: teleprompter, macos teleprompter, notch, macbook notch, webcam, eye contact, camera, video recording, youtube, content creator, swift, appkit, wkwebview, borderless window, always on top, hidden from screen share, open source -->

# AI Animation Demo

A SwiftUI iOS demo app showcasing AI-inspired loading and status animations — text shimmers, processing labels, and pulsing orb indicators.

## Demos

| Animation | Style | Best for |
|---|---|---|
| **Grok style** | Vibrant blue → purple → pink gradient on bold text | Voice transcription, live streaming status |
| **ChatGPT style** | Monochrome gray gradient sweep, medium subheadline | “Thinking…” / reasoning labels |
| **ShimmeringText** | Base colorful gradient component | General-purpose shimmer text |
| **Analyzing the text** | Pulsing orb with expanding rings | Deep analysis / processing states |
| **Summerizing the text** | Secondary text + soft highlight, 2s sweep with pause | Calm summarization labels |
| **Processing label** | Secondary text + continuous highlight, 1.5s sweep | Active processing / streaming |

## Requirements

- Xcode 15+
- iOS 17.0+
- Swift 5

## Getting started

1. Clone the repository:
   ```bash
   git clone https://github.com/mdo91/AI-Animation-Demo.git
   cd AI-Animation-Demo
   ```
2. Open `AI-Animation-Demo.xcodeproj` in Xcode.
3. Select an iPhone simulator and run (**⌘R**).

## Project structure

```
AI-Animation-Demo/
├── App/                          # App entry point
├── Models/
│   └── AnimationKind.swift       # Demo list + navigation routing
├── Components/
│   ├── Shimmer/
│   │   ├── ShimmeringText.swift  # Reusable shimmer engine
│   │   ├── ChatGPTShimmerText.swift
│   │   └── GrokShimmerText.swift
│   └── Orb/
│       └── PulsingOrb.swift
├── Demos/
│   ├── Shimmer/                  # Individual shimmer demo screens
│   └── Orb/
│       └── PulsingOrbDemoView.swift
└── Views/
    ├── ContentView.swift         # Navigation list
    └── AnimationDemoLayout.swift # Shared demo layout
```

## Usage

### Grok-style shimmer

```swift
GrokShimmerText(text: "Listening and transcribing your voice in real-time...")
```

### ChatGPT-style shimmer

```swift
ChatGPTShimmerText(text: "Thinking…")
```

### Custom shimmer

```swift
ShimmeringText(
    text: "Processing…",
    font: ShimmeringText.activeStatusFont,
    textColor: ShimmeringText.statusLabelColor,
    duration: 1.5,
    repeatDelay: 0
)
```

### Pulsing orb

```swift
PulsingOrb(size: 140)
```

## How the shimmer works

`ShimmeringText` drives animation with `TimelineView` for smooth, jank-free loops:

- **Full-gradient mode** (`textColor: .clear`) — the gradient fills the text glyphs (Grok, ChatGPT, colorful demos).
- **Overlay mode** (base text + highlight band) — secondary label text stays visible while a soft white band sweeps across (Summarizing, Processing).
- **`repeatDelay`** — optional pause between sweeps; the loop rests at the off-text position so transitions stay seamless.

Typography follows iOS HIG conventions: `.subheadline` with `.regular` or `.medium` weight for status labels, `Color.secondary` for muted copy.

## Support (optional)
if you find this repo useful for your future or current projects buy me coffee at [Buy me Coffee](https://buymeacoffee.com/mdo91)

## License

MIT

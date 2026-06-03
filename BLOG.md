# Building AI-Style Loading Animations in SwiftUI: Shimmer Text and Worm Dot Grid

Modern AI apps communicate state with subtle motion: a shimmer across “Thinking…”, a pulsing orb while analyzing, or a dot grid that suggests progress without a traditional spinner. This post breaks down two patterns from the open-source **[AI Animation Demo](https://github.com/mdo91/AI-Animation-Demo)** iOS app — **shimmering text** and a **worm-style dot grid** — and walks through the SwiftUI code that powers them.

**Repository:** https://github.com/mdo91/AI-Animation-Demo

---

## Project overview

The app is a SwiftUI playground: a navigation list of animation demos, each backed by a reusable component. Relevant structure:

```
Components/
├── Shimmer/
│   ├── ShimmeringText.swift      # Core shimmer engine
│   ├── GrokShimmerText.swift     # Vibrant gradient preset
│   └── ChatGPTShimmerText.swift  # Monochrome thinking preset
└── DotGrid/
    └── SequentialDotGrid.swift   # Worm dot loader
```

Both animations use **`TimelineView(.animation)`** instead of `@State` + `withAnimation` loops. That gives frame-accurate timing, avoids visible “snap” at loop boundaries, and keeps motion smooth when the system is under load.

---

## Part 1: Shimmering text animation

### What it looks like

A gradient band sweeps across text. Depending on configuration, the effect can:

- **Fill the glyphs** with a moving gradient (Grok / ChatGPT style)
- **Highlight secondary gray text** with a soft white band (summarizing / processing labels)

### Core idea: mask a moving gradient with text

SwiftUI doesn’t expose CSS-style `background-clip: text`. The equivalent pattern is:

1. Draw `Text` (optionally with a base color)
2. Overlay a `LinearGradient`
3. **Mask** the overlay with identical `Text` so color only appears inside the glyphs

```swift
Text(text)
    .font(font)
    .foregroundColor(textColor)
    .overlay(
        GeometryReader { geometry in
            shimmerGradient(in: geometry, phase: phase)
        }
        .mask(
            Text(text)
                .font(font)
        )
        .blendMode(usesBaseTextColor ? .plusLighter : .normal)
    )
```

- **`textColor: .clear`** → only the gradient is visible (full-fill mode)
- **`textColor: .secondary`** → gray label stays visible; the overlay adds a highlight (overlay mode)
- **`.plusLighter`** → brightens the base text where the highlight passes, instead of replacing it

### Driving animation with `TimelineView`

Instead of resetting `@State` each cycle, phase is computed from the current time:

```swift
TimelineView(.animation) { context in
    let phase = phase(at: context.date)
    // ... render text + gradient at `phase`
}
```

Phase goes from `0 → 1` during the sweep, then holds at `0` during an optional pause:

```swift
private func phase(at date: Date) -> CGFloat {
    let cycleLength = duration + repeatDelay
    let cyclePosition = date.timeIntervalSinceReferenceDate
        .truncatingRemainder(dividingBy: cycleLength)

    guard cyclePosition < duration else { return 0 }

    return CGFloat(cyclePosition / duration)
}
```

**Why hold at `0` during `repeatDelay`?**  
At rest, the highlight band sits off the text. When the next sweep starts, motion continues from the same visual state — no jarring jump from “end position” back to “start position”.

### Two gradient modes

#### Full-fill mode (Grok, ChatGPT)

Used when `textColor == .clear`. A wide gradient slides across the text bounds:

```swift
LinearGradient(
    colors: gradientColors,
    startPoint: .leading,
    endPoint: .trailing
)
.frame(width: width * 3, height: geometry.size.height, alignment: .leading)
.offset(x: -width * 2 + phase * width * 2)
```

The gradient is **3× text width** and offset so it always covers the glyphs during the sweep.

#### Overlay mode (summarizing, processing)

Used when a base text color is set. A **narrow highlight band** travels across:

```swift
let bandWidth = max(width * 0.6, 24)

LinearGradient(
    colors: overlayHighlightColors,  // [.clear, white peak, .clear]
    startPoint: .leading,
    endPoint: .trailing
)
.frame(width: bandWidth, height: geometry.size.height, alignment: .leading)
.offset(x: -bandWidth + phase * (width + bandWidth))
```

At `phase = 0` and `phase = 1`, the band sits fully off the text — so the loop is seamless.

### Preset wrappers

**Grok-style** — bold, colorful, continuous:

```swift
struct GrokShimmerText: View {
    let text: String

    var body: some View {
        ShimmeringText(
            text: text,
            font: ShimmeringText.prominentLabelFont,
            textColor: .clear,
            gradientColors: [.blue, .purple, .pink, .blue],
            duration: 2.0,
            repeatDelay: 0
        )
    }
}
```

**ChatGPT-style** — understated gray sweep on medium subheadline:

```swift
struct ChatGPTShimmerText: View {
    let text: String

    var body: some View {
        ShimmeringText(
            text: text,
            font: ShimmeringText.thinkingLabelFont,
            textColor: .clear,
            gradientColors: [
                ShimmeringText.statusLabelColor,
                ShimmeringText.statusLabelColor.opacity(0.45),
                ShimmeringText.statusLabelColor,
                ShimmeringText.statusLabelColor.opacity(0.45),
                ShimmeringText.statusLabelColor
            ],
            duration: 2.0,
            repeatDelay: 0
        )
    }
}
```

**Summarizing label** — calm, with pause between sweeps:

```swift
ShimmeringText(
    text: "Summerizing the text…",
    font: ShimmeringText.calmStatusFont,
    textColor: ShimmeringText.statusLabelColor,
    duration: ShimmeringText.neutralStatusDuration,      // 2.0s
    repeatDelay: ShimmeringText.neutralStatusRepeatDelay // 0.5s pause
)
```

Typography follows iOS HIG: `.subheadline` with `.regular` or `.medium` weight, `Color.secondary` for muted status copy.

### Shimmer tuning cheat sheet

| Parameter | Effect |
|---|---|
| `duration` | Sweep speed (e.g. 2.0s calm, 1.5s active) |
| `repeatDelay` | Pause between sweeps; `0` = continuous |
| `gradientColors` | Full-fill palette (Grok, ChatGPT) |
| `textColor` | `.clear` = gradient fill; `.secondary` = overlay highlight |
| `font` | Visual hierarchy for the label |

---

## Part 2: Worm dot grid animation

### What it looks like

Nine gray dots in a 3×3 grid. A **black “head”** moves through a custom path; trailing dots fade out like a **worm tail**, then the cycle pauses and restarts.

Grid numbering (animation order 1 → 9):

```
3  2  1
9  8  7
4  5  6
```

So the worm travels: top-right → top-center → top-left → bottom-left → … → middle-left.

### Why not animate each dot independently?

An early version animated one dot at a time: gray → black → fade → gray. That felt choppy, and loop resets were visible.

The worm pattern is better because:

- One **moving head position** drives all dots
- Trailing dots share a **fade curve** based on distance from the head
- Opacity is spatial (distance-based), not per-dot keyframes

This matches common loader patterns where staggered opacity creates a traveling wave.

### Grid layout in code

Serial numbers are stored in row/column order:

```swift
private static let gridSerialNumbers: [[Int]] = [
    [3, 2, 1],
    [9, 8, 7],
    [4, 5, 6]
]
```

Each cell looks up its serial number and asks: *how far am I behind the current head?*

### Timeline-driven head position

```swift
TimelineView(.animation) { context in
    let cyclePosition = context.date.timeIntervalSinceReferenceDate
        .truncatingRemainder(dividingBy: cycleDuration)
    let headPosition = headPosition(for: cyclePosition)

    VStack(spacing: spacing) {
        ForEach(0..<3, id: \.self) { row in
            HStack(spacing: spacing) {
                ForEach(0..<3, id: \.self) { column in
                    let serial = Self.gridSerialNumbers[row][column]
                    dotView(serial: serial, headPosition: headPosition)
                }
            }
        }
    }
}
```

Head position is a continuous float from `0` (at dot 1) to `9` (past dot 9):

```swift
private func headPosition(for cyclePosition: TimeInterval) -> Double? {
    let activeWindow = 9 * dotDuration
    guard cyclePosition < activeWindow else { return nil }
    return cyclePosition / dotDuration
}
```

After the worm completes, `headPosition` is `nil` for the pause period (`pauseBetweenCycles`).

### Rendering each dot: base + overlay

Each dot is a `ZStack` — gray base circle, black overlay with computed opacity:

```swift
private func dotView(serial: Int, headPosition: Double?) -> some View {
    let distance = trailDistance(for: serial, headPosition: headPosition)
    let opacity = overlayOpacity(for: distance)
    let scale = activeScale(for: distance)

    return ZStack {
        Circle()
            .fill(Self.originalGray)

        Circle()
            .fill(.black)
            .opacity(opacity)
            .scaleEffect(scale)
    }
    .frame(width: dotSize, height: dotSize)
}
```

**Important:** opacity is applied to a **black overlay on top of gray**, not by animating the fill color directly. That gives a clean tail fade and avoids muddy intermediate grays.

### Trail distance from the head

```swift
private func trailDistance(for serial: Int, headPosition: Double?) -> Double? {
    guard let headPosition else { return nil }

    let index = Double(serial - 1)
    let distance = headPosition - index
    guard distance >= 0, distance <= trailLength else { return nil }
    return distance
}
```

- `distance == 0` → this dot is the head (full opacity)
- `distance == 1.5` → midway in the tail (partial opacity)
- `distance > trailLength` → not in the worm yet / already faded out

### Opacity and scale curves

```swift
private func overlayOpacity(for distance: Double?) -> Double {
    guard let distance else { return 0 }

    let normalized = max(0, 1 - distance / trailLength)
    return pow(normalized, 1.2)
}

private func activeScale(for distance: Double?) -> CGFloat {
    guard let distance else { return 1.0 }
    let normalized = max(0, 1 - distance / trailLength)
    return 0.94 + CGFloat(normalized) * 0.16
}
```

- **`trailLength`** (default `2.8`) controls worm thickness — how many dots stay lit behind the head
- **`pow(..., 1.2)`** makes the tail fall off slightly faster than linear
- **Scale** gives the head a subtle pop without distracting motion

### Worm tuning cheat sheet

| Parameter | Default | Effect |
|---|---|---|
| `dotSize` | `5` | Dot diameter |
| `spacing` | `5` | Gap between dots |
| `dotDuration` | `0.16` | Time per dot step |
| `trailLength` | `2.8` | Tail length (in dot units) |
| `pauseBetweenCycles` | `0.4` | Rest before restart |

---

## Putting it together in the app

Both components plug into the same demo shell:

```swift
struct SequentialDotGridDemoView: View {
    var body: some View {
        AnimationDemoLayout(
            title: "Sequential dot grid",
            description: "Nine gray dots animate as a worm pattern in order 1→9."
        ) {
            SequentialDotGrid()
                .padding(24)
        }
    }
}
```

The animation list is driven by `AnimationKind`, an enum that maps each demo title to its view — easy to extend with new loaders.

---

## Key takeaways

1. **Mask + gradient overlay** is the SwiftUI equivalent of text shimmer on the web.
2. **`TimelineView`** beats manual animation loops for continuous, seamless motion.
3. **Two shimmer modes** — full gradient fill vs. overlay highlight — cover most AI status label use cases.
4. **Worm loaders** work best with a single traveling head + distance-based opacity tail, not independent per-dot flashes.
5. **Typography matters** — status labels should use `.subheadline` and `Color.secondary`, not headline-sized bold text.

---

## Try it yourself

Clone the repo, run it in Xcode on an iPhone simulator, and browse the animation list:

**https://github.com/mdo91/AI-Animation-Demo**

MIT licensed — reuse the components, tweak timing and colors, or add your own patterns. Contributions welcome.

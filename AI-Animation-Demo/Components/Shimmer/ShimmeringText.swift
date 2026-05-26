//
//  ShimmeringText.swift
//  AI-Animation-Demo
//

import SwiftUI

struct ShimmeringText: View {
    let text: String
    var font: Font = .system(.title2, design: .rounded).weight(.bold)
    var textColor: Color = .clear
    var gradientColors: [Color] = [.blue, .purple, .pink, .blue]
    var duration: TimeInterval = 2.0
    var repeatDelay: TimeInterval = 0

    @Environment(\.colorScheme) private var colorScheme

    private var usesBaseTextColor: Bool {
        textColor != .clear
    }

    var body: some View {
        TimelineView(.animation) { context in
            let phase = phase(at: context.date)

            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .fixedSize(horizontal: false, vertical: true)
                .overlay(
                    GeometryReader { geometry in
                        shimmerGradient(in: geometry, phase: phase)
                    }
                    .mask(
                        Text(text)
                            .font(font)
                            .fixedSize(horizontal: false, vertical: true)
                    )
                    .blendMode(usesBaseTextColor ? .plusLighter : .normal)
                )
        }
    }

    private var overlayHighlightColors: [Color] {
        let peak = colorScheme == .dark
            ? Color.white.opacity(0.35)
        : Color.white.opacity(0.35)
        return [.clear, peak, .clear]
    }

    @ViewBuilder
    private func shimmerGradient(in geometry: GeometryProxy, phase: CGFloat) -> some View {
        let width = geometry.size.width

        if usesBaseTextColor {
            let bandWidth = max(width * 0.6, 24)

            LinearGradient(
                colors: overlayHighlightColors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: bandWidth, height: geometry.size.height, alignment: .leading)
            .offset(x: -bandWidth + phase * (width + bandWidth))
        } else {
            LinearGradient(
                colors: gradientColors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: width * 3, height: geometry.size.height, alignment: .leading)
            .offset(x: -width * 2 + phase * width * 2)
        }
    }

    /// Returns 0→1 during the sweep, then holds at 0 during `repeatDelay` (rest position).
    private func phase(at date: Date) -> CGFloat {
        let cycleLength = duration + repeatDelay
        guard cycleLength > 0 else { return 0 }

        let cyclePosition = date.timeIntervalSinceReferenceDate
            .truncatingRemainder(dividingBy: cycleLength)

        guard cyclePosition < duration else { return 0 }

        return CGFloat(cyclePosition / duration)
    }
}

extension ShimmeringText {
    // MARK: - UX-aligned typography (iOS HIG + AI app conventions)

    /// Secondary status copy — adapts to light/dark mode (`secondaryLabel`).
    static let statusLabelColor = Color.secondary

    /// Calm, low-emphasis labels (e.g. summarizing). Subheadline + regular.
    static let calmStatusFont: Font = .subheadline.weight(.regular)

    /// Active processing labels. Subheadline + medium (ChatGPT-style emphasis).
    static let activeStatusFont: Font = .subheadline.weight(.medium)

    /// AI “thinking” labels. Subheadline + medium, matches ChatGPT token weight.
    static let thinkingLabelFont: Font = .subheadline.weight(.medium)

    /// Prominent streaming labels (Grok-style). Headline + semibold, rounded.
    static let prominentLabelFont: Font = .system(.headline, design: .rounded).weight(.semibold)

    /// Adaptive highlight for overlay shimmer on secondary status text.
    static let statusHighlightColors: [Color] = [
        .clear,
        Color.white.opacity(0.1),
        .clear
    ]

    static let neutralStatusTextColor = statusLabelColor
    static let neutralStatusGradientColors = statusHighlightColors
    static let neutralStatusDuration: TimeInterval = 2.0
    static let neutralStatusRepeatDelay: TimeInterval = 0.5
    static let processingLabelDuration: TimeInterval = 1.5
    static let processingLabelRepeatDelay: TimeInterval = 0
}

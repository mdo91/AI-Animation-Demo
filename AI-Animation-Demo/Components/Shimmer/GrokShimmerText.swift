//
//  GrokShimmerText.swift
//  AI-Animation-Demo
//

import SwiftUI

/// Grok-style label: vibrant blue → purple → pink gradient on semibold rounded headline.
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

#Preview {
    GrokShimmerText(text: "Listening and transcribing your voice in real-time...")
        .padding()
}

//
//  ChatGPTShimmerText.swift
//  AI-Animation-Demo
//

import SwiftUI

/// ChatGPT-style thinking label: secondary gray, medium subheadline, monochrome gradient sweep.
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

#Preview {
    ChatGPTShimmerText(text: "Thinking…")
        .padding()
}

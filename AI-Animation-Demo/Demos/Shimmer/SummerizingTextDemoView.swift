//
//  SummerizingTextDemoView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct SummerizingTextDemoView: View {
    var body: some View {
        AnimationDemoLayout(
            title: "Summerizing the text",
            description: "Secondary subheadline (regular weight) with a soft adaptive highlight — calm, low-emphasis status text per iOS HIG."
        ) {
            ShimmeringText(
                text: "Summerizing the text…",
                font: ShimmeringText.calmStatusFont,
                textColor: ShimmeringText.statusLabelColor,
                gradientColors: ShimmeringText.statusHighlightColors,
                duration: ShimmeringText.neutralStatusDuration,
                repeatDelay: ShimmeringText.neutralStatusRepeatDelay
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        SummerizingTextDemoView()
    }
}

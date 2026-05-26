//
//  ProcessingLabelDemoView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct ProcessingLabelDemoView: View {
    var body: some View {
        AnimationDemoLayout(
            title: "Processing label",
            description: "Subheadline at medium weight — slightly more emphasis for active processing, following ChatGPT-style label conventions."
        ) {
            ShimmeringText(
                text: "Processing…",
                font: ShimmeringText.activeStatusFont,
                textColor: ShimmeringText.statusLabelColor,
                gradientColors: ShimmeringText.statusHighlightColors,
                duration: ShimmeringText.processingLabelDuration,
                repeatDelay: ShimmeringText.processingLabelRepeatDelay
            )
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        ProcessingLabelDemoView()
    }
}

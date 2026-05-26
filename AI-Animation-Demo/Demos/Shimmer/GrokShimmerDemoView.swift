//
//  GrokShimmerDemoView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct GrokShimmerDemoView: View {
    var body: some View {
        AnimationDemoLayout(
            title: "Grok style",
            description: "Semibold rounded headline with a vibrant gradient fill — prominent enough for streaming voice status without overpowering the UI."
        ) {
            GrokShimmerText(text: "Listening and transcribing your voice in real-time...")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        GrokShimmerDemoView()
    }
}

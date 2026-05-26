//
//  ShimmeringTextDemoView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct ShimmeringTextDemoView: View {
    var body: some View {
        AnimationDemoLayout(
            title: "ShimmeringText",
            description: "The base shimmering component with a colorful gradient sweep. Useful for loading or live-transcription states."
        ) {
            ShimmeringText(text: "Listening and transcribing your voice in real-time...")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        ShimmeringTextDemoView()
    }
}

//
//  ChatGPTShimmerDemoView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct ChatGPTShimmerDemoView: View {
    var body: some View {
        AnimationDemoLayout(
            title: "ChatGPT style",
            description: "Medium-weight subheadline with a monochrome secondary gray sweep — matches ChatGPT’s understated “Thinking…” label."
        ) {
            ChatGPTShimmerText(text: "Thinking…")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        ChatGPTShimmerDemoView()
    }
}

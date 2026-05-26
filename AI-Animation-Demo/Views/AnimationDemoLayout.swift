//
//  AnimationDemoLayout.swift
//  AI-Animation-Demo
//

import SwiftUI

struct AnimationDemoLayout<Content: View>: View {
    let title: String
    let description: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            content()

            Text(description)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

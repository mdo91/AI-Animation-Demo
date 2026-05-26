//
//  PulsingOrbDemoView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct PulsingOrbDemoView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            PulsingOrb(size: 140)
                .frame(width: 240, height: 240)

            Text("Analyzing the text…")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            Text("A glowing sphere with concentric rings expanding outward — a friendly way to communicate that the AI is processing.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
        }
        .navigationTitle("Analyzing the text")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PulsingOrbDemoView()
    }
}

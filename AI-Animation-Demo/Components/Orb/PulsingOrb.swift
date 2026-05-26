//
//  PulsingOrb.swift
//  AI-Animation-Demo
//

import SwiftUI

struct PulsingOrb: View {
    var size: CGFloat = 140

    @State private var isAnimating = false

    private let gradientColors: [Color] = [.blue, .purple, .pink]

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: size, height: size)
                    .scaleEffect(isAnimating ? 1.6 : 0.75)
                    .opacity(isAnimating ? 0 : 0.7)
                    .animation(
                        .easeOut(duration: 2.4)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.8),
                        value: isAnimating
                    )
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, Color.blue.opacity(0.9), .purple],
                        center: UnitPoint(x: 0.35, y: 0.3),
                        startRadius: 4,
                        endRadius: size * 0.7
                    )
                )
                .frame(width: size, height: size)
                .shadow(color: .purple.opacity(0.45), radius: 30)
                .shadow(color: .blue.opacity(0.35), radius: 15)
                .scaleEffect(isAnimating ? 1.06 : 0.94)
                .animation(
                    .easeInOut(duration: 1.6).repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
        .onAppear { isAnimating = true }
    }
}

#Preview {
    PulsingOrb()
        .padding(60)
}

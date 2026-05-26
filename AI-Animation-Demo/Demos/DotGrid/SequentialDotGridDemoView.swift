//
//  SequentialDotGridDemoView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct SequentialDotGridDemoView: View {
    var body: some View {
        AnimationDemoLayout(
            title: "Sequential dot grid",
            description: """
            Nine gray dots in a 3×3 grid animate as a worm pattern in order 1→9.
            A black head moves through the path while trailing dots fade by opacity,
            then the cycle pauses and restarts.

            Grid numbering:
            3  2  1
            9  8  7
            4  5  6
            """
        ) {
            SequentialDotGrid()
                .padding(24)
        }
    }
}

#Preview {
    NavigationStack {
        SequentialDotGridDemoView()
    }
}

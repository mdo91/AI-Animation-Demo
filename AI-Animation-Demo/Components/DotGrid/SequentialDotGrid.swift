//
//  SequentialDotGrid.swift
//  AI-Animation-Demo
//

import SwiftUI

/// A 3×3 grid of dots animated in serial order 1→9.
///
/// Grid layout (serial numbers):
/// ```
/// 3  2  1
/// 9  8  7
/// 4  5  6
/// ```
struct SequentialDotGrid: View {
    var dotSize: CGFloat = 5
    var spacing: CGFloat = 5
    var dotDuration: TimeInterval = 0.16
    var pauseBetweenCycles: TimeInterval = 0.4
    var trailLength: Double = 2.8

    private static let gridSerialNumbers: [[Int]] = [
        [3, 2, 1],
        [9, 8, 7],
        [4, 5, 6]
    ]

    private static let originalGray = Color(white: 0.78)

    private var cycleDuration: TimeInterval {
        9 * dotDuration + pauseBetweenCycles
    }

    var body: some View {
        TimelineView(.animation) { context in
            let cyclePosition = context.date.timeIntervalSinceReferenceDate
                .truncatingRemainder(dividingBy: cycleDuration)
            let headPosition = headPosition(for: cyclePosition)

            VStack(spacing: spacing) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<3, id: \.self) { column in
                            let serial = Self.gridSerialNumbers[row][column]
                            dotView(
                                serial: serial,
                                headPosition: headPosition
                            )
                        }
                    }
                }
            }
        }
    }

    private func dotView(serial: Int, headPosition: Double?) -> some View {
        let distance = trailDistance(for: serial, headPosition: headPosition)
        let opacity = overlayOpacity(for: distance)
        let scale = activeScale(for: distance)

        return ZStack {
            Circle()
                .fill(Self.originalGray)

            Circle()
                .fill(.black)
                .opacity(opacity)
                .scaleEffect(scale)
        }
        .frame(width: dotSize, height: dotSize)
    }

    private func headPosition(for cyclePosition: TimeInterval) -> Double? {
        let activeWindow = 9 * dotDuration
        guard cyclePosition < activeWindow else { return nil }
        return cyclePosition / dotDuration
    }

    private func trailDistance(for serial: Int, headPosition: Double?) -> Double? {
        guard let headPosition else { return nil }

        // Serial order is the animation path: 1 → 2 → ... → 9
        let index = Double(serial - 1)
        let distance = headPosition - index
        guard distance >= 0, distance <= trailLength else { return nil }
        return distance
    }

    private func overlayOpacity(for distance: Double?) -> Double {
        guard let distance else { return 0 }

        // Worm pattern: strong head + fading tail.
        let normalized = max(0, 1 - distance / trailLength)
        return pow(normalized, 1.2)
    }

    private func activeScale(for distance: Double?) -> CGFloat {
        guard let distance else { return 1.0 }
        let normalized = max(0, 1 - distance / trailLength)
        return 0.94 + CGFloat(normalized) * 0.16
    }
}

#Preview {
    SequentialDotGrid()
        .padding(40)
}

//
//  AnimationKind.swift
//  AI-Animation-Demo
//

import SwiftUI

enum AnimationKind: String, Identifiable, CaseIterable, Hashable {
    case grokStyle = "Grok style"
    case chatGPTStyle = "ChatGPT style"
    case shimmeringText = "ShimmeringText"
    case analyzingTheText = "Analyzing the text"
    case summerizingTheText = "Summerizing the text"
    case processingLabel = "Processing label"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .grokStyle: "wand.and.stars"
        case .chatGPTStyle: "bubble.left.and.bubble.right"
        case .shimmeringText: "sparkles"
        case .analyzingTheText: "circle.hexagongrid.fill"
        case .summerizingTheText: "doc.text"
        case .processingLabel: "arrow.triangle.2.circlepath"
        }
    }

    @ViewBuilder
    var demoView: some View {
        switch self {
        case .grokStyle:
            GrokShimmerDemoView()
        case .chatGPTStyle:
            ChatGPTShimmerDemoView()
        case .shimmeringText:
            ShimmeringTextDemoView()
        case .analyzingTheText:
            PulsingOrbDemoView()
        case .summerizingTheText:
            SummerizingTextDemoView()
        case .processingLabel:
            ProcessingLabelDemoView()
        }
    }
}

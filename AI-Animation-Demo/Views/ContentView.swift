//
//  ContentView.swift
//  AI-Animation-Demo
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List(AnimationKind.allCases) { kind in
                NavigationLink(value: kind) {
                    Label(kind.rawValue, systemImage: kind.symbol)
                }
            }
            .navigationTitle("Animations")
            .navigationDestination(for: AnimationKind.self) { kind in
                kind.demoView
            }
        }
    }
}

#Preview {
    ContentView()
}

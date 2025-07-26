//
//  ContentView.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-16.
//




import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TimelineViewModel
    @State private var timelineWidth: CGFloat = 1000
    var body: some View {
        Text("Agar Haptic Studio")
            .font(.title)
            .bold(true)
            .foregroundStyle(Color.gray)
            .padding(.bottom, 0)
        VStack {
            TimelineEditorView(timelineWidth: $timelineWidth)
                .padding(0)
            Slider(value: $timelineWidth, in: 500...2000)
                .padding(.horizontal)
                .frame(width: 300)
            Text("Adjust Timeline width")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.top, 0)
        .padding(.horizontal)
        .ignoresSafeArea(edges: [.trailing ])
    }
}

#Preview {
    ContentView()
        .environmentObject(TimelineViewModel())
}


///
/// 1: 56.8 - 142
/// 2: 56.8 - 85
/// 3: 37.9 - 56 
/// 4: 28.4 - 43

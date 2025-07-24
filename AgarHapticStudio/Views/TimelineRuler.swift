//
//  TimelineRuler.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-22.
//

import SwiftUI

struct TimelineRuler: View {
    @EnvironmentObject var viewModel: TimelineViewModel
    let timelineWidth: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: timelineWidth + 2, height: viewModel.rulerHeight)
                .position(CGPoint(x: timelineWidth/2, y: viewModel.rulerHeight/2))
                .padding(0)
            
            // Markers
            ForEach(0..<Int(viewModel.timelineDuration / viewModel.rulerInterval), id: \.self) { i in
                let x = CGFloat(Double(i) * viewModel.rulerInterval / viewModel.timelineDuration) * timelineWidth
                //
                if i % 10 == 0 && viewModel.showMajorDenote {
                    rulerMajorDenote(rulerHeight: viewModel.rulerHeight, x: x, showTime: true, time: formatTime(Double(i/10)))
                } else if (i % 5 == 0 || i % 10 == 0) && viewModel.showMinorDenote {
                    rulerMinorDenote(rulerHeight: viewModel.rulerHeight, x: x)
                } else {
                    rulerMarker(rulerHeight: viewModel.rulerHeight, x: x)
                }
                
            }
        }
    }
}


struct rulerMarker: View {
    var rulerHeight: CGFloat
    var x: CGFloat
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(width: 1, height: rulerHeight/4)
            .position(x: x, y: rulerHeight-(rulerHeight/4)/2)
    }
}

struct rulerMinorDenote: View {
    let rulerHeight: CGFloat
    var x: CGFloat
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(width: 2, height: rulerHeight/3)
            .position(x: x, y: rulerHeight-(rulerHeight/3)/2)
    }
}

struct rulerMajorDenote: View {
    let rulerHeight: CGFloat
    var x: CGFloat
    let showTime: Bool
    let time: String
    var body: some View {
        Group {
            VStack(spacing: 0) {
                Spacer()
                if showTime {
                    Text("\(time)")
                        .font(.caption)
                        .foregroundStyle(Color.gray.mix(with: .black, by: 0.2))
                }
                Rectangle()
                    .fill(Color.gray.mix(with: .black, by: 0.2))
                    .frame(width: 2, height: rulerHeight/2.5)
                Spacer()
            }
        }
        .position(x: x, y: rulerHeight-(rulerHeight/2.5))
    }
}

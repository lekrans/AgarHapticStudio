//
//  TimelineGrid.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-22.
//

import SwiftUI


struct gridMajorDenote: View {
    let timelineHeight: CGFloat
    let x: CGFloat
    var body: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.5))
            .frame(width: 2)
            .position(x: x, y: timelineHeight / 2)
    }
}

struct gridMinorDenote: View {
    let timelineHeight: CGFloat
    let x: CGFloat
    var body: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.35))
            .frame(width: 1.5)
            .position(x: x, y: timelineHeight / 2)
    }
}

struct gridDenote: View {
    let timelineHeight: CGFloat
    let x: CGFloat
    var body: some View {
        Rectangle()
            .fill(Color.blue.opacity(0.3))
            .frame(width: 1)
            .position(x: x, y: timelineHeight / 2)
    }
}


/// Grid overlay for the timeline
///
/// This is the vertical lines that divides the timeline for ease of reading
struct TimelineGrid: View {
    @EnvironmentObject var viewModel: TimelineViewModel
    
    /// The width of the timeline that encompass this grid. For calculating the positions of the gridlines
    let timelineWidth: CGFloat
    /// The height of the timeline that encompass this grid. For calculating the height of the gridlines
    let totalHeight: CGFloat
    let milliSec: CGFloat = 0.1
    
    var body: some View {
        
        // the normal gridlines
        ForEach(0..<Int(viewModel.timelineDuration/milliSec), id: \.self) { i in
            // gridInterval
            let secInterval = i % 10 == 0
            let halfSecInterval = i % 5 == 0
            let gridInterval = i % Int(viewModel.gridInterval * 10) == 0
            let x = CGFloat(Double(i) * milliSec / viewModel.timelineDuration) * timelineWidth
            
            if secInterval {
                gridMajorDenote(timelineHeight: totalHeight, x: x)
            } else if halfSecInterval {
                gridMinorDenote(timelineHeight: totalHeight, x: x)
            } else if gridInterval {
                gridDenote(timelineHeight: totalHeight, x: x)
            }
        }
    }
}

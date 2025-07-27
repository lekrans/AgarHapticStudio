//
//  TrackView.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-17.
//

import SwiftUI

/// Container for the different tracks heights
struct TimelineTrackHeights {
    let animationHeight: CGFloat
    let hapticTrackHeight: CGFloat
    let soundTrackHeight: CGFloat
}


/// A single track 
struct TrackView: View {
    @EnvironmentObject var viewModel: TimelineViewModel

    /// The data part 
    let track: TimelineTrack
    let timelineWidth: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background based on track type
            backgroundColor
                .frame(height: height)
//                .alignmentGuide(.bottom) { d in d[VerticalAlignment.bottom] }
                .overlay(
                    Rectangle()
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                )

                if let event = viewModel.event(for: track) {
                    DraggableEventView(
                        event: Binding(
                            get: { event },
                            set: { viewModel.eventsByTrack[track.id] = $0 }
                        ),
                        timelineWidth: timelineWidth,
                        allEvents: viewModel.eventsByTrack.values.map { $0 },
                        trackId: track.id,
                        trackHeight: height
                    )
                    //                .frame(height: height)
                    .alignmentGuide(.bottom) { d in d[VerticalAlignment.bottom] + 1 }
                    .padding(.leading, 0)
                }
                
            // Optional Label
            HStack {
                Text(track.type == .haptic ? "Haptic Track:" : "Sound Track:")
                    .font(.caption)
                    .foregroundColor(track.type == .haptic ? .blue.mix(with: .white, by: 0.5) : .green.mix(with: .white, by: 0.5))
                    .padding(4)
                Text(track.name)
                    .font(.caption)
                    .foregroundColor(track.type == .haptic ? .blue.mix(with: .white, by: 0.7) : .green.mix(with: .white, by: 0.7))
                    .padding(.vertical, 4)
            }
            .alignmentGuide(.bottom) { d in d[VerticalAlignment.bottom] + height - d.height } // Move the text from bottom aligned to be aligned at the top (if we don't remove it's own height (the text height) it will be positioned above the track
        }
        
    }
    
    private var backgroundColor: Color {
        switch track.type {
        case .haptic: return Color.blue.opacity(0.1)
        case .sound: return Color.green.opacity(0.1)
        case .animation: return Color.yellow.opacity(0.1)
        }
    }
}






#Preview {
    let viewModel = TimelineViewModel()
    
    TrackView(track: viewModel.tracks.first!, timelineWidth: 1000, height: 100)
        .environmentObject(viewModel)
}




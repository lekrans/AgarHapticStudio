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
        ZStack(alignment: .topLeading) {
            // Background based on track type
            backgroundColor
                .frame(height: height)
                .overlay(
                    Rectangle()
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                )
            
            // Draggable Events
//            ForEach(track.events) { event in
//                DraggableEventView(
//                    event: .constant(event), // Replace with real binding when needed
//                    totalDuration: 1.5, // You can pass this from the model
//                    timelineWidth: timelineWidth,
//                    allEvents: track.events
//                )
//                .frame(height: height * 0.8)
//            }
            
            if let event = viewModel.event(for: track) {
//                Print("found event")
                DraggableEventView(
                    event: Binding(
                        get: { event },
                        set: { viewModel.eventsByTrack[track.id] = $0 }
                    ),
                    totalDuration: viewModel.timelineDuration,
                    timelineWidth: timelineWidth,
                    allEvents: viewModel.eventsByTrack.values.map { $0 },
                    trackId: track.id,
                    trackHeight: height
                )
                .position(x: 0, y: height/2)
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

//TrackView(track: .init(id: .init(), type: .sound, name: ""), timelineWidth: 400, height: 100)
//    .environmentObject(TimelineViewModel())

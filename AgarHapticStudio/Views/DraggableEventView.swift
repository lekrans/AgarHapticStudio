//
//  DraggableEventView.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-16.
//

import SwiftUI

struct DraggableEventView: View {
    @EnvironmentObject var viewModel: TimelineViewModel
    @Binding var event: TimelineEvent
    var totalDuration: TimeInterval
    var timelineWidth: CGFloat
    var allEvents: [TimelineEvent]
    var trackId: UUID
    var trackHeight: CGFloat
    
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        let denormalizedDuration = CGFloat(event.normalizedDuration * totalDuration)
        let denormalizedStartTime = totalDuration * event.normalizedStartTime
        let eventWidth: CGFloat = timelineWidth / totalDuration * denormalizedDuration
//        let startOffsetX: CGFloat = timelineWidth/totalDuration * CGFloat(denormalizedStartTime) + eventWidth/2 + dragOffset
        let startOffsetX: CGFloat = timelineWidth/totalDuration * CGFloat(denormalizedStartTime)

        TimelineEventBlockView(event: event, timelineWidth: timelineWidth, totalDuration: totalDuration, trackHeight: trackHeight)
            .offset(x: startOffsetX)
//            .frame(width: eventWidth, height: trackHeight * 0.8, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let delta = value.translation.width / timelineWidth * totalDuration
                        let denormalizedStartTime = totalDuration * event.normalizedStartTime
                        var newTime = denormalizedStartTime + delta
                        viewModel.moveEvent(in:trackId, to: newTime)
                        event.normalizedStartTime = newTime / totalDuration
                        dragOffset = 0
                    }
            )
            .animation(.easeOut(duration: 0.2), value: dragOffset)
    }
}

func snapToGrid(_ value: TimeInterval, interval: TimeInterval) ->
TimeInterval {
    //        Print("in SnapToGrid")
    let timeValue = value / interval
    let roundedTimeValue = timeValue.rounded()
    let diff = abs(timeValue - roundedTimeValue)
    let newValue = diff < 0.15 ? roundedTimeValue : timeValue
    return newValue * interval
}

func snapToNearbyEvent(
    _ value: TimeInterval,
    allEvents: [TimelineEvent],
    currentEvent: TimelineEvent,
    margin: TimeInterval = 0.05
) -> TimeInterval {
    let others = allEvents.filter { $0.id != currentEvent.id }
    for other in others {
        if abs(other.normalizedStartTime - value) < margin {
            return other.normalizedStartTime
        }
    }
    return value
}



#Preview {
    @Previewable @State var event1 = TimelineEvent(type: .sound(name: "noname", fileLength: 1.0),label: "Test", normalizedStartTime: 0, normalizedDuration: 0.5)
    var viewModel = TimelineViewModel()
    DraggableEventView(event: $event1, totalDuration: 5.0, timelineWidth: 1000, allEvents: [], trackId: viewModel.tracks[0].id, trackHeight: 50)
        .environmentObject(viewModel)
}

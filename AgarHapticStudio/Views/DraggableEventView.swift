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
    var timelineWidth: CGFloat
    var allEvents: [TimelineEvent]
    var trackId: UUID
    var trackHeight: CGFloat
    var realDuration: CGFloat {
        CGFloat(event.normalizedDuration * viewModel.timelineDuration)
    }
    
    var realStartTime: TimeInterval {
        viewModel.timelineDuration * event.normalizedStartTime
    }
    
    var durationOffsetX: CGFloat {
        timelineWidth/viewModel.timelineDuration * CGFloat(realDuration) - durationOffset
    }
    
    var startOffsetX: CGFloat {
        timelineWidth/viewModel.timelineDuration * CGFloat(realStartTime) + dragOffset
    }
    
    var realWidth: CGFloat {
        timelineWidth/viewModel.timelineDuration * CGFloat(realDuration)
    }
    
    @State private var dragOffset: CGFloat = 0
    @State private var durationOffset: CGFloat = 0
    
    var body: some View {
//        HStack {
//            Rectangle()
//                .frame(width: 10, height: trackHeight)
//                .gesture(leftResizeGesture)
            
            TimelineEventBlockView(event: event, timelineWidth: timelineWidth, totalDuration: viewModel.timelineDuration, trackHeight: trackHeight)
//            Rectangle()
//                .frame(width: 10, height: trackHeight)
//        }
        .offset(x: startOffsetX)
        .frame(width: realWidth)
        .gesture( eventMoveGesture )
        .animation(.easeOut(duration: 0.2), value: dragOffset)
        .onAppear {
            print("startOffsetX \(startOffsetX)")
            print("timelineWidth \(timelineWidth)")
            print("timelineDuration \(viewModel.timelineDuration)")
            print("realDuration \(realDuration)")
            print("realWidth: \(realWidth)")
        }

    }
    
    
    var eventMoveGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let delta = value.translation.width / timelineWidth * viewModel.timelineDuration
                let newTime = realStartTime + delta
                viewModel.moveEvent(in:trackId, to: newTime)
                event.normalizedStartTime = newTime / viewModel.timelineDuration
                dragOffset = 0
            }
    }
    
    var leftResizeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                durationOffset = value.translation.width
//                dragOffset = value.translation.width
//                let delta = value.translation.width / timelineWidth * totalDuration
//                print("delta \(delta), value.translation.width \(value.translation.width)")
//                let newStart = max(0, event.normalizedStartTime + delta)
//                let newDuration = event.normalizedDuration - delta
                let newDuration = durationOffsetX
                print("newDuration \(newDuration)")
                guard newDuration > 0 else { return }
                viewModel.changeDuration(of: &event, to: newDuration)
//                event.normalizedStartTime = newStart
//                event.normalizedDuration = newDuration
//                viewModel.addEvent(event, to: trackId)
                
            }
            .onEnded { value in
                dragOffset = 0
                durationOffset = 0
            }
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
    @Previewable @State var event1 = TimelineEvent(type: .sound(name: "noname", fileLength: 1.0),label: "Test", normalizedStartTime: 0, normalizedDuration: 0.1)
    var viewModel = TimelineViewModel()
    DraggableEventView(event: $event1, timelineWidth: 1000, allEvents: [], trackId: viewModel.tracks[0].id, trackHeight: 50)
        .environmentObject(viewModel)
}

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
    
    var height: CGFloat {
        trackHeight * 0.8
    }
    
    @State private var isRightTouched: Bool = false
    @State private var isLeftTouched: Bool = false

    @State private var dragOffset: CGFloat = 0
    @State private var durationOffset: CGFloat = 0
    
    var body: some View {
        ZStack() {
            
            TimelineEventBlockView(event: event, timelineWidth: timelineWidth, totalDuration: viewModel.timelineDuration, trackHeight: height)
                .padding(0)
                .cornerRadius(5)

            
            HStack(spacing: 0) { // Right handle
                Spacer()
                Rectangle()
                    .padding(0)
                    .frame(width: 10, height: height)
                    .border(Color.red)
                    .opacity(isRightTouched ? 0.7 : 0.1)
                    .shadow(radius: 5)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isRightTouched { isRightTouched = true }
                        }
                        .onEnded { _ in
                            isRightTouched = false
                        })
                    .simultaneousGesture(rightResizeGesture)
            }
            .frame(width: realWidth)
            .cornerRadius(5)

            HStack(spacing: 0) {
                Rectangle()
                    .padding(0)
                    .frame(width: 10, height: height)
                    .border(Color.red)
                    .opacity(isLeftTouched ? 0.7 : 0.1)
                    .shadow(radius: 5)
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isLeftTouched { isLeftTouched = true }
                        }
                        .onEnded { _ in
                            isLeftTouched = false
                        })
                    .simultaneousGesture(leftResizeGesture)
                    .animation(.easeOut(duration: 0.2), value: dragOffset)

                Spacer()
            }
            .frame(width: realWidth)
            .cornerRadius(5)
        }
        .offset(x: startOffsetX)
//        .cornerRadius(5)
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
                print("in leftResizeGesture change")
                
            }
            .onEnded { value in
                print("In leftResizeGesture end")
                dragOffset = 0
                durationOffset = 0
            }
    }
    
    var rightResizeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                
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

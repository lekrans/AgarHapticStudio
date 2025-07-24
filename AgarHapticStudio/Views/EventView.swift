//
//  EventView.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-16.
//

import SwiftUI

struct EventView: View {
    @Binding var event: TimelineEvent
    var totalDuration: TimeInterval
    var timelineWidth: CGFloat
    var allEvents: [TimelineEvent]
    
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        let xPos = CGFloat(event.normalizedStartTime / totalDuration) * timelineWidth + dragOffset
        
        return Circle()
            .fill(Color.blue)
            .frame(width: 24, height: 24)
            .overlay(Text(event.label.prefix(1)).foregroundColor(.white))
            .position(x: xPos, y: 40)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let delta = value.translation.width / timelineWidth * totalDuration
                        var newTime = event.normalizedStartTime + delta
                        newTime = snapToNearbyEvent(newTime, allEvents: allEvents, currentEvent: event)
                        newTime = snapToGrid(newTime, interval: 0.1)
                        newTime = max(0, min(totalDuration, newTime)) // clamp
                        event.normalizedStartTime = newTime
                        dragOffset = 0
                    }
            )
    }
    
    func snapToGrid(_ value: TimeInterval, interval: TimeInterval) -> TimeInterval {
        let timeValue = value / interval
        let roundedTimeValue = timeValue.rounded()
        
        return roundedTimeValue * interval
        // (value / interval).rounded() * interval
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

}

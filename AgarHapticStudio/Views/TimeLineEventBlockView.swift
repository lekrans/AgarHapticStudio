//
//  TimeLineEventBlockView.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-16.
//

import SwiftUI

struct TimelineEventBlockView: View {
    let event: TimelineEvent
    let timelineWidth: CGFloat
    let totalDuration: TimeInterval
    let trackHeight: CGFloat
    var height: CGFloat {
        trackHeight * 0.9
    }
    
    var body: some View {
//        let x = CGFloat(event.normalizedStartTime / totalDuration) * timelineWidth
        let width = timelineWidth / CGFloat(event.normalizedDuration * totalDuration)
        
        return Group {
            switch event.type {
            case .haptic(_, _):
                Text("H")
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(width: width, height: height)
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(5)
//                    .position(x: x + width / 2, y: 0)
                
            case .sound(let name, _):
                Text(name)
                    .font(.caption2)
                    .foregroundColor(.black)
                    .frame(width: width, height: height)
                    .background(Color.orange.opacity(0.8))
                    .cornerRadius(5)
//                    .position(x: x + width / 2, y: 0)
            }
        }
    }
}

#Preview {
    let hapticEvent = TimelineEvent.init(type: .haptic(intensity: 0.5, sharpness: 0.5), label: "Haptic1", normalizedStartTime: 0, normalizedDuration: 2)
    let soundEvent = TimelineEvent.init(type: .sound(name: "rumble.wav", fileLength: 3.2),label: "Sound1", normalizedStartTime: 0, normalizedDuration: 0.5)
//    VStack {
//        TimelineEventBlockView(event: hapticEvent, timelineWidth: 400, totalDuration: 10, trackHeight: 40)
        TimelineEventBlockView(event: soundEvent, timelineWidth: 1000, totalDuration: 5, trackHeight: 56)
//    }
}
    



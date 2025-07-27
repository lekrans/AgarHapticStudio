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
        trackHeight * 0.8
    }
    
    var body: some View {
        let widthPerSecond: CGFloat = (timelineWidth/totalDuration)
        let realDuration: CGFloat = totalDuration * event.normalizedDuration
        let width = widthPerSecond * realDuration
        
        ZStack {
                
                HStack {
                    Rectangle()
                        .frame(width: 10, height: height)
                    Spacer()
                    Rectangle()
                        .frame(width: 10, height: height)
                }
                .frame(width: width, height: height)
            
            switch event.type {
            case .haptic(_, _):
                Text("H")
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(width: width, height: height)
                    .background(Color.blue.opacity(0.8))
                //                .cornerRadius(5)
                
            case .sound(let name, _):
                Text(name)
                    .font(.caption2)
                    .foregroundColor(.black)
                    .frame(width: width, height: height)
                    .background(Color.orange.opacity(0.8))
                //                .cornerRadius(5)
            }

        }
        .cornerRadius(5)

    }
}

#Preview {
    let hapticEvent = TimelineEvent.init(type: .haptic(intensity: 0.5, sharpness: 0.5), label: "Haptic1", normalizedStartTime: 0, normalizedDuration: 2)
    let soundEvent = TimelineEvent.init(type: .sound(name: "rumble.wav", fileLength: 3.2),label: "Sound1", normalizedStartTime: 0, normalizedDuration: 0.1)
    TimelineEventBlockView(event: soundEvent, timelineWidth: 1000, totalDuration: 5, trackHeight: 56)
}




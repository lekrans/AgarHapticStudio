//
//  TimeLineEvent.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-16.
//

import Foundation


/// Specifies the different event types that can appear on the timeline: haptic, sound (and coming: Animation)
enum TimelineEventType {
    /// A tactile feedback
    case haptic(intensity: Float = 1.0, sharpness: Float = 1.0)
    /// A sound
    case sound(name: String = "unknown.unknown", fileLength: TimeInterval = 1.0)
}



/// A Timeline event, one entity in the timeline e.g a haptic event, a sound, an animation
///
/// This is the equivalent to the NormalizedHapticEvent in AgarCoreKit
struct TimelineEvent: Identifiable, Equatable {
    static func == (lhs: TimelineEvent, rhs: TimelineEvent) -> Bool {
        lhs.id == rhs.id
    }
    /// A unique id
    var id = UUID()
    
    /// The event type, e.g haptic, sound, animation
    var type: TimelineEventType
    /// The description of the event, visible in the Timeline
    var label:String
    /// The normalized startTime, used to get the real startTime based on the encompassing Timeline's total duration
    var normalizedStartTime: TimeInterval
    /// The relative duration of the event
    var normalizedDuration: TimeInterval
    
    
    static func defaultEvent(of type:TimelineEventType) -> TimelineEvent {
        switch type {
        case .haptic:
            return TimelineEvent(
                type: type,
                label: "Default Haptic",
                normalizedStartTime: 0.2,
                normalizedDuration: 0.5
            )
        case .sound:
            return TimelineEvent(
                type: type,
                label: "Default Sound",
                normalizedStartTime: 0,
                normalizedDuration: 0.5
            )
        }
    }
}

/// NOTE!!!! CONTINUE WITH SPECIFYING START AND ENDTIME'S
/// NEED A STRATEGY WHEN DESIGNING THE EVENT..
/// 1) We have a timeline length in sec (like 5 sec) then we specify events that get's their relativeTime and duration based on that 5 sec (and if an event exceed the 5 sec we need to add to the timeline length and recalculate all existing events)
/// When everything is done and we store the "package" we need to get the max length of the soundHaptic event (find the haptic/sound/animation event with the highest end time.. this will be the NEW timeline length and all events are normalized against that value (and we need to store the length somewhere)

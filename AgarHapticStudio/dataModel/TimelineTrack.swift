//
//  TimelineTrack.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-17.
//

import Foundation



/// The type of the track, specifies what kind of ``TimeLineEvent`` that can be assigned to the track e.g. Haptic, Sound, Animation
enum TrackType: String {
    case haptic
    case sound
    case animation
}


/// A TimeLine track that can hold one timeline event.
struct TimelineTrack: Identifiable {
    /// Unique ID
    var id = UUID()
    /// The type of the track e.g Haptic, Sound, Animation
    var type: TrackType
    ///
    var name: String
}

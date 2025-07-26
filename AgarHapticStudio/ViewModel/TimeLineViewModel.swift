//
//  TimeLineViewModel.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-16.
//

import Foundation


//class TimelineViewModel: ObservableObject {
//    @Published var events: [TimelineEvent] = [
//        .init(type: .haptic(intensity: 1.0, sharpness: 1.0) ,label: "Start", relativeTime: 0.2, duration: 0),
//        .init(type: .haptic(intensity: 0.5, sharpness: 0.5), label: "Snap Me", relativeTime: 1.1, duration: 1.0),
//        .init(type: .haptic(intensity: 1.0, sharpness: 1.0) ,label: "Boom", relativeTime: 2.0, duration: 0),
//    ]
//    
//    @Published var tracks: [TimelineTrack] = [
//        TimelineTrack(type: .haptic),
//        TimelineTrack(type: .sound)
//    ]
//    
//    var timelineLength: TimeInterval = 5.0 // 5 seconds total
//    var gridInterval: TimeInterval = 0.2
//}


class TimelineViewModel: ObservableObject {
    // MARK: - Published
    @Published var tracks: [TimelineTrack] = []
    @Published var eventsByTrack: [UUID: TimelineEvent] = [:]
    
    // MARK: - Initializer
    init() {
        print("TIMELINE VIEW MODEL INITIALIZING")
//        generateExampleData(mode: .soundStartAtZero(noOfEvents: 2))
//        generateExampleData(mode: .soundStartAtZero(noOfEvents: 4))
        generateExampleData(mode: .soundAndHapticStartAtZero(noOfSoundEvents: 4, noOfHapticEvents: 4))
//        generateExampleData(mode: .soundAndHapticStartAtZero(noOfSoundEvents: 3, noOfHapticEvents: 3))
//        playDataExampleModes()
        
        //        eventsByTrack[soundTrack.id] = []
    }


    // MARK: - Timeline
    /// The length of the timeline in sec. This is NOT the same as the length of the soundHaptic event
    var timelineDuration: TimeInterval = 5.0
    /// The length between two grid lines in the timeline in sec
    ///
    // MARK: - Grid
    var gridInterval: TimeInterval = 0.1 /// Need to be evenly divisable so each second will have a grid line
    /// if the grid should empathize 0.5 sec
    var gridDenoteHalfSecond: Bool = true
    /// If the grid should empathize each whole second
    var gridDenoteWholeSecond: Bool = true


    // MARK: - Snapping
    /// If dragging and changing an event should snap to nearest GridLine (when dragging a whole event, the starttime is the side that will snap to the Grid)
    var snapToGrid: Bool = true
    /// If dragging and changing an event should snap to a nearbyEvent, if any (when dragging a whole event, the starttime is the side that will snap to the nearby Event)
    var snapToNearbyEvent: Bool = true
    /// Max distance from gridline for snapping to occur
    var snapToGridMargin: TimeInterval = 0.05
    /// Max distance from nearbyEvent for snapping to occur
    var snapToNearbyEventMargin: TimeInterval = 0.15

    
    
    // MARK: - Ruler
    /// The length between two ruler lines in the timeline in sec
    var rulerInterval: TimeInterval = 0.1
    /// if minor ruler denotes should be shown
    var showMinorDenote: Bool = true
    /// if major ruler denotes should be shown
    var showMajorDenote: Bool = true
    /// Interval between each minor denote (slightly larger ruler line)
    var minorDenoteInterval: TimeInterval = 0.5
    /// Interval between each major denort (larger ruler line)
    var majorDenoteInterval: TimeInterval = 1.0
    /// If major denotes should present the time
    var majorDenoteTime: Bool = true
    /// If major denotes should present the time
    var rulerHeight: CGFloat = 30.0



    
    // MARK: - Tracks
    /// Number of haptic tracks in the timeline
    var hapticTracks : [TimelineTrack] {
        tracks.filter {$0.type == .haptic}
    }
    /// Number of sound tracks in the timeline
    var soundTracks : [TimelineTrack] {
        tracks.filter {$0.type == .sound}
    }
    
    /// Number of animation tracks in the timeline(0 or 1)
    var animationTracks : [TimelineTrack] {
        tracks.filter {$0.type == .animation}
    }
    
    
    /// The length of the soundHaptic package specified by the end time of the last event
    var soundHapticLength: TimeInterval {
        var maxEndTime: TimeInterval = 0
        for event in eventsByTrack.values {
            if event.normalizedStartTime + event.normalizedDuration > maxEndTime {
                maxEndTime = event.normalizedStartTime + event.normalizedDuration
            }
        }
        return maxEndTime
    }
    
    
    
    // MARK: - Examples
    
    enum ExampleDataMode {
        case none
        case soundStartAtZero(noOfEvents: Int = 1)
        case hapticStartAtZero(noOfEvents: Int = 1)
        case soundAndHapticStartAtZero(noOfSoundEvents: Int = 1, noOfHapticEvents: Int = 1)
        case soundDifferentStartTimes(noOfEvents: Int = 3)
        case hapticDifferentStartTimes(noOfEvents: Int = 3)
        case soundAndHapticDifferentStartTimes(noOfSoundEvents: Int = 3, noOfHapticEvents: Int = 3)

    }
    private func generateExampleData(mode: ExampleDataMode) {
        func addTracks(noOfEvents: Int, type: TrackType, differentStartTimes: Bool) {
            for i in 0..<noOfEvents {
                let trackName = "\(type.rawValue) \(i)"
                let track = TimelineTrack(type: type, name: trackName)
                tracks.append(track)
                
                var event: TimelineEvent!
                switch type {
                    case .haptic:
                    event = TimelineEvent.defaultEvent(of: .haptic())
                case .sound:
                    event = TimelineEvent.defaultEvent(of: .sound())
                case .animation:
                    print("No animation example data yet")
                    break
                }
                eventsByTrack[track.id] = event
                var startTime: TimeInterval = 0
                if differentStartTimes {
                    startTime = Double(i) * 0.2
                }
                event.normalizedStartTime = startTime
            }
        }
        
        tracks = []
        switch mode {
            
        case .none:
            break
        case .soundStartAtZero(noOfEvents: let noOfEvents):
            addTracks(noOfEvents: noOfEvents, type: .sound, differentStartTimes: false)
        case .hapticStartAtZero(noOfEvents: let noOfEvents):
            addTracks(noOfEvents: noOfEvents, type: .haptic, differentStartTimes: false)
        case .soundAndHapticStartAtZero(noOfSoundEvents: let noOfSoundEvents, noOfHapticEvents: let noOfHapticEvents):
            addTracks(noOfEvents: noOfSoundEvents, type: .sound, differentStartTimes: false)
            addTracks(noOfEvents: noOfHapticEvents, type: .haptic, differentStartTimes: false)
        case .soundDifferentStartTimes(noOfEvents: let noOfEvents):
            addTracks(noOfEvents: noOfEvents, type: .sound, differentStartTimes: true)
        case .hapticDifferentStartTimes(noOfEvents: let noOfEvents):
            addTracks(noOfEvents: noOfEvents, type: .haptic, differentStartTimes: true)
        case .soundAndHapticDifferentStartTimes(noOfSoundEvents: let noOfSoundEvents, noOfHapticEvents: let noOfHapticEvents):
            addTracks(noOfEvents: noOfSoundEvents, type: .sound, differentStartTimes: true)
            addTracks(noOfEvents: noOfHapticEvents, type: .haptic, differentStartTimes: true)
        }
        return
        // Example tracks
//        let hapticTrack = TimelineTrack(type: .haptic, name: "Haptic 1")
//        let hapticTrack2 = TimelineTrack(type: .haptic, name: "Haptic 2")
//        let hapticTrack3 = TimelineTrack(type: .haptic, name: "Haptic 3")
//        let soundTrack = TimelineTrack(type: .sound, name: "Sound 1")
//        let soundTrack2 = TimelineTrack(type: .sound, name: "Sound 2")
        //        let soundTrack2 = TimelineTrack(type: .sound, name: "Sound 2")
        //        tracks = [hapticTrack, soundTrack, hapticTrack2, hapticTrack3]
        //        tracks = []
        //        tracks = [hapticTrack]
        //        tracks = [soundTrack]
        //        tracks = [hapticTrack, soundTrack, hapticTrack2]
        //        tracks = [hapticTrack, soundTrack, hapticTrack2, hapticTrack3]
//        tracks = [hapticTrack, soundTrack, soundTrack2, hapticTrack2, hapticTrack3]
//        
//        eventsByTrack[soundTrack.id] = TimelineEvent.defaultEvent(of: .sound())
//        eventsByTrack[soundTrack2.id] = TimelineEvent.defaultEvent(of: .sound())
//        eventsByTrack[hapticTrack.id] = TimelineEvent.defaultEvent(of: .haptic())

    }
    
    private func playDataExampleModes() {
        func playExample(for modes: [ExampleDataMode]) {
            for i in 0..<modes.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * Double(i+1))) { [self] in
                    self.generateExampleData(mode: modes[Int(i)])
                }
            }

        }
        
        playExample(for: [
            .none,
            .soundStartAtZero(noOfEvents: 1),
            .soundStartAtZero(noOfEvents: 2),
            .soundStartAtZero(noOfEvents: 3),
            .soundStartAtZero(noOfEvents: 4),
            .hapticStartAtZero(noOfEvents: 1),
            .hapticStartAtZero(noOfEvents: 2),
            .hapticStartAtZero(noOfEvents: 3),
            .hapticStartAtZero(noOfEvents: 4),
            .soundAndHapticStartAtZero(noOfSoundEvents: 1, noOfHapticEvents: 1),
            .soundAndHapticStartAtZero(noOfSoundEvents: 1, noOfHapticEvents: 2),
            .soundAndHapticStartAtZero(noOfSoundEvents: 1, noOfHapticEvents: 3),
            .soundAndHapticStartAtZero(noOfSoundEvents: 2, noOfHapticEvents: 1),
            .soundAndHapticStartAtZero(noOfSoundEvents: 3, noOfHapticEvents: 1),
            .soundAndHapticStartAtZero(noOfSoundEvents: 3, noOfHapticEvents: 2),
            .soundAndHapticStartAtZero(noOfSoundEvents: 3, noOfHapticEvents: 3),
        ])
        

    }
    
    
    // MARK: - Unmutating Functions
    func event(for track: TimelineTrack) -> TimelineEvent? {
        eventsByTrack[track.id]
    }

    
    
    // MARK: - Mutating Functions
    
    func addTrack(type: TrackType, name: String) {
        let newTrack = TimelineTrack(type: type, name: name)
        tracks.append(newTrack)
        switch type {
            case .haptic:
            eventsByTrack[newTrack.id] = TimelineEvent.defaultEvent(of: .haptic())
            break
        case .sound:
            eventsByTrack[newTrack.id] = TimelineEvent.defaultEvent(of: .sound())
            break
        case .animation:
            break
        }
    }
    
    func addEvent(_ event: TimelineEvent, to trackID: UUID) {
        eventsByTrack[trackID] = event
    }
    
    func removeEvent(from trackID: UUID) {
        eventsByTrack[trackID] = nil
    }
    
    func moveEvent(in trackID: UUID, to newNormalizedTime: TimeInterval) {
        print("in moveEvent trackID \(trackID) newTime \(newNormalizedTime)")
        guard var event = eventsByTrack[trackID] else { return }
        print("After guard with even = \(event)")
        event.normalizedStartTime = newNormalizedTime
        print("relativeTime after setting (\(event.normalizedStartTime))")
        // eventsByTrack[trackID] = event
    }
}

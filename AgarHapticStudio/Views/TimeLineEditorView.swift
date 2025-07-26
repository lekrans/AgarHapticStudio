////
////  TimeLineEditorView.swift
////  AgarHapticStudio
////
////  Created by Michael Lekrans on 2025-07-16.
////
//
import SwiftUI

struct TimelineEditorView: View {
    @EnvironmentObject var viewModel: TimelineViewModel
    
    @Binding var timelineWidth : CGFloat
    var body: some View {
        GeometryReader { geo in
            let totalHeight = geo.size.height - viewModel.rulerHeight
            let timelineTrackHeights = calculateTrackHeights(with: totalHeight)
            
            ScrollView(.horizontal){
                // Ruler
                TimelineRuler(timelineWidth: timelineWidth)
                    .padding(0)
                
                ZStack(alignment: .leading) {
                    // Timeline
                    //                    ZStack {
                    // Timeline background
                    Rectangle()
                        .fill(Color.black.opacity(0.05))
                        .frame(width: timelineWidth, height: totalHeight)
                    // Grid
                    TimelineGrid(timelineWidth: timelineWidth, totalHeight: totalHeight)
                    
                    
                    
                    
                    VStack(spacing: 0) {
                        // HAPTIC TRACKS
                        ForEach(viewModel.tracks.filter { $0.type == .haptic }) { track in
                            TrackView(track: track, timelineWidth: timelineWidth, height: timelineTrackHeights.hapticTrackHeight)
                        }
                        
                        Rectangle() // Center Divider Line
                            .fill(Color.red)
                            .frame(height: 1)
                        
                        // SOUND TRACKS
                        ForEach(viewModel.tracks.filter { $0.type == .sound }) { track in
                            TrackView(track: track, timelineWidth: timelineWidth, height: timelineTrackHeights.soundTrackHeight)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    /// Calculates the heights for the haptic, sound and animation track heights.
    ///
    /// If we have an animation track, it will be a 1/3 of the total timeline height.
    /// The haptic tracks and sound tracks will share the rest of the height each category receiving the same size i.e the haptic area and sound area will be equal in size and position on each side of the vertical center (and animation track if one exists).
    /// That space is then divided by the tracks in each category, with the exception that a track can be max half the available space.
    ///
    /// Example:
    /// The total height available is 300. We have an animation track that will be 100 in height. That leaves 200 for sound and haptics 100 each. Now there is only one sound track so it will have 100px available, but can be max half of the available space so it get 50 in height. There are 3 haptic tracks that share 100px and get 33px each in height
    /// - Parameter totalHeight: The total available height for the timeline
    /// - Returns: ``TimelineTrackHeights``
    func calculateTrackHeights(with totalHeight: CGFloat) -> TimelineTrackHeights {
        let animationHeight = (totalHeight - (totalHeight/3.0)) * CGFloat(viewModel.animationTracks.count)
        let availableHeight = totalHeight - animationHeight
        let maxHeight: CGFloat = availableHeight / 4
        let hapticTrackHeight: CGFloat =  min(maxHeight, (availableHeight / CGFloat(2)) / CGFloat(viewModel.hapticTracks.count))
        let soundTrackHeight: CGFloat = min(maxHeight, (availableHeight / CGFloat(2)) / CGFloat(viewModel.soundTracks.count)
        )
        let timelineTrackHeights = TimelineTrackHeights(animationHeight: animationHeight, hapticTrackHeight: hapticTrackHeight, soundTrackHeight: soundTrackHeight)
        return timelineTrackHeights
    }
}

#Preview {
    @Previewable @State var Bind : CGFloat = 1000
    TimelineEditorView( timelineWidth: $Bind)
        .environmentObject(TimelineViewModel())
}

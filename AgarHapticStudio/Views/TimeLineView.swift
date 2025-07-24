//
//  TimeLineView.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-16.
//
//import SwiftUI
//
//struct TimelineView: View {
//    @EnvironmentObject var viewModel: TimelineViewModel
//
//    
//    var body: some View {
//        GeometryReader { geo in
//            let width = geo.size.width
//            
//            ZStack(alignment: .leading) {
//                // Grid lines
//                ForEach(0..<Int(viewModel.timelineLength / viewModel.gridInterval), id: \.self) { i in
//                    let x = CGFloat(Double(i) * viewModel.gridInterval / viewModel.timelineLength) * width
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(width: 1)
//                        .position(x: x, y: geo.size.height / 2)
//                }
//                
//                // Events
//                ForEach($viewModel.events) { $event in
//                    EventView(event: $event, totalDuration: viewModel.timelineLength, timelineWidth: width, allEvents: viewModel.events)
//                        .position(y: 30)
//                        
//                }
//            }
//        }
//        .frame(height: 80)
//    }
//}

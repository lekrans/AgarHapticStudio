//
//  Common.swift
//  AgarHapticStudio
//
//  Created by Michael Lekrans on 2025-07-22.
//

import Foundation
import SwiftUI


/// *****************************************
//  MARK: - Time
/// *****************************************

func formatTime(_ time: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    
    return formatter.string(from: NSNumber(value: time)) ?? ""
}


/// *****************************************
//  MARK: - Print
/// *****************************************


struct DebugPrintView: View {
    let message: String
    
    var body: some View {
        Text("") // Empty or invisible view
            .onAppear {
                print("DebugPrintView appeared with message: \(message)")
            }
    }
}


//struct Print: View {
//    let message: String
//    
//    init(_ message: String) {
//        self.message = message
//    }
//    
//    var body: some View {
//        Text("") // Empty or invisible view
//            .onAppear {
//                print("print: \(message)")
//            }
//    }
//}

struct PrintOnlyView: View {
    init(_ text: String) {
        print("PrintOnlyView initialized: \(text)")
    }
    
    var body: some View {
        EmptyView() // Doesn't render anything visible
    }
}


/// PrintOnChange
struct PrintOnChange<T: Equatable>: ViewModifier {
    let value: T
    let label: String
    
    func body(content: Content) -> some View {
        content
            .onChange(of: value, { oldValue, newValue in
                print("label: \(label) newValue:\(newValue), oldValue:\(oldValue)")
            })
        
    }
}

extension View {
    func printOnChange<T: Equatable>(_ value: T, label: String) -> some View {
        self.modifier(PrintOnChange(value: value, label: label))
    }
}

// Usage:
//Text("Hello")
//    .printOnChange(someStateVar, label: "someStateVar")

/// End printOnChange


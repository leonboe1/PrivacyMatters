//
//  UIExtension.swift
//
//
//  Created by Leon Böttger on 19.02.24.
//

import SwiftUI

public extension View {
    
    /// Applies modifiers conditonally
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


public extension Color {
    
    /// Main color for pad view
    static let mainColor = Color("MainColor")
    
    /// Custom gray color
    static let grayColor = mainColor.opacity(0.6)
}


public extension AnyTransition {
    
    /// Blur transition
    static var blur: AnyTransition { get {
        AnyTransition.modifier(active: BlurModifier(percent: 1, radius: 5), identity: BlurModifier(percent: 0, radius: 5)).combined(with: .opacity)
    }}
}


/// For blur transition
struct BlurModifier: ViewModifier {
    let percent: Double
    let radius: Double
    
    func body(content: Content) -> some View {
        content.blur(radius: percent * radius)
    }
}


/// Applies heavy text for introduction
extension Text {
    func heavyText() -> Text {
        self
            .font(.largeTitle.bold())
    }
}


/// Makes text rounded
struct RoundTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.1, tvOS 16.1, watchOS 9.1, *) {
            content
                .fontDesign(.rounded)
            #if os(watchOS)
                .kerning(0.4)
            #endif
        }
        else {
            content
        }
    }
}


public extension View {
    
    /// Makes text rounded
    func rounded() -> some View {
        return self.modifier(RoundTextModifier())
    }
}

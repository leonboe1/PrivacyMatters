//
//  ColoredButton.swift
//
//
//  Created by Leon Böttger on 22.02.24.
//

import SwiftUI

/// Custom rounded button
public struct ColoredButton: View {
    
    public init(label: String,
                color: [Color] = [.blue],
                imageName: String = "chevron.right",
                action: @escaping () -> ()) {
        self.label = label
        self.color = color
        self.imageName = imageName
        self.action = action
    }
    
    let imageName: String
    let label: String
    let color: [Color]
    let action: () -> ()
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public var body: some View {
        LUIButton(action: {
            action()
            
        }) {
            HStack() {
                Text(label)
                    .lineLimit(1)
                    .rounded()
            }
            .coloredButton(colors: color)
            .accentColor(color.last)
        }
        .padding(.horizontal)
        .opacity(isEnabled ? 1 : 0.5)
    }
}


extension View {
    func coloredButton(colors: [Color]) -> ModifiedContent<Self, ColoredButtonModifier> {
        return modifier(ColoredButtonModifier(colors: colors))
    }
}


struct ColoredButtonModifier: ViewModifier {
    
    let colors: [Color]
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .padding(.horizontal, 10)
            .padding(.vertical, -1)
            .background(
                ZStack {
                    getGradient(colors: colors)
                    LinearGradient(colors: [.clear, .white.opacity(0.2)], startPoint: .bottom, endPoint: .top)
                }
                .cornerRadius(20)
            )
    }
}

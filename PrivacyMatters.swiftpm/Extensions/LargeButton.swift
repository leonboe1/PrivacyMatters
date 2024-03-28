//
//  LargeButton.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 08.02.24.
//

import SwiftUI

/// Custom large button view
struct LargeButton: View {
    
    init(label: String,
                color: [Color] = [Color.blue],
                expand: Bool = false,
                padding: CGFloat? = nil,
                loading: Bool = false,
                invertColors: Bool = false,
                action: @escaping () -> ()) {
        self.label = label
        self.color = color
        self.action = action
        self.padding = padding
        self.loading = loading
        self.expand = expand
        self.invertColors = invertColors
    }
    
    let label: String
    let color: [Color]
    let expand: Bool
    let loading: Bool
    let padding: CGFloat?
    var invertColors: Bool
    let action: () -> ()
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    public var body: some View {
        LUIButton(action: {
            action()
            
        }) {
            HStack(spacing: 0) {
                LUIText(label)
                    .rounded()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                if(loading) {
                    ProgressView()
                        .padding(.leading, 8)
                }
            }
            #if !os(tvOS)
                .largeButton(colors: color, expand: expand, padding: padding, invert: invertColors)
            #endif
        }
        .if(!expand, transform: { view in
            view.padding(.horizontal)
        })
        .opacity(isEnabled ? 1 : 0.5)
    }
}


extension View {
    func largeButton(colors: [Color], expand: Bool, padding: CGFloat? = nil, invert: Bool) -> ModifiedContent<Self, LargeButtonModifier> {
        return modifier(LargeButtonModifier(colors: colors, expand: expand, padding: padding, invert: invert))
    }
}


struct LargeButtonModifier: ViewModifier {
    
    let colors: [Color]
    let expand: Bool
    let padding: CGFloat?
    let invert: Bool
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(invert ? colors.first! : .white)
            .font(.headline)
            .if(padding != nil, transform: { view in
                view.padding(padding!)
            })
            .if(padding == nil, transform: { view in
                view
                    .padding()
                    .padding(.vertical, -1)
            })
            .if(!expand, transform: { view in
                view.frame(minWidth: 0, maxWidth: 320, alignment: .center)
            })
            .if(expand, transform: { view in
                view.frame(maxWidth: .infinity)
            })
            .background(
                ZStack {
                    getGradient(colors: colors)
                    LinearGradient(colors: [.clear, .white.opacity(invert ? 0 : 0.2)], startPoint: .bottom, endPoint: .top)
                }
                    .opacity(invert ? (colorScheme.isLight ? 0.2 : 0.25) : 1)
                    .cornerRadius(18))
    }
}


public func getGradient(colors: [Color]) -> LinearGradient {
    return LinearGradient(gradient: .init(colors: colors), startPoint: .bottomLeading, endPoint: .topTrailing)
}


public struct LUIButton<Content: View>: View {
    
    public init(action: @escaping () -> (), @ViewBuilder label: () -> Content) {
        
        self.action = action
        self.label = label()
    }
    
    let action: () -> ()
    let label: Content
    
    public var body: some View {
        
        Button(action: action, label: {
            label
                .contentShape(Rectangle())
        })
        #if os(watchOS)
        .buttonStyle(PlainButtonStyle())
        #else
        .buttonStyle(LUIButtonStyle())
        #endif
    }
}


public struct LUIButtonStyle: ButtonStyle {
    
    public init() {}
    
    @Environment(\.accessibilityShowButtonShapes)
    private var accessibilityShowButtonShapes
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

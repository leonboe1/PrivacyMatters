//
//  File.swift
//  
//
//  Created by Leon Böttger on 19.02.24.
//

import SwiftUI

/// Small round icon for sidebar
public struct SettingsIcon: View {
   
    public init(imageName: String?, imageText: String? = nil, backgroundColor: Color) {
        self.imageName = imageName
        self.imageText = imageText
        self.backgroundColor = backgroundColor
    }
    
    let imageName: String?
    let imageText: String?
    let backgroundColor: Color
    
    #if os(watchOS)
    let size: CGFloat = 25
    #else
    let size: CGFloat = 30
    #endif
    
    @Environment(\.colorScheme) private var colorScheme
    
    public var body: some View {
        
        ZStack {
            
            ZStack {
                backgroundColor
                LinearGradient(colors: [.clear, .white.opacity(0.1)], startPoint: .bottom, endPoint: .top)
            }
            .mask(Circle())
            
            ZStack {
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .font(.system(size: size / 2, weight: .bold))
                }
                else {
                    LUIText(imageText ?? "")
                        .font(.system(size: size * 0.6, weight: .bold))
                }
            }
              
                .foregroundColor(.white)
                .clipped()
            
        }
        .frame(width: size, height: size)
        .padding(.trailing, 5)
        .compositingGroup()
    }
}

//
//  AppIcon.swift
//  
//
//  Created by Leon Böttger on 24.02.24.
//

import SwiftUI

public struct AppIconView: View {
    
    public init(size: CGFloat? = nil) {
        
        if let size = size {
            self.iconSize = size
        }
        else {
            self.iconSize = 84
        }
    }
    
    let iconSize: CGFloat
    @Environment(\.colorScheme) private var colorScheme
    
    public var body: some View {
        
        ZStack {
            if let uiImage = UIImage(named: "AppIconHighRes")  {
                Image(uiImage: uiImage)
                    .resizable()
            }
        }
        .cornerRadius(iconSize*0.3)
        .frame(width: iconSize, height: iconSize)
        .padding()
    }
}

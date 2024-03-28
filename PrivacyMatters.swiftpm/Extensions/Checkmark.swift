//
//  Checkmark.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 11.02.24.
//

import SwiftUI

struct Checkmark: View {
    
    var size: CGFloat = 25
    
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: size))
            .background(Color.white.mask(Circle()).padding(size * 0.08))
            .foregroundStyle(.green)
            .compositingGroup()
            .zIndex(.infinity)
            .transition(.scale)

    }
}

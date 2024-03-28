//
//  Text.swift
//
//
//  Created by Leon Böttger on 20.02.24.
//

import SwiftUI

/// Custom `Text` wrapper for automatic applied effects like rounded text.
struct LUIText: View {
    
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .rounded()
    }
}

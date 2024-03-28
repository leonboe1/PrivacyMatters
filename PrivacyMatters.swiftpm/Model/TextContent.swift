//
//  TextContent.swift
//
//
//  Created by Leon Böttger on 09.02.24.
//

import Foundation

/// Models a section within a lesson
struct TextContent: Equatable, Identifiable {
    
    init(text: String, highlighted: Bool = false) {
        self.init(highlighted: highlighted, title: nil, text: text)
    }
    
    init(title: String?, text: String) {
        self.init(highlighted: false, title: title, text: text)
    }
    
    private init(highlighted: Bool, title: String?, text: String) {
        self.highlighted = highlighted
        self.title = title
        self.text = text
    }
    
    /// True for quiz-style textboxes
    let highlighted: Bool
    
    /// The title of the text section
    let title: String?
    
    /// The text of the section
    let text: String
    
    /// ID
    let id = UUID()
}

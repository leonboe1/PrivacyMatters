//
//  Lesson.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 09.02.24.
//

import SwiftUI

/// Class to model a lesson
class Lesson: ObservableObject, Identifiable, Equatable {
    
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(topic: String, icon: String, color: Color, content: [TextContent]) {
        self.finished = UserDefaults.standard.bool(forKey: topic)
        self.topic = topic
        self.icon = icon
        self.color = color
        self.content = content
    }
    
    /// True, if lesson was finished
    @Published var finished: Bool {
        didSet {
            runAfter(seconds: 0.2) {
                LessonProgressModel.sharedInstance.calculateCourseProgress()
            }
            UserDefaults.standard.setValue(finished, forKey: topic)
        }
    }
    
    /// Topic/header of the lesson
    let topic: String
    
    /// Icon (SF symbol)
    let icon: String
    
    /// Accent color for lesson
    let color: Color
    
    /// Articles/ text of the lesson
    let content: [TextContent]
}

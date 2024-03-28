//
//  QuizQuestion.swift
//
//
//  Created by Leon Böttger on 10.02.24.
//

import SwiftUI

/// For quiz-style lessons, this models a question
struct QuizQuestion: Equatable, Identifiable {

    /// Question as string
    let question: String
    
    /// All answers
    let answers: [QuizAnswer]
    
    /// ID of quiz question
    let id = UUID()
}

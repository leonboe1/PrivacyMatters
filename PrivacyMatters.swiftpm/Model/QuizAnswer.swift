//
//  QuizAnswer.swift
//
//
//  Created by Leon Böttger on 10.02.24.
//

import Foundation

/// For quiz-style lessons, this models an answer to a quiz question
struct QuizAnswer: Equatable, Identifiable  {
    
    /// Answer as string
    let answer: String
    
    /// True, if correct
    let isCorrect: Bool
    
    /// ID of answer
    let id = UUID()
}

//
//  LessonType.swift
//
//
//  Created by Leon Böttger on 19.02.24.
//

import SwiftUI

/// Encapsulates all lessons, and related views
enum LessonType: CaseIterable, Identifiable {
    
    var id: ObjectIdentifier {
        get {
            lesson.id
        }
    }
    
    case Introduction
    case Datasets
    case Fingerprinting
    case WhyItMatters
    case Summary
    
    /// Related lesson object
    var lesson: Lesson {
        switch self {
        case .Introduction:
            introductionLessonContent
            
        case .Datasets:
            datasetsLessonContent
            
        case .Fingerprinting:
            fingerprintingLessonContent
            
        case .WhyItMatters:
            whyItMattersLessonContent
            
        case .Summary:
            summaryLessonContent
        }
    }
    
    @ViewBuilder
    /// The interactive quiz view on the right
    func quizView() -> some View {
        switch self {
            
        case .Introduction:
            IntroductionQuizView()
            
        case .Datasets:
            DatasetsQuizView()
            
        case .Fingerprinting:
            FingerprintingQuizView()
            
        case .WhyItMatters:
            WhyItMattersQuizView()
            
        case .Summary:
            SummaryQuizView()
        }
    }
}

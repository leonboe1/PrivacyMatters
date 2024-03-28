//
//  DataModel.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 09.02.24.
//

import SwiftUI

/// Responsible to track the user progress within the app
class LessonProgressModel: NSObject, ObservableObject {
    
    public static var sharedInstance = LessonProgressModel()
    
    private override init() {
        super.init()
        calculateCourseProgress()
    }
    
    /// True if app was started before
    @Published var appLaunchedBefore = UserDefaults.standard.bool(forKey: "appLaunchedBefore") {
        didSet {
            if(!appLaunchedBefore) {
                canShowIntroductionSheet = true
            }
            UserDefaults.standard.setValue(appLaunchedBefore, forKey: "appLaunchedBefore")
        }
    }
    
    /// True if introduction shown
    @Published var canShowIntroductionSheet = true
    
    /// UI related:  Determines if user selected the next lesson or a previous one
    @Published var movingForwards = true
    
    /// Percentage of course which is completed
    @Published var courseProgress = 0.0
    
    /// Current shown lesson
    @Published var selectedLesson: LessonType = .Introduction
    
    /// All lessons
    var lessons: [LessonType] {
        get {
            LessonType.allCases
        }
    }
    
    /// Opens the specified lesson
    func openLesson(lesson: LessonType) {
        
        AudioPlayer.sharedInstance.playSound(sound: .click)
        
        if lessons.firstIndex(of: lesson)! < lessons.firstIndex(of: selectedLesson)! {
            movingForwards = false
        }
        else {
            movingForwards = true
        }
        
        runAfter(seconds: 0.1) {
            withAnimation(.spring()) {
                self.selectedLesson = lesson
            }
        }
    }
    
    /// Calculates `courseProgress`
    func calculateCourseProgress() {
        
        let finishedLessons = Double(lessons.filter({$0.lesson.finished}).count)
        let newProgress = finishedLessons / Double(lessons.count)
        
        withAnimation(.spring) {
            courseProgress = newProgress
        }
    }
}

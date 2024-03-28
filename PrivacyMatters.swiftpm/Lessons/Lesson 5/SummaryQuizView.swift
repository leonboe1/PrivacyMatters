//
//  SummaryQuizView.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 11.02.24.
//

import SwiftUI

struct SummaryQuizView: View {
    
    @ObservedObject var lesson = summaryLessonContent
    @State var showAwardView = summaryLessonContent.finished
    @State var confettiCounter = 0
    
    @State var questions = [
        QuizQuestion(question: "What is at least needed to identify 87% of USA's population?", answers:
                        [
                            QuizAnswer(answer: "ZIP, Birthdate, Gender, First Name", isCorrect: false),
                            QuizAnswer(answer: "Last Name, ZIP, Birthdate, Gender", isCorrect: false),
                            QuizAnswer(answer: "Gender, ZIP, Birthdate", isCorrect: true),
                        ]),
        
        QuizQuestion(question: "Browser Fingerprinting...", answers:
                        [
                            QuizAnswer(answer: "Requires at least knowledge of the user's location", isCorrect: false),
                            QuizAnswer(answer: "Allows identifying users using information leaked by the browser", isCorrect: true),
                            QuizAnswer(answer: "Only works with desktop browsers", isCorrect: false)
                        ]),
        
        QuizQuestion(question: "Select the wrong statement.", answers:
                        [
                            QuizAnswer(answer: "Privacy is not needed if one has nothing to hide.", isCorrect: true),
                            QuizAnswer(answer: "Privacy has large effects on security and souvereignty.", isCorrect: false),
                            QuizAnswer(answer: "Data leaks are possible even with trusted third parties.", isCorrect: false)
                        ]),
    ]
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                if showAwardView {
                    Spacer()
                    
                    RewardView()
                        .compositingGroup()
                        .shadow(color: Color.white, radius: 1)
                        .onChange(of: lesson.finished) { oldValue, newValue in
                            if !newValue {
                                withAnimation {
                                    showAwardView = false
                                }
                            }
                        }
                        .frame(maxHeight: geo.size.height * 0.7)
                        .frame(maxWidth: geo.size.width * 0.8)
                        .compositingGroup()
                }

                Spacer()
                
                if !showAwardView {
                    LargeIcon(color: Color.blue, icon: "questionmark")
                }
                
                QuizView(completedQuiz: $lesson.finished, questions: questions, congratulationString: "Wow, good job! Here is a reward for you! 🎉") {
                    
                    runAfter(seconds: 0.5) {
                        withAnimation {
                            showAwardView = true
                        }
                        AudioPlayer.sharedInstance.playSound(sound: .completed)
                        confettiCounter += 1
                    }
                }
                .padding(.bottom, 25)
                
                Spacer()
            }
            .confettiCannon(counter: $confettiCounter,
                            num: 100,
                            confettiSize: 15,
                            fadesOut: true,
                            openingAngle: .degrees(0),
                            closingAngle: .degrees(360))
            .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    ContentView()
        .onAppear {
            LessonProgressModel.sharedInstance.selectedLesson = .Summary
        }
}

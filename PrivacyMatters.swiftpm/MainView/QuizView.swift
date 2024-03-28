//
//  QuizView.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 10.02.24.
//

import SwiftUI


struct QuizView: View {
    
    @Binding var completedQuiz: Bool
    let questions: [QuizQuestion]
    var congratulationString = "Congratulations! You solved the quiz! 🎉"
    let reachedEnd: () -> ()
    
    @State private var currentQuestion = 0
    
    var body: some View {
     
        let question = questions[currentQuestion]
        
        VStack {
          QuizHeaderView(text: completedQuiz ? congratulationString : question.question)
                .id("QuizTitle" + question.question + completedQuiz.description)
            
            if !completedQuiz {
                ForEach(question.answers) { answer in
                    AnswerSelectView(answer: answer) {
                        if currentQuestion < questions.count-1 {
                            withAnimation {
                                currentQuestion += 1
                            }
                        }
                        else {
                            withAnimation {
                                reachedEnd()
                                completedQuiz = true
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: completedQuiz) { oldValue, newValue in
            if !newValue {
                currentQuestion = 0
            }
        }
    }
}


struct AnswerSelectView: View {
    
    let answer: QuizAnswer
    let answeredCorrectly: () -> ()
    
    @State private var wrongInputAttempts = 0
    @State private var correct = false
    @State private var incorrect = false
    
    @Environment(\.colorScheme) var colorScheme
    
    private let audioPlayer = AudioPlayer.sharedInstance
    
    var body: some View {
        
        LargeButton(label: answer.answer, color: [getButtonColor()], invertColors: !correct) {
            tapped()
        }
        .scaleEffect(correct ? 1.1 : 1)
        .padding(3)
        .modifier(Shake(animatableData: CGFloat(wrongInputAttempts)))
    }
    
    func tapped() {
        if answer.isCorrect {
            withAnimation(.spring) {
                correct = true
            }
            audioPlayer.playSound(sound: .success)
            
            runAfter(seconds: 1.5) {
                answeredCorrectly()
            }
        }
        else {
            audioPlayer.playSound(sound: .error)
            withAnimation(.spring) {
                incorrect = true
            }
            
            withAnimation(.easeInOut) {
                wrongInputAttempts += 1
            }
        }
    }
    
    func getButtonColor() -> Color {
        if correct {
            return .green
        }
        if incorrect {
            return .red
        }
        return colorScheme.isLight ? .blue : Color.white.opacity(0.7)
    }
}


struct Shake: GeometryEffect {
    var amount: CGFloat = 15
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}


struct QuizHeaderView: View {
    let text: String
    
    var body: some View {
        LUIText(text)
            .font(.title)
            .padding()
            .multilineTextAlignment(.center)
    }
}


#Preview {
    QuizView(completedQuiz: .constant(false), questions: [QuizQuestion(question: "Question...", answers: [QuizAnswer(answer: "CorrectAnswer", isCorrect: true), QuizAnswer(answer: "FalseAnswer", isCorrect: false)])], reachedEnd: {})
}

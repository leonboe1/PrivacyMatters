//
//  DatasetsQuizView.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 12.02.24.
//

import SwiftUI

struct DatasetsQuizView: View {
    
    @ObservedObject var lesson = datasetsLessonContent
    
    var body: some View {
        VStack {
            
            HealthDatasetComputer()
            
            QuizView(completedQuiz: $lesson.finished, questions: [
                QuizQuestion(question: "What is Peter's disease?", answers: [
                    QuizAnswer(answer: "Diabetes", isCorrect: false),
                    QuizAnswer(answer: "Influenza", isCorrect: false),
                    QuizAnswer(answer: "Diarrhea", isCorrect: true)
                ])]) { }
        }
    }
}


struct HealthDatasetComputer: View {
    
    @State var database = getDatabase()
    @State private var selectedDatasetIndex = 0
    let placeholderTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var showPlaceholder = false
    @State private var loadingData = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("mac")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.9)
            }
            .overlay(
                GeometryReader { innnerGeo in
                    Text(getComputerOutput())
                        .monospaced()
                        .fontWeight(.heavy)
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(.green)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.horizontal, innnerGeo.size.width * 0.23)
                        .padding(.top, innnerGeo.size.height * 0.22)
                        .padding(.bottom, innnerGeo.size.height * 0.49)
                }
            )
        }
        .aspectRatio(0.8, contentMode: .fit)
        .onTapGesture {
            
            loadingData = true
            AudioPlayer.sharedInstance.playSound(sound: .keyboard)
            
            runAfter(seconds: 0.8) {
                loadingData = false
                selectedDatasetIndex = (selectedDatasetIndex + 1) % database.count
            }
            AudioPlayer.sharedInstance.playSound(sound: .floppy)
        }
        .onReceive(placeholderTimer) { input in
            showPlaceholder.toggle()
        }
    }
    
    func getComputerOutput() -> String {
        
        let current = selectedDatasetIndex + 1
        let total = database.count
        let entry = database[selectedDatasetIndex]
        let nextString = loadingData ? "Loading..." : "Click to show next" + (showPlaceholder ? "▋" : "")
        
        return """
Patient Database
-------------------
Showing \(current.description) of \(total.description)
-------------------
Name: (censored)
Birthdate: \(entry.date)
Disease: \(entry.disease)

------------------
\(nextString)
"""
    }
    
    static func getDatabase() -> [MedicalData] {
        return [
            
            MedicalData(date: "10.03.1993", disease: "Diabetes"),
            MedicalData(date: "29.10.1994", disease: "Influenza"),
            MedicalData(date: "10.02.1995", disease: "Diarrhea")
        ]
    }
    
    
    /// Model datasets
    struct MedicalData {
        let date: String
        let disease: String
    }
}


#Preview {
    Group {
        ContentView()
            .onAppear {
                LessonProgressModel.sharedInstance.selectedLesson = LessonProgressModel.sharedInstance.lessons[1]
            }
    }
}

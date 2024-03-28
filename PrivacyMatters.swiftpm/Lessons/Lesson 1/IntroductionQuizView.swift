//
//  IntroductionQuizView.swift
//
//
//  Created by Leon Böttger on 18.02.24.
//

import SwiftUI

struct IntroductionQuizView: View {
    
    @ObservedObject var lesson = introductionLessonContent
    @State var types = [
        DataType(name: "Emails sent", icon: "mail.fill", color: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))], millionPerSecond: 3.8566666667),
        DataType(name: "Crypto Purchases", icon: "bitcoinsign.circle.fill", color: [Color(#colorLiteral(red: 1, green: 0.5803921569, blue: 0.3098039216, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7529411765, blue: 0.2588235294, alpha: 1))], millionPerSecond: 1.5033333333),
        DataType(name: "Texts sent", icon: "bubble.fill", color: [Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)), Color(#colorLiteral(red: 0.1936409473, green: 0.7672969699, blue: 0.3610956669, alpha: 1))], millionPerSecond: 0.2666666667),
        DataType(name: "Google Searches", icon: "magnifyingglass.circle.fill", color: [Color(#colorLiteral(red: 0.6942194104, green: 0.671523869, blue: 0.9558958411, alpha: 1)), Color(#colorLiteral(red: 0.8086243762, green: 0.671523869, blue: 0.9558958411, alpha: 1))], millionPerSecond: 0.09833333333)
    ]
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            ForEach(types) { dataType in
                DataOccurrenceCounter(lesson: lesson, type: dataType)
            }
            
            if lesson.finished {
                Checkmark(size: 40)
                    .padding(.top)
            }
            else {
                QuizHeaderView(text: "What happens most frequently?")
                    .padding(.horizontal)
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.bottom, -20)
    }
}


struct DataType: Identifiable {
    let name: String
    let icon: String
    let color: [Color]
    let millionPerSecond: CGFloat
    
    let id = UUID()
}


struct DataOccurrenceCounter: View {

    @ObservedObject var lesson: Lesson
    @State var type: DataType
    @State var mioElems = 0.0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var seconds = 0
    @State var errorCounter = 0
    @State var scale = 1.0
    
    var body: some View {
        
        getGradient(colors: type.color)
            .cornerRadius(20)
            .frame(height: 100)
            .modifier(PercentageIndicator(showDigit: lesson.finished, seconds: seconds, type: type, pct: mioElems))
            .padding(.horizontal, 25)
            .onReceive(timer, perform: { _ in
                if lesson.finished {
                    seconds += 1
                }
                timerFired()
            })
            .onAppear {
                timerFired()
            }
            .scaleEffect(scale)
            .onTapGesture {
                if type.name.contains("Email") {
                    AudioPlayer.sharedInstance.playSound(sound: .success)
                    withAnimation {
                        lesson.finished = true
                        scale = 1.1
                    }
                    timerFired()
                    
                    runAfter(seconds: 0.8) {
                        withAnimation {
                            scale = 1.0
                        }
                    }
                }
                else {
                    AudioPlayer.sharedInstance.playSound(sound: .error)
                    withAnimation(.easeInOut) {
                        errorCounter += 1
                    }
                }
            }
            .modifier(Shake(animatableData: CGFloat(errorCounter)))
    }
    
    func timerFired() {
        if lesson.finished {
            withAnimation(.linear(duration: 1)) {
                mioElems += type.millionPerSecond
            }
        }
    }
}


struct PercentageIndicator: AnimatableModifier {
    let showDigit: Bool
    let seconds: Int
    let type: DataType
    var pct: CGFloat = 0
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                HStack {
                    Image(systemName: type.icon)
                        .font(.system(size: 30))
                    
                    Spacer()
                    
                    VStack {
                        if showDigit {
                            LabelView(pct: pct)
                            LUIText(type.name + " in \(seconds.description)s")
                            
                        }
                        else {
                            LUIText(type.name)
                                .font(.system(size: 22, weight: .semibold))
                            
                            LUIText("per second")
                        }
                       
                    }
                    .minimumScaleFactor(0.2)
                    .padding(.trailing)
                    Spacer()
                }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
            )
    }
    
    struct LabelView: View {
        let pct: CGFloat
        
        var body: some View {
            Text(String(format: "%.2fm", pct))
                .font(.system(size: 30, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
    }
}

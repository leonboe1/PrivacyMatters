//
//  Leftbar.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 09.02.24.
//

import SwiftUI

struct LeftSidebarView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            
            Color.gray
                .opacity(colorScheme.isLight ? 0.07 : 0.15)
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
            
            VStack {
                
                HStack {
                    LUIText("PrivacyMatters")
                        .font(.largeTitle.bold())
                    Spacer()
                }
                
                LUIText("A crash course about privacy.")
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LessonSelectView()
                    .padding(.top, 50)
                
                Spacer()
                
                CourseProgressView()
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 23)
            .padding(.top, 40)
        }
    }
}


struct LessonSelectView: View {
    
    @ObservedObject var model = LessonProgressModel.sharedInstance
    
    var body: some View {
        VStack {
            ForEach(LessonType.allCases) { type in
                
                let isSelected = model.selectedLesson == type
                
                Button(action: {
                    model.openLesson(lesson: type)
                }, label: {
                    LessonSelectButton(lesson: type.lesson, isSelected: isSelected)
                })
                
                .buttonStyle(.plain)
            }
        }
    }
}


struct LessonSelectButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var lesson: Lesson
    let isSelected: Bool
    
    var body: some View {
        
        HStack {
            SettingsIcon(imageName: lesson.icon, backgroundColor: lesson.color)
            LUIText(lesson.topic)
                .opacity(0.7)
            
            Spacer()
            
            if lesson.finished {
                Image(systemName: "checkmark")
                    .bold()
                    .foregroundStyle(colorScheme.isLight ? lesson.color : .white)
                    .padding(.leading, 5)
                    .animation(.spring, value: lesson.finished)
            }
        }
        .padding(.horizontal, 5)
        .frame(height: 50)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background((colorScheme.isLight ? lesson.color : .white)
            .opacity(isSelected ? 0.1 : 0)
            .cornerRadius(15)
            .padding(.horizontal, -6)
        )
        .contentShape(Rectangle())
    }
}


struct CourseProgressView: View {
    
    @ObservedObject var model = LessonProgressModel.sharedInstance
    @State var showSheet = false
    
    var body: some View {
        
        VStack(spacing: 18) {
            HStack(spacing: 0) {
                LUIText("Your Progress")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(model.courseProgress, format: .percent)
                    .rounded()
            }
            .opacity(0.7)
            
            ZStack {
                GeometryReader { geo in
                    Capsule()
                        .opacity(0.2)
                    
                    Capsule()
                        .frame(width: geo.size.width * model.courseProgress)
                }
            }
            .foregroundStyle(.blue)
            .frame(height: 15)
            
            HStack {
                
                Button {
                    showSheet = true
                } label: {
                    Text("Legal")
                        .underline()
                }
                
                Spacer()
                
                Button {
                    withAnimation(.spring) {
                        model.lessons.forEach({ $0.lesson.finished = false })
                        model.openLesson(lesson: .Introduction)
                    }
                } label: {
                    Text("Reset Progress")
                        .underline()
                }
                .padding(.top, 5)
            }
            .foregroundStyle(.gray)
            .sheet(isPresented: $showSheet, content: {
                LegalView(showSheet: $showSheet)
            })
        }
    }
}

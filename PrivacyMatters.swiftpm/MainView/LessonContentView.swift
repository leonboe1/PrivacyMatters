//
//  LessonContentView.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 09.02.24.
//

import SwiftUI

struct LessonContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var model = LessonProgressModel.sharedInstance
    let lesson: Lesson
    
    var body: some View {
        
        VStack {
            
            let index = model.lessons.map({$0.lesson}).firstIndex(of: lesson)!
            
            LargeTitleView(title: lesson.topic, subtitle: "Lesson \(index+1)")
            
            LargeIcon(color: lesson.color, icon: lesson.icon)
                .padding()
            
            Divider()
                .padding(.horizontal, 50)
                .padding(.bottom)
            
            ScrollView {
                
                VStack {
                    
                    VStack(spacing: 10) {
                        ForEach(lesson.content) { content in
                            
                            VStack(spacing: 0) {
                                
                                if let title = content.title {
                                    LUIText(title)
                                        .font(.title3.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 15)
                                        .padding(.bottom, 10)
                                }
                                
                                HStack {
                                    
                                    if content.highlighted {
                                        Capsule()
                                            .frame(width: 8)
                                            .padding(.vertical, 20)
                                            .padding(.trailing, 10)
                                            .foregroundColor(lesson.color)
                                    }
                                    
                                    VStack {
                                        
                                        if content.highlighted {
                                            LUIText("Quiz")
                                                .font(.footnote)
                                                .opacity(0.5)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.bottom, 1)
                                        }
                                        
                                        Text(content.text.localizedMarkdown())
                                            .rounded()
                                            .lineSpacing(4)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        
                                    }
                                    .padding(.vertical, content.highlighted ? 20 : 0)
                                    .padding(.horizontal, content.highlighted ? 0 : 15)
                                    
                                }
                                .if(content.highlighted, transform: { view in
                                    view
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(colorScheme.isLight ? 0.1 : 0.17).cornerRadius(20))
                                })
                            }
                            .padding(.bottom)
                        }
                    }
                    
                    if index != model.lessons.count-1 {
                        Button {
                            model.openLesson(lesson: model.lessons[index+1])
                        } label: {
                            HStack {
                                LUIText("Next Lesson")
                                Image(systemName: "chevron.right")
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.never)
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 40)
        .id(lesson.id)
        .transition(model.movingForwards ?
            .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)).combined(with: .opacity)
                    :
                .asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)).combined(with: .opacity)
        )
        .zIndex(.infinity)
    }
}


struct LargeIcon: View {
    
    let color: Color
    let icon: String
    
    var body: some View {
        let imageFontSize = 80.0
        
        ZStack {
            color
            LinearGradient(colors: [.clear, .white.opacity(0.2)], startPoint: .bottom, endPoint: .top)
        }
        .mask(Circle())
        .frame(width: imageFontSize, height: imageFontSize)
        .overlay(
            
            Image(systemName: icon)
            
                .font(.system(size: imageFontSize * 0.5, weight: .heavy))
                .foregroundColor(.white)
                .padding(20)
        )
    }
}

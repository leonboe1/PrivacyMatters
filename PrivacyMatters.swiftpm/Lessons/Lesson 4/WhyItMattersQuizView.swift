//
//  WhyItMattersQuizView.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 14.02.24.
//

import SwiftUI

struct WhyItMattersQuizView: View {
    
    @ObservedObject var lesson = whyItMattersLessonContent
    
    var body: some View {

        ZStack {
            GeometryReader { geo in
                VStack {
                    Image("iphone")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .allowsHitTesting(false)
                        .background(
                            GeometryReader { geo in
                                VStack {
                                    ZStack {
                                        Color.red
                                        LinearGradient(colors: [.clear, .white.opacity(0.2)], startPoint: .bottom, endPoint: .top)
                                    }
                                        .frame(height: geo.size.width * 0.15)
                                        .overlay(LUIText("Bank Of USA")
                                            .font(.system(size: geo.size.width * 0.07, weight: .bold))
                                            .foregroundColor(.white))
                                    
                                    PhonePadView(geo: geo, loggedIn: $lesson.finished)
                                        .zIndex(.infinity)
                                    
                                    Spacer()
                                }
                                .padding(.top, geo.size.height * 0.09)
                                .padding(.horizontal, geo.size.width * 0.01)
                            }
                        )
                        .padding(.horizontal, geo.size.width * 0.15)
                    
                    ZStack {
                        if !lesson.finished {
                            QuizHeaderView(text: "What is Alice's password?")
                        }
                        else {
                            Checkmark(size: 50)
                                .padding(10)
                        }
                    }
                        .padding(.top, geo.size.height * 0.02)
                }
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
                .padding(.vertical, geo.size.height * 0.03)
            }
        }
    }
}


#Preview {
    WhyItMattersQuizView()
}

//
//  FingerprintingQuiz.swift
//
//
//  Created by Leon Böttger on 17.02.24.
//

import SwiftUI

struct FingerprintingQuizView: View {
    
    @StateObject var handler = FingerprintingCardHandler()
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                Spacer()
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 30) {
                    ForEach(0..<4, id: \.self) { index in
                        BrowserWindow(colors: handler.getColor(index: index), request: handler.getRequest(index: index), handler: handler)
                    }
                }
                .frame(maxWidth: 300)
                
                
                ZStack {
                    if !handler.solvedQuiz {
                        QuizHeaderView(text: "Which Requests belong together?")
                    }
                    else {
                        Checkmark(size: 50)
                            .padding(10)
                    }
                }
                .padding(.top, geo.size.height * 0.04)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct BrowserWindow: View {
    
    let colors: [Color]
    let request: Request
    
    @ObservedObject var handler: FingerprintingCardHandler
    
    var body: some View {
        
        let isSelected = handler.selectedRequests.contains(request)
        
        LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
            .cornerRadius(10)
            .frame(width: 130, height: 200)
            .overlay(
                VStack {
                    LUIText("Request")
                        .bold()
                    
                    LUIText("\(request.url)")
                        .padding(.bottom)
                    
                    LUIText("Screen Size: \(request.screenSize)")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 3)
                    
                    LUIText("Battery: \(request.battery)%")
                    
                    Spacer()
                }
                .padding(.top)
                .foregroundStyle(.white)
            )
            .scaleEffect(isSelected ? 1.1 : 1)
            .onTapGesture {
                AudioPlayer.sharedInstance.playSound(sound: .click)
                handler.toggleRequest(request: request)
            }
            .modifier(Shake(animatableData: CGFloat(handler.wrongInputAttempts)))
            .opacity(handler.solvedQuiz && request.userID != 0 ? 0.5 : 1)
    }
}


#Preview {
    FingerprintingQuizView()
}

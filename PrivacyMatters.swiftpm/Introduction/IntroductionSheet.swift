//
//  IntroductionSheet.swift
//  
//
//  Created by Leon Böttger on 22.02.24.
//

import SwiftUI


struct IntroductionSheet: View {
    
    @State var showingIntroductionContent = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                if(isiPadOrMac()) {
                    Image("introductionBackgroundDark")
                        .resizable()
                        .ignoresSafeArea(.all)
                        .allowsHitTesting(false)
                        .opacity(showingIntroductionContent ? 1 : 0)
                }
                else {
                    Color.black
                        .ignoresSafeArea(.all)
                        .allowsHitTesting(false)
                }
                
                IntroductionView()
                    .opacity(showingIntroductionContent ? 1 : 0)
                    .frame(maxWidth: isiPadOrMac() ? min(geo.size.width * 0.8, 800) : .infinity, maxHeight: isiPadOrMac() ? min(geo.size.height * 0.9, 700) : .infinity)
                    .if(isiPadOrMac(), transform: { view in
                        view
                            .cornerRadius(30)
                    })
                    .onAppear {
                        runAfter(seconds: 1) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showingIntroductionContent = true
                            }
                        }
                    }
                    .scaleEffect(showingIntroductionContent ? 1 : 1.1)
            }
        }
        .compositingGroup()
        .transition(AnyTransition.blur)
        .zIndex(.infinity)
        .navigationViewStyle(.stack)
    }
}


#Preview {
    IntroductionSheet()
}

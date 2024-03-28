//
//  PhonePadView.swift
//  
//
//  Created by Leon Böttger on 19.02.24.
//

import SwiftUI

struct PhonePadView: View {
    
    let geo: GeometryProxy
    @Binding var loggedIn: Bool
    
    @State private var buttons: [PhonePadButton] = (1...9).map({PhonePadButton(type: .Number, number: $0)}) + [PhonePadButton(type: .Delete), PhonePadButton(type: .Number, number: 0)]
    
    @State private var wrongInputAttempts: Int = 0
    @State private var codeString = ""
    @State private var loggingIn = false
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        
        if loggingIn && !loggedIn {
            VStack {
                ProgressView()
                LUIText("Logging in...")
                    .font(.system(size: geo.size.height*0.02))
                    .padding(.top, geo.size.height * 0.02)
            }
            .frame(maxHeight: .infinity)
        }
        else if loggedIn {
            
            VStack {
                LUIText("Welcome, Alice!")
                    .font(.system(size: geo.size.width * 0.08, weight: .light))
                    .padding(.vertical, geo.size.height * 0.03)
                
                VStack(spacing: geo.size.height * 0.03) {
                    
                    ForEach(0..<5, id: \.self) { index in
                        
                        let height = geo.size.height * 0.06
                        RoundedRectangle(cornerRadius: height/4)
                            .frame(height: height)
                            .foregroundColor(.gray)
                            .opacity(0.3)
                            .padding(.horizontal, geo.size.width * 0.1)
                    }
                    
                }
                Spacer()
                
                Button(action: {
                    withAnimation {
                        loggedIn = false
                        loggingIn = false
                    }
                    
                }, label: {
                    LUIText("Sign Out")
                })
                .font(.system(size: geo.size.width * 0.045))
                .padding(.bottom, geo.size.height * 0.02)
                
                LUIText("Balance: $27,773.28")
                    .font(.system(size: geo.size.width * 0.05, weight: .light))
                    .padding(.bottom, geo.size.height * 0.05)
            }
            .zIndex(.infinity)
        }
        else {
            VStack {
                Spacer()
                
                LUIText("Enter your PIN to login")
                    .font(.system(size: geo.size.width * 0.05))
                
                HStack {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .frame(width: geo.size.width * 0.03)
                            .foregroundColor(.mainColor)
                            .opacity(codeString.count > index ? 1 : 0.2)
                    }
                }
                .padding(geo.size.width * 0.02)
                .modifier(Shake(animatableData: CGFloat(wrongInputAttempts)))
                
                
                VStack {
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], content: {
                        ForEach(buttons) { button in
                            CircleButton(size: geo.size.width * 0.2, label: button, supportsDoneAction: false) {
                                pressedButton(button: button)
                            }
                        }
                    })
                }
                .padding(geo.size.width * 0.1)
                
                Spacer()
                
            }
            .frame(maxWidth: 450)
        }
    }
    
    func pressedButton(button: PhonePadButton) {
        if button.type == .Number {
            if codeString.count < 4 {
                
                withAnimation {
                    codeString += button.number.description
                }
                AudioPlayer.sharedInstance.playSound(sound: .pinPress)
                
                if codeString.count == 4 {
                    checkInput()
                }
            }
        }
        else {
            if !codeString.isEmpty {
                AudioPlayer.sharedInstance.playSound(sound: .pinDelete)
                codeString.removeLast()
            }
        }
    }
    
    func checkInput() {
        if codeString == "3428" { // haha, please don't do this in production 😂
            // success
            runAfter(seconds: 0.1) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    loggingIn = true
                }
                
                runAfter(seconds: 1) {
                    AudioPlayer.sharedInstance.playSound(sound: .success)
                    codeString = ""
                    withAnimation(.spring) {
                        loggedIn = true
                        loggingIn = false
                    }
                }
            }
        }
        else {
            wrongInput()
            AudioPlayer.sharedInstance.playSound(sound: .error)
            
            runAfter(seconds: 0.3) {
                codeString = ""
            }
        }
    }
    
    func wrongInput() {
        withAnimation(.easeInOut) {
            wrongInputAttempts += 1
        }
    }
}


struct CircleButton: View {
    
    let size: CGFloat
    let label: PhonePadButton
    let supportsDoneAction: Bool
    let action: () -> ()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LUIButton {
            action()
        } label: {
            ZStack {
                
                let isDelete = label.type == .Delete
                
                Circle()
                    .foregroundColor(getBackgroundColor())
                    .frame(width: size)
                
                ZStack {
                    if(isDelete) {
                        Image(systemName: "delete.left.fill")
                            .font(.system(size: size * 0.3))
                    }
                    else {
                        LUIText(label.number.description)
                    }
                }
                
                .font(.system(size: size * 0.4))
                .foregroundColor(getForegroundColor())
            }
            .contentShape(Rectangle())
        }
    }
    
    func getBackgroundColor() -> Color {
        switch label.type {
        case .Delete:
            return .clear
        case .Number:
            return colorScheme.isLight ? .gray.opacity(0.1) : .gray.opacity(0.2)
        }
    }
    
    func getForegroundColor() -> Color {
        switch label.type {
        case .Delete:
            return .red
        case .Number:
            return .mainColor.opacity(0.7)
        }
    }
}


struct PhonePadButton: Identifiable {
    
    let type: ButtonType
    var number: Int = 0
    let id = UUID()
}


enum ButtonType {
    case Delete
    case Number
}

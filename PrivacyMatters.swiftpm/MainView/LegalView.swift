//
//  LegalView.swift
//
//
//  Created by Leon Böttger on 23.02.24.
//

import SwiftUI

struct LegalView: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("SheetBackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false) {
                    LUIText("Legal")
                        .font(.largeTitle.bold())
                        .padding(.bottom)
                        .padding(.top, -20)
                    
                    Text(legalString)
                    .rounded()
                    .padding()
                    .background(Color("SheetForegroundColor").cornerRadius(20))
                    .padding(.bottom, 30)
                    .padding(.horizontal, isiPadOrMac() ? 30 : 15)
                }
                .toolbar(content: {
                    XButton {
                        showSheet = false
                    }
                })
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }
    }
}


public struct XButton: View {
    
    public init(action: @escaping () -> ()) {
        self.action = action
    }
    
    let action: () -> ()
    
    public var body: some View {
        RoundGrayButton(imageName: "xmark", action: action)
    }
}


public struct RoundGrayButton: View {
    
    public init(imageName: String, action: @escaping () -> ()) {
        self.imageName = imageName
        self.action = action
    }
    
    let imageName: String
    let action: () -> ()
    
    public var body: some View {
        LUIButton(action: action, label: {
            RoundGrayIcon(imageName: imageName)
        })
    }
}


public struct RoundGrayIcon: View {
    
    public init(imageName: String, color: Color = .grayColor) {
        self.imageName = imageName
        self.color = color
    }
    
    let imageName: String
    let color: Color
    
    public var body: some View {
        
        let sz = 16.5
        
        Image(systemName: imageName)
            .scaleEffect(0.9)
            .font(.system(size: 12).weight(.heavy))
            .foregroundColor(color)
            .frame(width: sz, height: sz)
            .padding(7)
            .background(Circle().foregroundColor(color.opacity(0.15)))
    }
}


#Preview {
    LegalView(showSheet: .constant(true))
}


fileprivate let legalString = """
This application makes use of the following resources:

Sounds were provided from https://notificationsounds.com and are covered under the Creative Commons Attribution 4.0 International License.

https://creativecommons.org/licenses/by/4.0/legalcode

Creative Commons Attribution 4.0 International Public License (2020/14/09)

[...]

Section 5 – Disclaimer of Warranties and Limitation of Liability.

Unless otherwise separately undertaken by the Licensor, to the extent possible, the Licensor offers the Licensed Material as-is and as-available, and makes no representations or warranties of any kind concerning the Licensed Material, whether express, implied, statutory, or other. This includes, without limitation, warranties of title, merchantability, fitness for a particular purpose, non-infringement, absence of latent or other defects, accuracy, or the presence or absence of errors, whether or not known or discoverable. Where disclaimers of warranties are not allowed in full or in part, this disclaimer may not apply to You.
To the extent possible, in no event will the Licensor be liable to You on any legal theory (including, without limitation, negligence) or otherwise for any direct, special, indirect, incidental, consequential, punitive, exemplary, or other losses, costs, expenses, or damages arising out of this Public License or use of the Licensed Material, even if the Licensor has been advised of the possibility of such losses, costs, expenses, or damages. Where a limitation of liability is not allowed in full or in part, this limitation may not apply to You.
The disclaimer of warranties and limitation of liability provided above shall be interpreted in a manner that, to the extent possible, most closely approximates an absolute disclaimer and waiver of all liability.

[...]


ConfettiSwiftUI
https://github.com/simibac/ConfettiSwiftUI

MIT License

Copyright (c) 2020 Simon Bachmann

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""

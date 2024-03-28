//
//  IntroductionView.swift
//
//
//  Created by Leon Böttger on 22.02.24.
//

import SwiftUI

public struct IntroductionView: View {
    
    public var body: some View {
        VStack {
            KeynoteInformationMainView(headerString: "Welcome to %@", appName: "PrivacyMatters", items: [
                ImageKeynoteViewItem(header: "Learn", subheader: "Learn all about the most interesting aspects of privacy.", imageName: "lock.fill"),
                ImageKeynoteViewItem(header: "Quizzes", subheader: "Solve all interactive quizzes to complete lessons.", imageName: "questionmark.circle.fill"),
                ImageKeynoteViewItem(header: "Important", subheader: "For the best experience, turn on sound and use your iPad in landscape mode.", imageName: "ipad.landscape")
            ])
            .if(isiPadOrMac(), transform: { view in
                view.frame(maxWidth: 500)
            })
            
            ColoredButton(label: "Continue") {
                AudioPlayer.sharedInstance.playSound(sound: .click)
                finishedAppIntroduction()
            }
        }
    }
    
    func finishedAppIntroduction() {
        
        if !LessonProgressModel.sharedInstance.appLaunchedBefore {
            LessonProgressModel.sharedInstance.canShowIntroductionSheet = false
            
            runAfter(seconds: 0.7) {
                LessonProgressModel.sharedInstance.appLaunchedBefore = true
            }
        }
    }
}


public struct KeynoteInformationMainView: View {
    
    public init(headerString: String, appName: String, items: [ImageKeynoteViewItem]) {
        self.headerString = headerString
        self.appName = appName
        self.items = items
    }
    
    let headerString: String
    let appName: String
    let items: [ImageKeynoteViewItem]
    
    public var body: some View {
        
        Spacer()
        
        TitleView(headerString: headerString, appName: appName)
            .padding(.top, -20)
        
        Spacer()
        
        InformationContainerView(items: items)
        
        Spacer()
    }
}


struct InformationContainerView: View {
    
    let items: [ImageKeynoteViewItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            InnerInformationContainerView(items: items)
        }
        .if(isiPadOrMac(), transform: { view in
            view.padding(.horizontal)
        })
    }
}


struct InnerInformationContainerView: View {
    
    let items: [ImageKeynoteViewItem]
    let colors: [Color] =  [.orange, .green, .blue]
    
    var body: some View {
        ForEach(items, id: \.self) { item in
            
            let index = items.firstIndex(of: item) ?? 0
            let color = colors[index % colors.count]
            
            InformationDetailView(title: item.header, subTitle: item.subheader, imageName: item.imageName, color: color)
        }
    }
}


struct TitleView: View {
    
    let headerString: String
    let appName: String
    
    var body: some View {
        
        VStack(spacing: 4) {
            
            AppIconView()
                .padding(.bottom)
            
            Text(String(format: headerString, appName))
                .foregroundColor(.white)
                .heavyText()
                .rounded()
                .lineSpacing(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.horizontal)
        }
    }
}


struct InformationDetailView: View {
    let title: String
    let subTitle: String
    let imageName: String
    var color: Color = Color.blue
    
    var body: some View {
        
        HStack() {
            
            ZStack {
                color
                LinearGradient(colors: [.clear, .white.opacity(0.3)], startPoint: .bottom, endPoint: .top)
            }
            .mask( Image(systemName: imageName)
                .font(.system(size: 25, weight: .semibold)))
            .frame(width: 40, height: 40)
            .padding(.leading, -5)
            
            VStack(alignment: .leading, spacing: 0) {
                LUIText(title)
                    .font(.headline)
                    .padding(.bottom, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LUIText(subTitle)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body)
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .padding(.horizontal)
        .padding(.horizontal)
    }
}


public struct ImageKeynoteViewItem: Hashable {
    
    public init(header: String, subheader: String, imageName: String) {
        self.header = header
        self.subheader = subheader
        self.imageName = imageName
    }
    
    public let header: String
    public let subheader: String
    public let imageName: String
}

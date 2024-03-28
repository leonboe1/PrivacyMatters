import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = LessonProgressModel.sharedInstance
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        let appLaunchedBefore = model.appLaunchedBefore
        
        ZStack {
            
            (colorScheme.isLight ? Color.white : Color.black).edgesIgnoringSafeArea(.all)
            
            Image("introductionBackgroundDark")
                .resizable()
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
                .opacity(colorScheme.isLight ? 0 : 0.2)
            
            if !appLaunchedBefore && model.canShowIntroductionSheet {
                IntroductionSheet()
            }
            else {
                ZStack {
                    GeometryReader { geo in
                        
                        let leftWidth = 300.0
                        let rightWidth = 400.0
                        let remainingWidth = geo.size.width - leftWidth - rightWidth
                        let splitView = remainingWidth > 300
                        
                        if splitView {
                            SplitViewMainView(leftWidth: leftWidth, rightWidth: rightWidth)
                        }
                        
                        else {
                            PhoneMainView()
                        }
                    }
                }
                .opacity(appLaunchedBefore ? 1 : 0)
            }
        }
        .animation(.easeInOut(duration: 0.7), value: model.canShowIntroductionSheet)
        .animation(.easeInOut(duration: 0.7), value: appLaunchedBefore)
    }
}


struct SplitViewMainView: View {
    
    let leftWidth: CGFloat
    let rightWidth: CGFloat
    @ObservedObject var model = LessonProgressModel.sharedInstance
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            
            LeftSidebarView()
                .frame(width: leftWidth)
            
            ZStack {
                LessonContentView(lesson: model.selectedLesson.lesson)
                    .frame(maxWidth: .infinity)
                
                Color.gray
                    .opacity(colorScheme.isLight ? 0 : 0.1)
                    .ignoresSafeArea(.all)
            }
            
            if colorScheme.isLight {
                Divider()
                    .ignoresSafeArea(edges: .vertical)
            }
            
            ZStack {
                
                Color.gray
                    .opacity(colorScheme.isLight ? 0 : 0.05)
                    .ignoresSafeArea(.all)
                    .allowsHitTesting(false)
                    .zIndex(-2)
                
                RightSidebarView()
                    .clipped()
                    .zIndex(-1)
            }
            .frame(width: rightWidth)
        }
    }
}


struct PhoneMainView: View {
    
    @State private var selectedTab = "Learn"
    @ObservedObject var model = LessonProgressModel.sharedInstance
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            LeftSidebarView()
                .tabItem {
                    Label("Lessons", systemImage: "house")
                }
                .tag("Lessons")
                .onChange(of: model.selectedLesson) { oldValue, newValue in
                    if selectedTab == "Lessons" {
                        selectedTab = "Learn"
                    }
                }
            
            LessonContentView(lesson: model.selectedLesson.lesson)
                .tabItem {
                    Label("Learn", systemImage: "square.and.pencil")
                }
                .tag("Learn")
            
            RightSidebarView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark")
                }
                .tag("Quiz")
        }
    }
}


struct LargeTitleView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 0) {
            
            LUIText(title)
                .font(.largeTitle.bold())
            
            LUIText(subtitle)
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 3)
        }
    }
}

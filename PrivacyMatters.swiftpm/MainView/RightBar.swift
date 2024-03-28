//
//  RightBar.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 09.02.24.
//

import SwiftUI

struct RightSidebarView: View {
    
    @ObservedObject var model = LessonProgressModel.sharedInstance
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            
            // query current quiz view
            model.selectedLesson.quizView()
        }
    }
}

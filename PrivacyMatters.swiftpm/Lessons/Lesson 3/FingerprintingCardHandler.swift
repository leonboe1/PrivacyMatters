//
//  FingerprintingCardHandler.swift
//
//
//  Created by Leon Böttger on 24.02.24.
//

import SwiftUI

/// Manages tapping of quiz cards
class FingerprintingCardHandler: ObservableObject {
    
    @Published var solvedQuiz = false
    @Published var selectedRequests = [Request]()
    @Published var wrongInputAttempts = 0
    
    init() {
        solvedQuiz = fingerprintingLessonContent.finished
    }
    
    func toggleRequest(request: Request) {
        
        if solvedQuiz {
            withAnimation {
                solvedQuiz = false
                selectedRequests = []
            }
        }
        
        if selectedRequests.contains(request) {
            deselectRequest(request: request)
        }
        else {
            selectRequest(request: request)
        }
    }
    
    private func selectRequest(request: Request) {
        
        withAnimation(.spring) {
            selectedRequests.append(request)
        }
        
        // Check if selected card is same user
        if selectedRequests.count == 2 {
            let success = isSamePerson()
            
            if success {
                withAnimation {
                    solvedQuiz = true
                }
         
                fingerprintingLessonContent.finished = true
                AudioPlayer.sharedInstance.playSound(sound: .success)
            }
            else {
                withAnimation(.easeInOut) {
                    wrongInputAttempts += 1
                }
                AudioPlayer.sharedInstance.playSound(sound: .error)
            }
            
            runAfter(seconds: success ? 1 : 0.5) {
                withAnimation(.spring) {
                    self.selectedRequests = []
                }
            }
        }
    }
    
    private func deselectRequest(request: Request) {
        withAnimation(.spring) {
            selectedRequests.removeAll(where: {$0 == request})
        }
    }
    
    private func isSamePerson() -> Bool {
        return selectedRequests.count == 2 && selectedRequests[0].userID == selectedRequests[1].userID
    }
    
    func getColor(index: Int) -> [Color] {
        switch index {
            case 0:
            return [Color(#colorLiteral(red: 1, green: 0.5803921569, blue: 0.3098039216, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7529411765, blue: 0.2588235294, alpha: 1))]
        case 1:
            return [Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)), Color(#colorLiteral(red: 0.1936409473, green: 0.7672969699, blue: 0.3610956669, alpha: 1))]
        case 2:
            return [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]
        default:
            return [Color(#colorLiteral(red: 0.6942194104, green: 0.671523869, blue: 0.9558958411, alpha: 1)), Color(#colorLiteral(red: 0.8086243762, green: 0.671523869, blue: 0.9558958411, alpha: 1))]
        }
    }
    
    func getRequest(index: Int) -> Request {
        switch index {
            case 0:
            return Request(url: "google.com", screenSize: "1920x1080", battery: "76", userID: 0)
        case 1:
            return Request(url: "amazon.com", screenSize: "1280x900", battery: "76", userID: 1)
        case 2:
            return Request(url: "apple.com", screenSize: "1920x1080", battery: "32", userID: 2)
        default:
            return Request(url: "github.com", screenSize: "1920x1080", battery: "76", userID: 0)
        }
    }
}


struct Request: Equatable {
    
    let url: String
    let screenSize: String
    let battery: String
    let userID: Int
}

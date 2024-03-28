//
//  SummaryArticle.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 13.02.24.
//

import Foundation

/// The article for lesson 5
let summaryLessonContent =

Lesson(topic: "Summary", icon: "flag.checkered", color: .green, content: [

    TextContent(text: "Wow, you have made it so far. In this course, you looked at some key aspects of privacy. You learned about technical details, the scope of data collection, and about protection mechanisms as well as why it even matters. Hopefully, you enjoyed the course and learned something new."),
    
    TextContent(text: "There is just one last challenge for you. Complete the quiz on the right side to recap what you have learned. If you solve everything correctly, you will receive a special award.", highlighted: true),
    
    TextContent(text: "If you want to learn more about this topic, take a look at the great paper [Simple Demographics Often Identify People Uniquely](https://dataprivacylab.org/projects/identifiability/paper1.pdf) by L. Sweeney.")

])

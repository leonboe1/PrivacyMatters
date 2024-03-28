//
//  DatasetsArticle.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 13.02.24.
//

import Foundation
import SwiftUI

/// The article for lesson 2
let datasetsLessonContent =

Lesson(topic: "Datasets", icon: "square.stack.3d.up.fill", color: Color(#colorLiteral(red: 0.3667442501, green: 0.422971189, blue: 0.9019283652, alpha: 1)), content: [
    
    TextContent(text: "In the previous lesson, we saw that huge amounts of data is collected all the time. Many companies claim that they only collect \"anonymous\" data. However, often this data is not really anonymous..."),
    
    TextContent(title: "Data Categories", text: "There are three categories for data. Identifiable data, pseudonymous data, and anonymous data. Identifiable data make it easy to link to people, for example by providing name and address. Pseudonymous data lack that information, but by transformation, it can be made identifiable. Anonymous data can't be transformed to link datasets to individuals."),
    
    TextContent(text: "On the right, you can access the pseudonymous database of the hospital. Can you guess the disease of Peter? You saw him unlocking his phone with the combination 100295. Hint: Tap on the computer.", highlighted: true),
    
    TextContent(title: "The big problem", text: "Problematic is the collection of pseudonymous data. Even though they do not mention identities explicitly, it is easy to underestimate how easy it is to restore them. Shockingly, over 87% of Americans are identifiable by only three attributes: Date of birth, gender and ZIP code! The same goes for similar combinations. As a result, privacy can be invaded by data we did not even consider to be an issue."),
    
])

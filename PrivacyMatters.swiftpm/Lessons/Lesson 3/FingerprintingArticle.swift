//
//  FingerprintingArticle.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 13.02.24.
//

import Foundation

/// The article for lesson 3
let fingerprintingLessonContent =

Lesson(topic: "Browser Fingerprinting", icon: "globe", color: .red, content: [

    TextContent(text: "In the last lesson, we saw that even with relatively little information, a lot of damage can be done. Therefore, it is a good thing to always reconsider if a certain party really needs to have data about you. In the online world, this is often not that easy. Companies might track your activities without you noticing it."),
    
    TextContent(title: "Browser Fingerprinting", text: "An increasingly popular tool for tracking your activities is Browser Fingerprinting. With this tech, companies are able to link browser activities even if your Internet addresses changes. Metadata transmitted by the browser is aggregated to create a unique profile. This data may include the browser version, installed plugins, or performance of the computer."),
    
    TextContent(text: "On the right, 4 requests to various websites are shown, including browser metadata. Can you tell which requests came from the same user? Tap on both of them.", highlighted: true),
    
    TextContent(title: "Countermeasures", text: "Modern browsers already adapted countermeasures against fingerprinting. For example, Safari fools trackers by providing fake metadata. Make sure you enable technologies like \"Prevent Cross-Site-Tracking\" or \"Hide IP Address\" to make the most out of anti-fingerprinting technologies.")

])

//
//  Helpers.swift
//  PrivacyMatters
//
//  Created by Leon Böttger on 10.02.24.
//

import SwiftUI

/// Runs the action after `seconds`
public func runAfter(seconds: Double, _ action: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        action()
    }
}


public extension ColorScheme {
    
    /// True, if light mode
    var isLight: Bool {
        self == ColorScheme.light
    }
    
    /// True, if dark mode
    var isDark: Bool {
        self == ColorScheme.dark
    }
}


extension String {
    
    /// Transforms to the localized markdown attributed string
    func localizedMarkdown() -> AttributedString {
        let localizedString = NSLocalizedString(self, comment: "")
        let attributedString = try? AttributedString(markdown: localizedString, options: AttributedString.MarkdownParsingOptions(
            allowsExtendedAttributes: true,
            interpretedSyntax: .inlineOnlyPreservingWhitespace,
            failurePolicy: .returnPartiallyParsedIfPossible
        ))
        return attributedString ?? AttributedString(localizedString)
    }
}


/// Returns if device is iPad or a Mac
public func isiPadOrMac() -> Bool {
#if !os(watchOS)
    let device = UIDevice.current
    
    let iPad = device.model == "iPad"
    
    return iPad
#else
    return false
#endif
}

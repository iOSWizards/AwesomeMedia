//
//  UITextInput+Quests.swift
//  Quests
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 23/02/17.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import UIKit

extension UITextInput {
    public var selectedRange: NSRange? {
        guard let range = self.selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: range.start)
        let length = offset(from: range.start, to: range.end)
        return NSRange(location: location, length: length)
    }
}

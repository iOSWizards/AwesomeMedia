//
//  Constants.swift
//  Mindvalley Academy
//
//  Created by Mindvalley's Macbook on 07/04/2016.
//  Copyright © 2016 Mindvalley. All rights reserved.
//

import Foundation

public struct HTMLConfiguration {
    //<html><head><style>h1 {font-family: 'Gilroy-Bold'; font-weight: 100; font-size: 27px; line-height: 35px; color: #444444;}h2 {font-family: 'Gilroy-Bold'; font-weight: 100; font-size: 22px; line-height: 35px; color: #444444; margin-top: 1.1em;}blockquote {font-family: 'System-Regular'; font-weight: 100; font-size: 18px; color: #444444; line-height: 24px;}span {font-family: 'System-Regular'; font-weight: 100; font-size: 18px; color: #444444; line-height: 24px;}body {font-family: 'System-Regular'; font-weight: 100; font-size: 18px; color: #444444; line-height: 24px;}i {font-family: 'System-Regular'; font-weight: 100; font-size: 18px; color: #444444; line-height: 24px;}b {font-family: 'System-Regular'; font-weight: 700; font-size: 18px; color: #444444; line-height: 24px;}ul li p, ol li p {margin: 0;}ul li, ol li {line-height: 0.1em}</style></head><body>

    struct HTMLCss {
        static var htmlHeader: String {
            #if QuestsTVApp
                let textColor = "color: #313131;"
                let textSize = "font-size: 30px;"
                let textFont = "font-family: 'Open Sans', sans-serif;"
                let textFontWeight = "font-weight: normal;"
                let textBoldFontWeight = "font-weight: 700;"
                let textLineHeight = "line-height: 40px;"
                let titleFont = "font-family: 'Open Sans', sans-serif; font-weight: bold"
                let titleSize = "font-size: 50px;"
                let titleLineHeight = "line-height: 48px;"
                let title2Size = "font-size: 40px;"
                let titleFontWeight = "font-weight: 100;"
                let headerFont = "font-family: 'Gilroy-Medium';"
                let headerFontItalic = "font-family: 'Gilroy-BoldItalic'; !important"
                let headerFontBold = "font-weight: 700;"
                let italicFont = "font-style: italic;"
                let boldFont = "font-weight: bold;"
                let normalFontWeight = "font-weight: normal;"
            #else
                let textColor = "color: #444444;"
                let textSize = "font-size: 18px;"
                let textFont = "font-family: 'Open Sans', sans-serif;"
                let textLineHeight = "line-height: 24px;"
                let titleSize = "font-size: 27px;"
                let titleLineHeight = "line-height: 35px;"
                let title2Size = "font-size: 22px;"
                let headerFont = "font-family: 'Gilroy-Medium';"
                let headerFontItalic = "font-family: 'Gilroy-BoldItalic'; !important"
                let headerFontBold = "font-weight: 700;"
                let italicFont = "font-style: italic;"
                let boldFont = "font-weight: bold;"
                let normalFontWeight = "font-weight: normal;"
            #endif

            var htmlHeader = "<html><head><style>"

            htmlHeader += "h1 {\(headerFont) \(headerFontBold) \(titleSize) \(titleLineHeight) \(textColor)}"
            htmlHeader += "h2 {\(headerFont) \(headerFontBold) \(title2Size) \(titleLineHeight) \(textColor)}"
            htmlHeader += "h1 i, h1 > i, h2 i, h2 > i {\(headerFontItalic)}"
            htmlHeader += "blockquote {\(textFont) \(normalFontWeight) \(textSize) \(textColor) \(textLineHeight)}"
            htmlHeader += "span {\(textFont) \(textSize) \(textColor) \(textLineHeight)}"
            htmlHeader += "body {\(textFont) \(normalFontWeight) \(textSize) \(textColor) \(textLineHeight) white-space: pre-line;}"
            htmlHeader += "p {\(textFont) \(normalFontWeight) \(textSize) \(textColor) \(textLineHeight)}"
            htmlHeader += "p i, p > i {\(italicFont)}"
            htmlHeader += "p b, p strong {\(boldFont)}"
            htmlHeader += "i {\(italicFont)}"
            htmlHeader += "b {\(boldFont) \(textColor) \(textLineHeight)}"
            htmlHeader += "b > i, b i {\(boldFont) \(italicFont)}"
            htmlHeader += "b, strong {\(boldFont)}"
            htmlHeader += "ul, ol, li {\(textFont) \(normalFontWeight) \(textSize) \(textColor) \(textLineHeight)}"

            htmlHeader += "ol br, li br {display: none}"
            htmlHeader += "ul, ol, ul li, ol li { margin-bottom: 1rem }"
            htmlHeader += "h1 { margin-top: 20px; !important}"

            htmlHeader += "p:empty, ul:empty, h2:empty, h1:empty, li:empty, span:empty { display: none; height: 0px; margin: 0; padding: 0;}"

            htmlHeader += "</style></head><body>"

            return htmlHeader
        }

        static let htmlFooter = "</body></html>"
    }
}

extension String {

    public var cleaned: String {
        return self.replacingOccurrences(of: "/>", with: ">")
            .replacingOccurrences(of: " >", with: ">")
            .replacingOccurrences(of: "<br>", with: "")
    }

    public var attributedWithCSS: NSAttributedString? {
        return (HTMLConfiguration.HTMLCss.htmlHeader+self+HTMLConfiguration.HTMLCss.htmlFooter).utf8Data?.attributedString
    }
}

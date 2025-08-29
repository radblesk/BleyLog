//
//  LanguageData.swift
//  BleyLog
//
//  Created by Radoslav Bley on 29/08/2025.
//

import Foundation

extension Language {
    static let exampleLanguage = Language(title: "Swift", courses: [])
    
    static let languages = [
        Language(title: "Swift", courses: Course.swiftCourses),
        Language(title: "Next.js"),
        Language(title: "React"),
        Language(title: "TypeScript"),
    ]
}

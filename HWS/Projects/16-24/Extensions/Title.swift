//
//  Title.swift
//  HWS
//
//  Created by Radoslav Bley on 17/08/2025.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.title.bold())
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

//
//  FlagImage.swift
//  BleyLog
//
//  Created by Radoslav Bley on 17/08/2025.
//

import SwiftUI

struct FlagImage: View {
    var countries: [String] = []
    var number: Int = 0

    var body: some View {
        Image(countries[number])
            .clipShape(.capsule)
            .shadow(radius: 12, y: 10)
    }
}

#Preview {
    FlagImage(countries: ["Italy"], number: 0)
}

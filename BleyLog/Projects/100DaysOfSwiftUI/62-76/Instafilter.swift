//
//  Instafilter.swift
//  BleyLog
//
//  Created by Radoslav Bley on 05/09/2025.
//

import PhotosUI
import SwiftUI

struct Instafilter: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5

    var body: some View {
        VStack {
            Spacer()

            if let processedImage {
                processedImage
                    .resizable()
                    .scaledToFit()
            } else {
                ContentUnavailableView(
                    "No picture",
                    systemImage: "photo.badge.plus",
                    description: Text("Tap to import a photo")
                )
            }

            Spacer()

            HStack {
                Text("Intensity")
                Slider(value: $filterIntensity)
            }

            HStack {
                Button("Change filter", action: changeFilter)
                Spacer()
            }
        }
        .padding([.horizontal, .bottom])
        .navigationTitle("InstaFilter")
    }

    func changeFilter() {

    }
}

#Preview {
    NavigationStack {
        Instafilter()
    }
}

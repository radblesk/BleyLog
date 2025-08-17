//
//  SettingsAboutView.swift
//  HWS
//
//  Created by Radoslav Bley on 14/08/2025.
//

import SwiftUI

struct SettingsAboutView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(
                    colors: [.accentColor, .black],
                    center: .top,
                    startRadius: -300,
                    endRadius: 700
                )
                .edgesIgnoringSafeArea(.all)
                VStack {
                    Text(
                        "Developed by [Radoslav Bley](https://www.radobley.sk)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text(
                        "v0.1.0 \(Date.now.formatted(date: .numeric, time: . omitted))"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(50)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 32))
                .navigationTitle("About")
                #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                #endif
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    SettingsAboutView()
}

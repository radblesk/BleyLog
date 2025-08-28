//
//  Animations.swift
//  BleyLog
//
//  Created by Radoslav Bley on 26/08/2025.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct Animations: View {
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero

    let letters = Array("Hello SwiftUI")
    @State private var enabled2 = false
    @State private var dragAmount2 = CGSize.zero

    @State private var isShowingRed = false

    @State private var isShowingRed2 = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading) {
                    Text("Animated button")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    HStack {
                        VStack {
                            Button("Tap me") {
                                enabled.toggle()
                            }
                            .frame(width: 200, height: 200)
                            .background(enabled ? .blue : .red)
                            .foregroundStyle(.white)
                            .animation(nil, value: enabled)
                            .clipShape(
                                .rect(cornerRadius: enabled ? 60 : 0)
                            )
                            .animation(
                                .spring(duration: 1, bounce: 0.9),
                                value: enabled
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }

                VStack(alignment: .leading) {
                    Text("Drag Gesture animation")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    HStack {
                        VStack {
                            LinearGradient(
                                colors: [.yellow, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(width: 300, height: 200)
                            .clipShape(.rect(cornerRadius: 10))
                            .offset(dragAmount)
                            .gesture(
                                DragGesture()
                                    .onChanged {
                                        dragAmount = $0.translation
                                    }
                                    .onEnded { _ in
                                        withAnimation(.bouncy) {
                                            dragAmount = .zero
                                        }
                                    }
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }

                VStack(alignment: .leading) {
                    Text("Animated text")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    HStack {
                        VStack {
                            HStack(spacing: 0) {
                                ForEach(0..<letters.count, id: \.self) {
                                    num in
                                    Text(String(letters[num]))
                                        .padding(5)
                                        .font(.title)
                                        .background(
                                            enabled2 ? .blue : .red
                                        )
                                        .offset(dragAmount2)
                                        .animation(
                                            .linear.delay(Double(num) / 20),
                                            value: dragAmount2
                                        )
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged {
                                        dragAmount2 = $0.translation
                                    }
                                    .onEnded { _ in
                                        dragAmount2 = .zero
                                        enabled2.toggle()
                                    }
                            )
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }

                VStack(alignment: .leading) {
                    Text("Showing/Hiding views")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    HStack {
                        VStack {
                            Button("Tap Me") {
                                withAnimation {
                                    isShowingRed.toggle()
                                }
                            }

                            if isShowingRed {
                                Rectangle()
                                    .fill(.red)
                                    .frame(width: 100, height: 100)
                                    .transition(
                                        .asymmetric(
                                            insertion: .scale,
                                            removal: .opacity
                                        )
                                    )
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }

                VStack(alignment: .leading) {
                    Text("Custom transitions")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    HStack {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(.blue)
                                    .frame(width: 200, height: 200)

                                if isShowingRed2 {
                                    Rectangle()
                                        .fill(.red)
                                        .frame(width: 200, height: 200)
                                        .transition(.pivot)
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    isShowingRed2.toggle()
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }

            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Animations")
    }
}

#Preview {
    NavigationStack {
        Animations()
    }
}

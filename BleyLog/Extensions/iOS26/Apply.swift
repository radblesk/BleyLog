//
//  Apply.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}

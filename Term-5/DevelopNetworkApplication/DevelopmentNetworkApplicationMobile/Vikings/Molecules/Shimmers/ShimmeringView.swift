//
//  ShimmeringView.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 20.09.2023.
//

import SwiftUI

struct ShimmeringView: View {
    private let colors = [
        Color(uiColor: .bgAshToCoal),
        Color(uiColor: UIColor.systemGray5),
        Color(uiColor: .bgAshToCoal)
    ]
    
    @State private var isAnimating = false
    @State private var startPoint = UnitPoint(x: -1.8, y: -1.2)
    @State private var endPoint = UnitPoint(x: 0, y: -0.2)
    
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: false)
            ) {
                startPoint = .init(x: 1, y: 1)
                endPoint = .init(x: 2.5, y: 2.2)
            }
        }
    }
}

#Preview {
    ShimmeringView()
}

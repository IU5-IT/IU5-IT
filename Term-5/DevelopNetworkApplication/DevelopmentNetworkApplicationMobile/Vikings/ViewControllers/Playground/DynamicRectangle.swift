//
//  DynamicRectangle.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct DynamicRectangle: View {
    @State private var rotatino: CGFloat = .zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous)
                .frame(width: .rectWidth, height: .rectHeight)
                .foregroundStyle(Color.strokeColor)
                .rotationEffect(.degrees(rotatino))
                .mask {
                    RoundedRectangle(cornerRadius: .cornerRadius, style: .continuous)
                        .stroke(lineWidth: .lineWidth)
                        .frame(width: .maskWidth, height: .maskHeight)
                }

            Text("Привет")
                .font(.title)
                .foregroundStyle(Color.strokeColor)
                .bold()
        }
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                rotatino = .rotation
            }
        }
    }
}

#Preview {
    DynamicRectangle()
}

// MARK: - Constants

private extension Color {

    static let backgroundColor: Self = .clear
    static let strokeColor: LinearGradient = .init(
        colors: [Color.mint, .blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

private extension CGFloat {

    static let cornerRadius: CGFloat = 20
    static let rotation: CGFloat = 360
    static let lineWidth: CGFloat = 7

    static let rectWidth: CGFloat = 130
    static let maskWidth: CGFloat = 256
    static let rectHeight: CGFloat = 500
    static let maskHeight: CGFloat = 340
}

//
//  View+Ext.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 17.09.2023.
//

import SwiftUI

extension View {
    
    func frame(edge size: CGFloat) -> some View {
        self
            .frame(width: size, height: size)
    }
    
    func borderRectangle<S: ShapeStyle>(
        _ color: S,
        _ corner: CGFloat,
        _ lineWidth: CGFloat
    ) -> some View {
        self
            .overlay {
                RoundedRectangle(cornerRadius: corner)
                    .stroke(lineWidth: lineWidth)
                    .fill(color)
            }
    }
    
    var leadingAlignment: some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func offset(
        coordingateSpace: CoordinateSpace,
        completion: @escaping (CGFloat) -> Void
    ) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: coordingateSpace).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        completion(value)
                    }
            }
        }
    }

    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}

fileprivate struct ShimmerEffectHelper: ViewModifier {
    @State private var moveTo: CGFloat = -0.7
    var config: ShimmerConfig

    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        GeometryReader {
                            let size = $0.size

                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                        .fill(
                                            .linearGradient(
                                                colors: [
                                                    .white.opacity(0),
                                                    config.highlight.opacity(config.highlightOpactiry),
                                                    .white.opacity(0)
                                            ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .blur(radius: config.blur)
                                        .rotationEffect(.init(degrees: -70))
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        .mask {
                            content
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}

struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = .zero
    var highlightOpactiry: CGFloat = 1
    var speed: CGFloat = 2
}

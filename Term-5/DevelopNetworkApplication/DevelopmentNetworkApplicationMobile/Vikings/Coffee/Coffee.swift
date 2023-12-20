//
//  Coffees.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct Coffees: View {
    @State private var coffees: [CoffeeModel] = []
    @State private var offsetY: CGFloat = .zero
    @State private var currentIndex: CGFloat = .zero

    var body: some View {
        GeometryReader {
            let size = $0.size
            let cardSize = size.width * 0.8

            LinearGradient(
                colors: [
                .clear,
                .brown.opacity(0.2),
                .brown.opacity(0.45),
                .brown
            ], 
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()

            HeaderView()

            VStack(spacing: 0) {
                ForEach(coffees) { coffee in
                    CoffeeView(coffee: coffee, size: size)
                }
            }
            .frame(width: size.width)
            .padding(.top, size.height - cardSize)
            .offset(y: offsetY)
            .offset(y: -currentIndex * cardSize)
        }
        .coordinateSpace(name: "SCROLL")
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    offsetY = value.translation.height * 0.4
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut) {
                        if translation > 0 {
                            if currentIndex > 0 && translation > 250 {
                                currentIndex -= 1
                            }
                        } else {
                            if currentIndex < CGFloat(coffees.count - 1) && -translation > 250 {
                                currentIndex += 1
                            }
                        }

                        offsetY = .zero
                    }
                })
        )
        .onAppear {
            coffees = .coffees
        }
    }

    func HeaderView() -> some View {
        VStack {
            HStack {
                Button{

                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundStyle(.black)
                }

                Spacer()

                Button{

                } label: {
                    Image(systemName: "basket")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
            }

            GeometryReader {
                let size = $0.size

                HStack(spacing: 0) {
                    ForEach(coffees) { coffee in
                        VStack(spacing: 15) {
                            Text(coffee.title)
                                .font(.title.bold())
                                .multilineTextAlignment(.center)
                            Text(coffee.price)
                        }
                        .frame(width: size.width)
                    }
                }
                .offset(x: currentIndex * -size.width)
                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8), value: currentIndex)
            }
            .padding(.top, -5)
        }
        .padding(15)
    }
}

#Preview {
    Coffees()
}

struct CoffeeView: View {
    var coffee: CoffeeModel
    var size: CGSize

    var body: some View {
        let cardSize = size.width * 0.8

        let maxCardsDisplaySize = size.width * 3

        GeometryReader {
            let _size = $0.size
            let offset = $0.frame(in: .named("SCROLL")).minY - (size.height - cardSize)
            let scale = offset <= 0 ? (offset / maxCardsDisplaySize) : 0
            let reducedScale = 1 + scale
            let currentSizeScale = offset / cardSize
            Image(coffee.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: _size.width, height: _size.height)
                .scaleEffect(
                    reducedScale < 0
                    ? 0.001
                    : reducedScale, anchor: .init(
                        x: 0.5,
                        y: 1 - (currentSizeScale / 2.4)
                    )
                )
                .scaleEffect(offset > 0 ? 1 + currentSizeScale : 1, anchor: .top)
                .offset(y: offset > 0 ? currentSizeScale * 200 : 0)
                .offset(y: currentSizeScale * -130)

        }
        .frame(height: cardSize)
    }
}

// MARK: - Mock data

private extension [CoffeeModel] {

    static let coffees: [CoffeeModel] = [
        CoffeeModel(imageName: "coffee", title: "Coffee - 1", price: "102 $"),
        CoffeeModel(imageName: "coffee", title: "Coffee - 1", price: "102 $"),
        CoffeeModel(imageName: "coffee", title: "Coffee - 1", price: "102 $"),
        CoffeeModel(imageName: "coffee", title: "Coffee - 1", price: "102 $"),
        CoffeeModel(imageName: "coffee", title: "Coffee - 1", price: "102 $"),
        CoffeeModel(imageName: "coffee", title: "Coffee - 1", price: "102 $"),
    ]
}

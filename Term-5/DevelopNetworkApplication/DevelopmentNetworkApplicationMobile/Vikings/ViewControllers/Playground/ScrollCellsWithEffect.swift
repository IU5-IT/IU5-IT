//
//  TestCard.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 28/10/2023.
//

import SwiftUI

struct Card: Identifiable, Hashable, Equatable {
    let id = UUID()
    let image: UIImage
    var previousOffset: CGFloat = .zero
}

struct TestCard: View {
    @State private var cards: [Card] = [
        Card(image: UIImage(named: "mightyK1ngRichard")!),
        Card(image: UIImage(named: "mightyK1ngRichard")!),
        Card(image: UIImage(named: "mightyK1ngRichard")!),
        Card(image: UIImage(named: "mightyK1ngRichard")!),
        Card(image: UIImage(named: "mightyK1ngRichard")!),
        Card(image: UIImage(named: "mightyK1ngRichard")!)
    ]

    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(cards) { card in
                            CardView(card)
                        }
                    }
                    .padding(.trailing, size.width - 180)
                    .scrollTargetLayout()
                }
                .clipShape(.rect(cornerRadius: 25))
                .scrollTargetBehavior(.viewAligned)
            }
            .padding(.horizontal, 15)
            .padding(.top, 30)
            .frame(height: 210)

            Spacer(minLength: 0)
        }
    }
}

private extension TestCard {

    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        GeometryReader {
            let size = $0.size
            let minX = $0.frame(in: .scrollView).minX
            let reducingWidth = (minX / 190) * 130
            let cappedWidth = min(reducingWidth, 130)
            let frameWidth = size.width - (minX > 0 ? cappedWidth : -cappedWidth)

            Image(uiImage: card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .frame(width: frameWidth)
                .clipShape(.rect(cornerRadius: 25))
                .offset(x: minX > 0 ? 0 : -cappedWidth)
                .offset(x: -card.previousOffset)
        }
        .frame(width: 180, height: 200)
        .offsetX { offset in
            let reducingWidth = (offset / 190) * 130
            let index = cards.indexOf(card)
            if cards.indices.contains(index + 1) {
                cards[index + 1].previousOffset = (offset < 0 ? 0 : reducingWidth)
            }
        }
    }
}

#Preview {
    TestCard()
}


private extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView).minX
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: { value in
                            completion(value)
                        })
                }
            }
    }
}

extension [Card] {
    func indexOf(_ card: Card) -> Int {
        return self.firstIndex(of: card) ?? 0
    }
}

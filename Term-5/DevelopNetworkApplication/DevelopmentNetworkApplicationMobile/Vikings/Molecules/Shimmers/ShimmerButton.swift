//
//  ShimmerButton.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 26/10/2023.
//

import SwiftUI

struct ShimmerButton: View {

    var text: String!
    var handler: MKREmptyBlock

    var body: some View {
        Button {
            handler()
        } label: {
            Text(text)
                .font(.title)
                .fontWeight(.black)
                .shimmer(
                    .init(
                        tint: .mint,
                        highlight: .blue,
                        blur: 5,
                        speed: 2
                    )
                )
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.red.gradient)
                )
        }
    }
}

#Preview {
    ShimmerButton(text: "mightyK1ngRichard") {
        print("Tap!")
    }
}

//
//  TabBarView.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import SwiftUI

struct TabBarItem: Identifiable {
    let id: Int
    let imageTitle: String
}

struct TabBarView: View {
    let buttons: [TabBarItem] = [
        TabBarItem(id: 0, imageTitle: "house"),
        TabBarItem(id: 1, imageTitle: "list.clipboard"),
        TabBarItem(id: 2, imageTitle: "person")
    ]
    @State private var selectedItem = 0

    var body: some View {
        HStack {
            ForEach(buttons) { button in
                Button {
                    selectedItem = button.id

                } label: {
                    Image(systemName: button.imageTitle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 26, height: 26)
                        .padding(10)
                        .background(
                            Circle().fill(
                                button.id == selectedItem
                                ? LinearGradient.kingGradient
                                : LinearGradient.white
                            )
                        )
                        .foregroundStyle(
                            button.id == selectedItem
                            ? .white
                            : .black
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [.black, .secondary, .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).opacity(0.9))
                .blur(radius: 0.5)
        )

    }
}

#Preview {
    MainView()
}

#Preview {
    TabBarView()
}

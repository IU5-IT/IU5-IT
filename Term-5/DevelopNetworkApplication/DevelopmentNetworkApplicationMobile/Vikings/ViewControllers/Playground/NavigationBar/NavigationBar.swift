//
//  NavigationBar.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import SwiftUI

struct NavigationBar: View {
    @State private var offsetY: CGFloat = 0
    @State private var showSearcBar = false

    var body: some View {
        GeometryReader { proxy in
            let safeAreaTop = proxy.safeAreaInsets.top
            ScrollView {
                VStack {
                    HeaderView(safeAreaTop)
                        .offset(y: -offsetY)
                        .zIndex(1)

                    VStack {
                        ForEach(1...10, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(height: 220)
                        }
                    }
                    .padding(15)
                    .zIndex(0)
                }
                .offset(coordingateSpace: .named(String.scrollView)) { offset in
                    offsetY = offset
                    showSearcBar = (-offset > 80) && showSearcBar
                }
            }
            .coordinateSpace(name: String.scrollView)
            .ignoresSafeArea(.container , edges: .top)
        }
    }

    @ViewBuilder
    func HeaderView(_ safeAreaTop: CGFloat) -> some View {
        let progress = -(offsetY / 80) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                HStack {
                    Image(systemName: "magnifyingglass")

                    TextField("Search", text: .constant(""))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.15))
                )
                .opacity(showSearcBar ? 1 : 1 + progress)


                Button {

                } label: {
                    Image("not_found")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(edge: 35)
                        .background {
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }
                        .opacity(showSearcBar ? 0 : 1)

                }
                .overlay {
                    if showSearcBar {
                        Button {
                            showSearcBar = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }

                    }
                }
            }
            
            HStack {
                CustomButton(
                    symbolImage: "rectangle.portrait.and.arrow.forward",
                    title: "Deposit"
                ) {

                }

                CustomButton(
                    symbolImage: "dollarsign",
                    title: "Withdraw"
                ) {

                }

                CustomButton(
                    symbolImage: "qrcode",
                    title: "Code"
                ) {

                }

                CustomButton(
                    symbolImage: "qrcode.viewfinder",
                    title: "Scanning"
                ) {

                }
            }
            .padding(.horizontal, -progress * 50)
            .padding(.top, 10)
            .offset(y: progress * 65)
            .opacity(showSearcBar ? 0 : 1)
        }
        .overlay(alignment: .topLeading) {
            Button {
                showSearcBar = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .offset(x: 13, y: 10)
            .opacity(showSearcBar ? 0 : -progress)

        }
        .animation(.easeInOut(duration: 0.2), value: showSearcBar)
        .padding([.horizontal, .bottom], 15)
        .padding(.top, safeAreaTop + 10)
        .background(
            Rectangle()
                .fill(.red.gradient)
                .padding(.bottom, -progress * 85)
        )
    }

    @ViewBuilder
    func CustomButton(
        symbolImage: String,
        title: String,
        onClick: @escaping () -> Void
    ) -> some View {
        let progress = -(offsetY / 40) > 1 ? -1 : (offsetY > 0 ? 0 : (offsetY / 80))
        Button {
            // ?
        } label: {
            VStack(spacing: 8) {
                Image(systemName: symbolImage)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                    .frame(edge: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.white)
                    )

                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundStyle(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .opacity(1 + progress)
        .overlay {
            Image(systemName: symbolImage)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .opacity(-progress)
                .offset(y: -10)
        }

    }
}

#Preview {
    NavigationBar()
}

// MARK: - Constants

private extension String {

    static let scrollView = "SCROLLVIEW"
}

//
//  PersonCabinet.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import SwiftUI

struct PersonCabinet: View {
    @State private var isSubscribe = false
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        GeometryReader {
            let width = $0.size.width
            VStack(spacing: 0) {
                MKRImageView(configuration: .headerConfiguration(width))

                UserDescriptionView()
                    .offset(y: -25)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - AuthorView

private extension PersonCabinet {

    func UserDescriptionView() -> some View {
        VStack {
            Spacer()
                .frame(height: .imageSize / 2)

            Text(mainViewModel.currentUser.authorName)
                .font(.system(size: 23, weight: .heavy, design: .rounded))
            Text(mainViewModel.currentUser.post ?? .noPost)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.backgroundColor)
        .cornerRadius(20)
        .overlay(alignment: .top) {
            MKRImageView(configuration: .imageConfiguration(author: mainViewModel.currentUser))
                .padding(.imagePadding)
                .background(
                    Circle()
                        .fill(Color.backgroundColor)
                        .frame(width: .imageSize + 10, height: .imageSize + 10)
                )
                .offset(y: -.imageOffset)
        }
    }
}

// MARK: - MKRImageView Configuration

private extension MKRImageView.Configuration {

    static func imageConfiguration(author: AuthorModel) -> Self {
        .basic(kind: .custom(
            url: author.imageURL,
            mode: .fill,
            imageSize: .init(edge: .imageSize),
            imageCornerRadius: .imageCornerRadius,
            imageBorderWidth: .zero,
            imageBorderColor: nil,
            placeholderLineWidth: .zero,
            placeholderImageSize: .zero)
        )
    }

    static func headerConfiguration(_ width: CGFloat) -> Self {
        .basic(kind: .custom(
            url: .mockDragonUrl,
            mode: .fill,
            imageSize: CGSize(width: width, height: .headerImageSize),
            imageCornerRadius: .zero,
            imageBorderWidth: .zero,
            imageBorderColor: nil,
            placeholderLineWidth: .zero,
            placeholderImageSize: .zero))
    }
}

// MARK: - Constants

private extension AuthorModel {

    static let data = AuthorModel(id: 0, authorName: "mightyK1ngRichard", post: "iOS Developer", imageURL: .mockLoadingUrl)
}

private extension String {

    static let noPost = "Без должности"
    static let hasSubscribe = "Подписаться"
    static let noSubscribe = "Отписаться"
}

private extension CGFloat {

    static let imageSize: CGFloat = 100
    static let imagePadding: CGFloat = 5
    static let imageCornerRadius: CGFloat = .imageSize / 2
    static let headerImageSize: CGFloat = 170
    static let imageOffset: CGFloat = .imageSize / 2
}

private extension Color {

    static let backgroundColor = Color(uiColor: .bgAshToCoal)
}

// MARK: - Preview

#Preview {
    PersonCabinet()
        .environmentObject(MainViewModel())
}

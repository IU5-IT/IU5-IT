//
//  HikeView.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import SwiftUI

struct HikeView: View {

    var hike: HikeModel!
    var width: CGFloat!

    @available(iOS 17.0, *)
    var body: some View {
        VStack {
            AvatarView()
            Divider()
            Text(hike.hikeName)
                .font(.system(size: 25, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            Text("Дата начала похода: \(hike.dateStartHike)")
                .font(.system(size: 11, weight: .light, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

            ScrollViewCitiew(width: width)

            Text(hike.description)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .font(.system(size: 16, design: .rounded))
                .leadingAlignment
        }

        .padding(.vertical, 10)
        .background(Color(uiColor: .bgAshToCoal))
        .cornerRadius(15)
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}

// MARK: - DetailCityView

private extension HikeView {

    func AvatarView() -> some View {
        HStack {
            MKRImageView(configuration: .authorImageConfiguration(url: hike.author.imageURL))
            VStack {
                Text(hike.author.authorName)
                    .font(.headline)
                    .leadingAlignment
                Text("• " + (hike.author.post ?? "iOS engineer"))
                    .font(.caption)
                    .leadingAlignment

                Text("опубликовано: \(hike.dateApprove)")
                    .font(.system(size: 10, weight: .light, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .leadingAlignment
        }
        .padding(.leading)
    }
}

private extension HikeView {

    @ViewBuilder
    func ScrollViewCitiew(width: CGFloat) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(hike.destinationHikes) { dh in
                    ZStack(alignment: .bottom) {
                        MKRImageView(
                            configuration: .init(
                                url: dh.city.imageURL,
                                imageSize: CGSize(width: width - 30, height: width * 0.5),
                                imageCornerRadius: 10,
                                placeholderImageSize: 40
                            )
                        )

                        VStack {
                            Text(dh.city.cityName ?? "Город без названия")
                                .font(
                                    .system(
                                        size: 22,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )

                            Text("Город № \(dh.serialNumber)")
                                .font(.footnote)
                        }
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.6))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal, 10)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

// MARK: - MKRImageView Configuration

private extension MKRImageView.Configuration {

    static func imageConfiguration(
        url: URL?,
        width: CGFloat
    ) -> Self {
        .basic(
            kind: .custom(
                url: url,
                mode: .fill,
                imageSize: CGSize(width: width, height: .imageSize),
                imageCornerRadius: .cornerRadius,
                imageBorderWidth: .imageBorderWidth,
                imageBorderColor: .pink,
                placeholderLineWidth: .placeholderLineWidth,
                placeholderImageSize: min(.imageSize / 2, 30)
            )
        )
    }

    static func authorImageConfiguration(url: URL?) -> Self {
        .basic(
            kind: .custom(
                url: url,
                mode: .fill,
                imageSize: CGSize(edge: .authorImageSize),
                imageCornerRadius: .authorImageCornerRadius,
                imageBorderWidth: .zero,
                imageBorderColor: nil,
                placeholderLineWidth: .placeholderLineWidth,
                placeholderImageSize: .authorImageSize / 2
            )
        )
    }
}

// MARK: - Constants

private extension CGFloat {

    static let imageSize: CGFloat = 200
    static let cornerRadius: CGFloat = .zero
    static let imageBorderWidth: CGFloat = .zero
    static let placeholderLineWidth: CGFloat = .zero

    static let authorImageSize: CGFloat = 40
    static let authorImageCornerRadius: CGFloat = .authorImageSize / 2
}

private extension AuthorModel {

    static let data = AuthorModel(
        id: 0,
        authorName: "migtyK1ngRichard",
        post: nil,
        imageURL: .mockLoadingUrl
    )
}

private extension CityModel {

    static let data = CityModel(
        id: 0,
        cityName: "Просто город",
        imageURL: nil,
        description: "Просто какой-то набор слов для описания такого города. Правда надо просто что-то очень много и много писать, но я не могу понять, что я ещё могу придумать для такого города. Ладно, пофиг. Крч вот тычка тычка тычка, карта карта, сююююда, мурлок и победа. СИИИИИУ"
    )
}

// MARK: - Preview

#Preview {
    HikeView(hike: .mockHike, width: 400)
}

private extension HikeModel {

    static let mockHike = HikeModel(
        id: 0,
        hikeName: "Поход на Балтику",
        dateStartHike: "14-03-2003", 
        dateApprove: "14-03-2003",
        author: .init(
            id: 0,
            authorName: "mightyK1ngRichard",
            post: "iOS-Developer",
            imageURL: .mockLoadingUrl
        ),
        leader: "Permyakov Dmitriy",
        description: "просто описание какого-то прям ну очень жёского похода", destinationHikes: [
            .init(id: 0, serialNumber: 1, city: .init(id: 0, cityName: "City-1", imageURL: .mockDragonUrl, description: "Просто какой-то текст про город")),
            .init(id: 1, serialNumber: 2, city: .init(id: 1, cityName: "City-2", imageURL: .mockDragonUrl, description: "Просто какой-то текст про город")),
            .init(id: 2, serialNumber: 3, city: .init(id: 2, cityName: "City-3", imageURL: .mockDragonUrl, description: "Просто какой-то текст про город")),
        ]
    )
}

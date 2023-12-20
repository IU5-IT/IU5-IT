//
//  DetailCityView.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 18.09.2023.
//

import SwiftUI

struct DetailCityView: View {
    
    var city   : CityModel
    var author : AuthorModel = .data
    var hadler : MKREmptyBlock?
    
    var body: some View {
        GeometryReader {
            let width = $0.size.width
            ScrollView(.vertical) {
                VStack {
                    AvatarView()
        
                    MKRImageView(configuration: .imageConfiguration(
                        url: city.imageURL,
                        width: width - .imageBorderWidth
                    ), handler: hadler)
                    
                    if let description = city.description {    
                        Text(description)
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                            .font(.system(size: 16, design: .rounded))
                            .leadingAlignment
                    }
                }
                .padding(.vertical, 10)
                .background(Color(uiColor: .bgAshToCoal))
                .cornerRadius(15)
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}

// MARK: - DetailCityView

private extension DetailCityView {
    
    func AvatarView() -> some View {
        HStack {
            MKRImageView(configuration: .authorImageConfiguration(url: .mockLoadingUrl))
            VStack {
                Text(author.authorName)
                    .font(.headline)
                    .leadingAlignment
                Text("• " + (author.post ?? "iOS engineer"))
                    .font(.caption)
                    .leadingAlignment
            }
            .leadingAlignment
        }
        .padding(.leading)
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
    DetailCityView(city: .data, author: .data)
        .preferredColorScheme(.dark)
}

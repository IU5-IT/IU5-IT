//
//  CityView.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 17.09.2023.
//

import SwiftUI

struct CityView: View {
    var cityName: String = .cityName
    var imageConfiguration: MKRImageView.Configuration = .imageConfiguration
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MKRImageView(configuration: imageConfiguration)
            Text(cityName)
                .font(.headline)
                .frame(width: imageConfiguration.imageSize.width - imageConfiguration.imageBorderWidth * 2)
                .padding(.vertical, 5)
                .background()
                .cornerRadius(imageConfiguration.imageCornerRadius)
                .lineLimit(.lineLimit)
        }
    }
}

// MARK: - Image configuration

private extension MKRImageView.Configuration {
    
    static var imageConfiguration: Self {
        .basic(
            kind: .custom(
                url: .mockLoadingUrl,
                mode: .fill,
                imageSize: .imageSize,
                imageCornerRadius: .imageCornerRadius,
                imageBorderWidth: .imageBorderWidth,
                imageBorderColor: .pink,
                placeholderLineWidth: .placeholderLineWidth
            )
        )
    }
}


// MARK: - Constants

private extension String {
    
    static let cityName = "MightyK1ngRichard"
}

private extension CGSize {
    
    static let imageSize = CGSize(width: 300, height: 200)
}

private extension Int {
    
    static let lineLimit = 1
}

private extension CGFloat {
    
    static let imageCornerRadius: CGFloat = 20
    static let imageBorderWidth: CGFloat = 2
    static let placeholderLineWidth: CGFloat = 2
    static let borderWidth: CGFloat = 2
}

// MARK: - Priview

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}

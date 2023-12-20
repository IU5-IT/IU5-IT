//
//  AuthorView.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 20.09.2023.
//

import SwiftUI

struct AuthorView: View {
    var author: AuthorModel!
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
        .onAppear {
            isSubscribe = mainViewModel.currentUserSupliers.contains(Int(author.id))
        }
    }
}

// MARK: - AuthorView

private extension AuthorView {
    
    func UserDescriptionView() -> some View {
        VStack {
            Spacer()
                .frame(height: .imageSize / 2)
            
            Text(author.authorName)
                .font(.system(size: 23, weight: .heavy, design: .rounded))
            Text(author.post ?? .noPost)
                .font(.caption)
            
            Button {
                MakeSubscription()
                
            } label: {
                Label {
                    Text(isSubscribe ? String.noSubscribe : String.hasSubscribe)
                } icon: {
                    Image(systemName: isSubscribe ? "minus.circle" : "plus.circle")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(7)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.black.opacity(0.5))
                        .padding(.horizontal)
                )
            }

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(Color.backgroundColor)
        .cornerRadius(20)
        .overlay(alignment: .top) {
            MKRImageView(configuration: .imageConfiguration(author: author))
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

// MARK: - Network

private extension AuthorView {

    func MakeSubscription() {
        NetworkService.shared.request(
            router: .makeSubscription,
            method: .post,
            type: CityEntity.self,
            parameters: [
                "user_id": mainViewModel.currentUser.id,
                "subscription_id": author.id
            ]
        ) { result in
            switch result {
            case .success(let result):
                print(result)
                withAnimation {
                    isSubscribe.toggle()
                }
                
            case .failure(let error):
                print(error)
            }
        }
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
    AuthorView(author: .data)
        .environmentObject(MainViewModel())
}

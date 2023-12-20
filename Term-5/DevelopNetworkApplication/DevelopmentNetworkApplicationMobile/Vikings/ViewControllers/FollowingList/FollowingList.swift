//
//  FollowingList.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import SwiftUI

struct FollowingList: View {
    @StateObject var viewModel = FollowerViewModel()
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        MainView
            .onAppear {
//                FetchData()
                 viewModel.hikesViewModel = .mockModel
            }
    }

    @ViewBuilder
    private var MainView: some View {
        if viewModel.hikesViewModel.hikes.isEmpty {
            Text("Empty data")
        } else {
            GeometryReader { proxy in
                let width = proxy.size.width
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(viewModel.hikesViewModel.hikes) { hike in
                            HikeView(hike: hike, width: width)
                        }
                    }
                    .environmentObject(viewModel)
                    .padding(.bottom, 50)
                }
            }
        }
    }

    private func FetchData() {
        NetworkService.shared.request(
            router: .userSubscriptions,
            method: .get,
            type: UserSubscriptionsEntity.self,
            parameters: ["user_id": mainViewModel.currentUser.id]
        ) { result in
            switch result {
            case .success(let userSubscriptions):
                NetworkService.shared.request(
                    router: .hikes,
                    method: .get,
                    type: HikesEntity.self,
                    parameters: nil
                ) { result in
                    switch result {
                    case .success(var hikes):
                        mainViewModel.currentUserSupliers = userSubscriptions.subscriptionsIdArray
                        hikes.hikes = hikes.hikes.filter {
                            userSubscriptions.subscriptionsIdArray.contains($0.user_id)
                        }
                        viewModel.hikesViewModel = hikes.mapper
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    FollowingList()
        .environmentObject(MainViewModel.MockData())
        .environmentObject(FollowerViewModel())
}

// MARK: - Mock data

private extension HikesViewModel {

    static var mockModel = HikesViewModel(hikes: [
        HikeModel(
            id: 0,
            hikeName: "Поход 1",
            dateStartHike: "14-03-2003",
            dateApprove: "14-03-2003",
            author: .init(id: 0, authorName: "King", post: "Backend", imageURL: .mockLoadingUrl),
            leader: "Leader похода 1",
            description: "Описание с каким-то бла бла, бой бой, тычка тычка, ура победа",
            destinationHikes: [
                DestinationHikesModel(id: 0, serialNumber: 1, city: .init(
                    id: 0, cityName: "Город 1", imageURL: .mockDragonUrl, description: nil)
                ),
                DestinationHikesModel(id: 1, serialNumber: 2, city: .init(
                    id: 1, cityName: "Город 2", imageURL: .mockLoadingUrl, description: nil)
                ),
                DestinationHikesModel(id: 2, serialNumber: 3, city: .init(
                    id: 2, cityName: "Город 3", imageURL: .mockDragonUrl, description: nil)
                ),
            ]
        ),
        HikeModel(
            id: 1,
            hikeName: "Поход 2",
            dateStartHike: "14-03-2003",
            dateApprove: "14-03-2003",
            author: .init(id: 0, authorName: "King 2", post: "Backend 2", imageURL: .mockLoadingUrl),
            leader: "Leader похода 2",
            description: "Описание с каким-то бла бла, бой бой, тычка тычка, ура победа",
            destinationHikes: [
                DestinationHikesModel(id: 0, serialNumber: 1, city: .init(
                    id: 0, cityName: "Город 1", imageURL: .mockDragonUrl, description: nil)
                ),
                DestinationHikesModel(id: 1, serialNumber: 2, city: .init(
                    id: 1, cityName: "Город 2", imageURL: .mockLoadingUrl, description: nil)
                ),
                DestinationHikesModel(id: 2, serialNumber: 3, city: .init(
                    id: 2, cityName: "Город 3", imageURL: .mockDragonUrl, description: nil)
                ),
            ]
        )
    ])
}

private extension MainViewModel {

    static func MockData() -> MainViewModel {
        let mockData = MainViewModel()
        mockData.currentUserSupliers = [2, 3]
        mockData.currentUser = .init(id: 1, authorName: "", post: nil, imageURL: nil)
        return mockData
    }
}

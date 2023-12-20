//
//  FollowerViewModel.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import Foundation

class FollowerViewModel: ObservableObject {
    @Published var hikesViewModel = HikesViewModel()
}

struct HikesViewModel {
    var hikes: [HikeModel] = []
}

struct HikeModel: Identifiable {
    let id: Int
    let hikeName: String
    let dateStartHike: String
    let dateApprove: String
    let author: AuthorModel
    let leader: String
    let description: String
    let destinationHikes: [DestinationHikesModel]
}

struct DestinationHikesModel: Identifiable {
    let id: Int
    let serialNumber: Int
    let city: CityModel
}

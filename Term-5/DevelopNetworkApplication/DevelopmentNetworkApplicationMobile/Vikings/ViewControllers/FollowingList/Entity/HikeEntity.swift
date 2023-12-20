//
//  HikeEntity.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 25/10/2023.
//

import Foundation

// MARK: - HikeEntity

struct HikesEntity: Decodable {
    var hikes: [HikeEntity] = []
}

struct HikeEntity: Decodable {

    let id: Int
    let user_id: Int
    let hike_name: String
    let date_approve: String
    let date_start_hike: String
    let user: AuthorEntity
    let leader: String
    let description: String
    let destination_hikes: [DestinationHikeEntity]
}

struct DestinationHikeEntity: Decodable {
    
    let id: Int
    let serial_number: Int
    let city: CityEntity
}

// MARK: - Mappers

extension DestinationHikeEntity {

    var mapper: DestinationHikesModel {
        DestinationHikesModel(id: id, serialNumber: serial_number, city: city.mapper)
    }
}

extension HikeEntity {

    var mapper: HikeModel {
        HikeModel(
            id: id,
            hikeName: hike_name,
            dateStartHike: date_start_hike,
            dateApprove: date_approve,
            author: user.mapper,
            leader: leader,
            description: description,
            destinationHikes: destination_hikes.map { $0.mapper }
        )
    }
}

extension HikesEntity {

    var mapper: HikesViewModel {
        HikesViewModel(hikes: hikes.map { $0.mapper })
    }
}


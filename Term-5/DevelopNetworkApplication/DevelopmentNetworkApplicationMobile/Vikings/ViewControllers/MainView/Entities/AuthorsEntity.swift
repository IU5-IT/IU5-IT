//
//  AuthorsEntity.swift
//  Vikings
//
//  Created by Дмитрий Пермяков on 19.09.2023.
//

import Foundation

struct AuthorsEntity: Decodable {
    let authors: [AuthorEntity]

    enum CodingKeys: String, CodingKey {
        case authors = "users"
    }
}

struct AuthorEntity: Decodable {
    let id         : UInt
    let authorName : String?
    let profession : String?
    let birthday   : String?
    let imageURL   : String?

    enum CodingKeys: String, CodingKey {
        case id, profession, birthday
        case authorName = "user_name"
        case imageURL = "image_url"
    }
}

extension AuthorsEntity {
    
    var mapper: AuthorViewModel {
        AuthorViewModel(
            authors: authors.map { AuthorModel(
                id: $0.id,
                authorName: $0.authorName ?? "Аноним",
                post: $0.profession,
                imageURL: $0.imageURL?.toURL)
            }
        )
    }
}

extension AuthorEntity {

    var mapper: AuthorModel {
        AuthorModel(
            id: id,
            authorName: authorName ?? "",
            post: profession,
            imageURL: imageURL?.toURL
        )
    }
}

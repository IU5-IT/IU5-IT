//
//  UserSubscriptionsEntity.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 27/10/2023.
//

import Foundation

struct UserSubscriptionsEntity: Decodable {

    var userSubscriptions: [UserSubscriptionEntity]

    enum CodingKeys: String, CodingKey {
        case userSubscriptions = "user_subscriptions"
    }
}

struct UserSubscriptionEntity: Decodable {

    var id: Int
    var authorId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case authorId = "author_id"
    }
}

extension UserSubscriptionsEntity {
    
    /// Получаем только id пользователей
    var subscriptionsIdArray: [Int] {
        userSubscriptions.compactMap {
            $0.authorId ?? nil
        }
    }
}

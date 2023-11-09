//
//  CardItem.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import Foundation

// MARK: - Response model

struct CardItemResponse: Decodable {
    let id: Int?
    let url: String?
    let order: Int?
}

// MARK: - Business model

struct CardItem {
    let id: Int
    let url: String
    let order: Int
    
    init?(response: CardItemResponse) {
        guard let id = response.id else {
            return nil
        }
        
        self.id = id
        self.url = response.url ?? ""
        self.order = response.order ?? Int.max
    }
}

// MARK: - CardDisplayItem

extension CardItem: CardDisplayItem {
    var title: String {
        #if DEBUG
            "id:\(id) | order:\(order)"
        #else
            ""
        #endif
    }
    
    var imageURL: String {
        url
    }
}

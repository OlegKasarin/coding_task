//
//  CardItem.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import Foundation

struct CardItem: Decodable {
    let id: Int
    let url: String
    let order: Int
}

// MARK: - CardDisplayItem

extension CardItem: CardDisplayItem {
    var title: String {
        String(id)
    }
    
    var imageURL: String {
        url
    }
}

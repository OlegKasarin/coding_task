//
//  CardCollectionViewCell.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import UIKit

protocol CardDisplayItem {
    var imageURL: String { get }
}

final class CardCollectionViewCell: UICollectionViewCell {
    static let cellID = "CardCollectionViewCell"
    static let nibName = "CardCollectionViewCell"
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(displayItem: CardDisplayItem) {
        displayItem.imageURL
    }
}

//
//  CardCollectionViewCell.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import UIKit

protocol CardDisplayItem {
    var title: String { get }
    var imageURL: String { get }
}

final class CardCollectionViewCell: UICollectionViewCell {
    static let cellID = "CardCollectionViewCell"
    static let nibName = "CardCollectionViewCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: BrandedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        prepare()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare()
    }
    
    // MARK: - Public
    
    func setup(displayItem: CardDisplayItem) {
        titleLabel.text = displayItem.title
        imageView.load(imageURL: displayItem.imageURL, placeholder: nil)
    }
}

// MARK: - Private

private extension CardCollectionViewCell {
    func setup() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    func prepare() {
        imageView.image = nil
    }
}

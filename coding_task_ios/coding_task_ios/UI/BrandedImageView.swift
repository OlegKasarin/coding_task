//
//  BrandedImageView.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import Foundation
import Kingfisher
import UIKit

final class BrandedImageView: UIImageView {
    func load(
        imageURL: String,
        lowResolutionURL: String? = nil,
        placeholder: UIImage?,
        completion: (() -> Void)? = nil
    ) {
        let url = URL(string: imageURL)
        
        var options: KingfisherOptionsInfo = [
            .transition(.fade(0.5))
        ]
        
        if
            let lowResolutionURL = lowResolutionURL,
            let lowURL = URL(string: lowResolutionURL)
        {
            options.append(.lowDataMode(.network(lowURL)))
        }
        
        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options,
            progressBlock: nil
        ) { _ in completion?() }
    }
}

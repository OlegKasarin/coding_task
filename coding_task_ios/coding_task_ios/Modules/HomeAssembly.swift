//
//  HomeAssembly.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import Foundation
import UIKit

final class HomeAssembly {
    static func homeViewController() -> HomeViewControllerProtocol {
        let controller = HomeViewController()
        
        let presenter = HomePresenter(
            controller: controller,
            firebaseAdapter: FirebaseAdapter.shared
        )
        
        controller.presenter = presenter
        return controller
    }
}

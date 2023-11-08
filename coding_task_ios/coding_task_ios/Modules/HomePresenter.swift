//
//  HomePresenter.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import Foundation

protocol HomePresenterProtocol {
    func didTriggerViewLoad()
    
    func didTriggerAskItemsCount() -> Int
    func didTriggerAskItem(at indexPath: IndexPath) -> CardDisplayItem
}

final class HomePresenter {
    weak var controller: HomeViewControllerProtocol?
    
    private var cards: [CardDisplayItem] = []
    
    init(controller: HomeViewControllerProtocol) {
        self.controller = controller
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {
    func didTriggerViewLoad() {
        // fetch
    }
    
    func didTriggerAskItemsCount() -> Int {
        cards.count
    }
    
    func didTriggerAskItem(at indexPath: IndexPath) -> CardDisplayItem {
        cards[indexPath.row]
    }
}

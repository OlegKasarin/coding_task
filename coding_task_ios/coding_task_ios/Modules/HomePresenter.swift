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
    
    private let maxCardsCount = 6
    
    private let firebaseAdapter: FirebaseAdapterProtocol
    
    private var cards: [CardItem] = []
    private var displayItems: [CardDisplayItem] {
        Array(cards.prefix(maxCardsCount))
    }
    
    init(
        controller: HomeViewControllerProtocol,
        firebaseAdapter: FirebaseAdapterProtocol
    ) {
        self.controller = controller
        self.firebaseAdapter = firebaseAdapter
    }
}

// MARK: - HomePresenterProtocol

extension HomePresenter: HomePresenterProtocol {
    func didTriggerViewLoad() {
        firebaseAdapter.startListenChanges(self)
    }
    
    func didTriggerAskItemsCount() -> Int {
        displayItems.count
    }
    
    func didTriggerAskItem(at indexPath: IndexPath) -> CardDisplayItem {
        displayItems[indexPath.row]
    }
}

// MARK: - FirebaseAdapterDelegateProtocol

extension HomePresenter: FirebaseAdapterDelegateProtocol {
    func configIsUpdated(cards: [CardItem]) {
        // sort by order
        self.cards = cards.sorted(by: { $0.order < $1.order })
        
        DispatchQueue.main.async {
            self.controller?.refresh()
        }
    }
}

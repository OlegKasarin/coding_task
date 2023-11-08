//
//  HomeViewController.swift
//  coding_task_ios
//
//  Created by Oleg Kasarin on 08/11/2023.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    var viewController: UIViewController { get }
    func refresh()
}

final class HomeViewController: UIViewController {
    var presenter: HomePresenterProtocol?

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            let nib = UINib(nibName: CardCollectionViewCell.nibName, bundle: nil)
            let id = CardCollectionViewCell.cellID
            collectionView.register(nib, forCellWithReuseIdentifier: id)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didTriggerViewLoad()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        presenter?.didTriggerAskItemsCount() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let id = CardCollectionViewCell.cellID
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        
        if
            let cardCell = cell as? CardCollectionViewCell,
            let cardItem = presenter?.didTriggerAskItem(at: indexPath)
        {
            cardCell.setup(displayItem: cardItem)
        }
        
        return cell
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeViewController: HomeViewControllerProtocol {
    var viewController: UIViewController {
        self
    }
    
    func refresh() {
        collectionView.reloadData()
    }
}

// MARK: - Private

private extension HomeViewController {
    
}

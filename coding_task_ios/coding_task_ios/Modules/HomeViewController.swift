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
        setupCollectionLayout()
        presenter?.didTriggerViewLoad()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [unowned self] _ in
            setupCollectionLayout()
            collectionView.collectionViewLayout.invalidateLayout()
        })
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
    func setupCollectionLayout() {
        collectionView.collectionViewLayout = CollectionViewLayoutBuilder.build(collectionLayout)
    }
    
    // MARK: - Layout
    
    var isLandscape: Bool {
        let isLandscape = traitCollection.verticalSizeClass == .compact
        debugPrint("isLandscape:", isLandscape)
        return isLandscape
    }
    
    var collectionLayout: CollectionLayout {
        isLandscape
            ? padCollectionLayout
            : phoneCollectionLayout
    }
    
    var padCollectionLayout: CollectionLayout {
        let countVisibleCells: CGFloat = 2.35
        let minimumLineSpacing: CGFloat = 50
        let padCellRatio: CGFloat = 350/150
        let sectionInsets = UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40)
        
        return CollectionLayout(
            cellRatio: padCellRatio,
            visibleCountInRow: countVisibleCells,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            scrollDirection: .vertical
        )
    }
    
    var phoneCollectionLayout: CollectionLayout {
        let countVisibleCells: CGFloat = 1
        let minimumLineSpacing: CGFloat = 60
        let phoneCellRation: CGFloat = 7/4
        let sectionInsets = UIEdgeInsets(top: 20, left: 60, bottom: 40, right: 60)
        
        return CollectionLayout(
            cellRatio: phoneCellRation,
            visibleCountInRow: countVisibleCells,
            minimumLineSpacing: minimumLineSpacing,
            sectionInset: sectionInsets,
            scrollDirection: .vertical
        )
    }
}

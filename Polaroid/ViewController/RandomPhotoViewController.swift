//
//  RandomPhotoViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 10/18/24.
//

import UIKit
import SnapKit

final class RandomPhotoViewController: BaseViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    let viewModel: RandomPhotoViewModel
    
    init(viewModel: RandomPhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RandomCollectionVeiwCell.self, forCellWithReuseIdentifier: RandomCollectionVeiwCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    private func bindData(){
        viewModel.inputViewDidLoadTrigger.value = ()

        viewModel.outputRandomPhotoResult
            .bind { [weak self] value in
                self?.collectionView.reloadData()
            }
    }
    
}

extension RandomPhotoViewController: ResultLikeDelegate {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool) {
        let response = viewModel.outputRandomPhotoResult.value
        let data = response[indexPath.item]
        
        configureImageFile(isClicked, data)
        
        viewModel.inputLikeButtonIndexPath.value = indexPath.item
        viewModel.inputLikeButtonClicked.value = isClicked
        
        if isClicked {
            showToast(Literal.like)
        }else{
            showToast(Literal.unlike)
        }
        
    }
}

extension RandomPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputRandomPhotoResult.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomCollectionVeiwCell.identifier, for: indexPath) as? RandomCollectionVeiwCell else { return UICollectionViewCell() }
        let data = viewModel.outputRandomPhotoResult.value[indexPath.item]
        cell.configureData(data, indexPath.item + 1)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.outputRandomPhotoResult.value[indexPath.item]
        let detailVC = PhotoDetailViewController()
        detailVC.viewModel.viewType = .search
        detailVC.viewModel.inputPhotoResult = item
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


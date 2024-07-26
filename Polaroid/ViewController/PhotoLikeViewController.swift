//
//  PhotoLikeViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit
import SnapKit

final class PhotoLikeViewController: BaseViewController {
    private var sortButton: UIButton!
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .createBasicLayout(view))
    
    let viewModel = PhotoLikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Navigation.likePhoto.title
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func configureHierarchy() {
        sortButton = UIButton(type: .custom, primaryAction: UIAction{ _ in
            self.toggleSortButton()
        })
        
        view.addSubview(sortButton)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(2)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.configuration = .sortButtonConfig
        sortButton.configuration?.title = LikeCondition.earliest.title
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoResultCollectionViewCell.self, forCellWithReuseIdentifier: PhotoResultCollectionViewCell.identifier)
    }
}


extension PhotoLikeViewController {
    private func bindData(){
        viewModel.inputViewDidLoadTrigger.value = ()
        viewModel.outputPhotoLikeResult.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func toggleSortButton(){
        if sortButton.isSelected {
            sortButton.configuration?.title = LikeCondition.latest.title
            viewModel.inputSortButtonClicked.value = .earliest
        }else{
            sortButton.configuration?.title = LikeCondition.earliest.title
            viewModel.inputSortButtonClicked.value = .latest
        }
    }
    
}

extension PhotoLikeViewController: ResultLikeDelegate {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool) {
        viewModel.inputLikeButtonIndexPath.value = indexPath.item
        viewModel.inputLikeButtonIsClicked.value = isClicked
    }
}

extension PhotoLikeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputPhotoLikeResult.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoResultCollectionViewCell.identifier, for: indexPath) as? PhotoResultCollectionViewCell else { return UICollectionViewCell() }
        
        guard let result = viewModel.outputPhotoLikeResult.value else { return UICollectionViewCell() }
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        let data = result[indexPath.item]
        cell.configureData(data.convertPhotoResult())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = PhotoDetailViewController()
        guard let result = viewModel.outputPhotoLikeResult.value  else { return }
        let data = result[indexPath.item]    
        let inputData = data.convertPhotoResult()       
        photoDetailVC.viewModel.inputPhotoResult = inputData
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

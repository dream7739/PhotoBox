//
//  ViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit
import SnapKit

final class SearchPhotoViewController: BaseViewController {
    private let searchBar = UISearchBar()
    
    private var sortButton: UIButton!
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    let viewModel = SearchPhotoViewModel()
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 2
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let width = (view.bounds.width - spacing) / 2
        layout.itemSize = CGSize(width: width , height: width * 1.3)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Navigation.searchPhoto.title
        bindData()
    }
    
    override func configureHierarchy() {
        let toggleAction = UIAction(title: "") { _ in
            self.toggleSortButton()
        }
        sortButton = UIButton.init(configuration: .plain(), primaryAction: toggleAction)
        
        view.addSubview(searchBar)
        view.addSubview(sortButton)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(2)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        searchBar.placeholder = "검색할 사진을 입력해주세요"
        
        sortButton.changesSelectionAsPrimaryAction = true
        
        sortButton.configuration?.title = "관련순"
        sortButton.configuration?.image = ImageType.sort
        sortButton.configuration?.baseForegroundColor = .black
        sortButton.configuration?.background.cornerRadius = 14
        sortButton.configuration?.background.strokeColor = .light_gray
        sortButton.configuration?.background.strokeWidth = 1
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoResultCollectionViewCell.self, forCellWithReuseIdentifier: PhotoResultCollectionViewCell.identifier)
    }
    
    private func toggleSortButton(){
        if sortButton.isSelected {
            sortButton.configuration?.title = "최신순"
            sortButton.configuration?.baseBackgroundColor = .white
        }else{
            sortButton.configuration?.title = "관련순"
            sortButton.configuration?.baseBackgroundColor = .white
        }
    }
    
    private func bindData(){
        
        
    }
}

extension SearchPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoResultCollectionViewCell.identifier, for: indexPath) as? PhotoResultCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}


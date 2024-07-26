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
        configureSearchBar()
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
        sortButton.configuration?.title = SortCondition.relevant.title
        sortButton.configuration?.image = ImageType.sort
        sortButton.configuration?.baseForegroundColor = .black
        sortButton.configuration?.background.cornerRadius = 14
        sortButton.configuration?.baseBackgroundColor = .white
        sortButton.configuration?.background.strokeColor = .light_gray
        sortButton.configuration?.background.strokeWidth = 1
        
        collectionView.keyboardDismissMode = .onDrag 
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoResultCollectionViewCell.self, forCellWithReuseIdentifier: PhotoResultCollectionViewCell.identifier)
    }
  
}

extension SearchPhotoViewController {
    enum SortCondition: String {
        case latest
        case relevant
        
        var title: String {
            switch self {
            case .latest:
                return "최신순"
            case .relevant:
                return "관련순"
            }
        }
    }
    
    private func bindData(){
        viewModel.outputSearchPhotoResult.bind { [weak self] value in
            self?.collectionView.reloadData()
        }
    }
    
    private func toggleSortButton(){
        if sortButton.isSelected {
            sortButton.configuration?.title = SortCondition.latest.title
        }else{
            sortButton.configuration?.title = SortCondition.relevant.title
        }
    }
    
    private func configureSearchBar(){
        searchBar.delegate = self
    }
    
}

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let inputText = searchBar.text ?? ""
        viewModel.inputSearchText.value = inputText
    }
}

extension SearchPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let response = viewModel.outputSearchPhotoResult.value else { return 0 }
        return response.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoResultCollectionViewCell.identifier, for: indexPath) as? PhotoResultCollectionViewCell else { return UICollectionViewCell() }
        guard let response = viewModel.outputSearchPhotoResult.value else {
            return UICollectionViewCell()
        }
        
        let data = response.results[indexPath.item]
        cell.configureData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let photoDetailVC = PhotoDetailViewController()
        guard let data = viewModel.outputSearchPhotoResult.value else { return }
        photoDetailVC.viewModel.inputPhotoResult.value = data.results[indexPath.item]
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let data = viewModel.outputSearchPhotoResult.value else { return }
        
        for indexPath in indexPaths {
            if indexPath.item == data.results.count - 4 && viewModel.page < data.total_pages {
                viewModel.page += 1
                viewModel.callSearchPhotoAPI()
                
            }
        }
    }
}

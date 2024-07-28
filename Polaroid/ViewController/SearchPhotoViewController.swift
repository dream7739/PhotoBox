//
//  ViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit
import SnapKit
import Toast

final class SearchPhotoViewController: BaseViewController {
    private let searchBar = UISearchBar()
    private var sortButton: UIButton!
    private let emptyView = EmptyView(type: .searchInit)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .createBasicLayout(view))
    
    let viewModel = SearchPhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Navigation.searchPhoto.title
        configureSearchBar()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func configureHierarchy() {
        sortButton = UIButton.init(configuration: .plain(), primaryAction:  UIAction { _ in
            self.toggleSortButton()
        })
        
        view.addSubview(searchBar)
        view.addSubview(sortButton)
        view.addSubview(collectionView)
        view.addSubview(emptyView)

    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(2)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(2)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        searchBar.placeholder = "키워드 검색"
        
        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.configuration = .sortButtonConfig
        sortButton.configuration?.title = SearchCondition.latest.title
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoResultCollectionViewCell.self, forCellWithReuseIdentifier: PhotoResultCollectionViewCell.identifier)
    }
    
}

extension SearchPhotoViewController {
    
    private func bindData(){
        viewModel.outputSearchPhotoResult.bind { [weak self] value in
            guard let value else { return }
            
            if value.results.isEmpty {
                self?.emptyView.isHidden = false
            }else{
                self?.emptyView.isHidden = true
            }
            self?.collectionView.reloadData()
            
            if self?.viewModel.page == 1 && !value.results.isEmpty {
                self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
        
        viewModel.outputNetworkError.bind { [weak self] value in
            self?.showToast(value.localizedDescription)
            self?.searchBar.text = ""
        }
        
        viewModel.outputIsInitalSearch.bind { [weak self] value in
            self?.emptyView.setDescription(.search)
        }
    }
    
    private func toggleSortButton(){
        sortButton.throttle()
        
        if sortButton.isSelected {
            sortButton.configuration?.title = SearchCondition.relevant.title
            viewModel.inputSortCondition.value = SearchCondition.latest
        }else{
            sortButton.configuration?.title = SearchCondition.latest.title
            viewModel.inputSortCondition.value = SearchCondition.relevant
        }
    }
    
    private func configureSearchBar(){
        searchBar.delegate = self
    }
}

extension SearchPhotoViewController: ResultLikeDelegate {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool) {
        guard let response = viewModel.outputSearchPhotoResult.value else { return }
        let data = response.results[indexPath.item]
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

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let inputText = searchBar.text ?? ""
        viewModel.inputSearchText.value = inputText
        sortButton.isSelected = false
        sortButton.configuration?.title = SearchCondition.latest.title
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
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        let data = response.results[indexPath.item]
        cell.configureData(.searchPhoto, data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = PhotoDetailViewController()
        guard let data = viewModel.outputSearchPhotoResult.value else { return }
        photoDetailVC.viewModel.inputPhotoResult = data.results[indexPath.item]
        photoDetailVC.viewModel.viewType = .search
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let data = viewModel.outputSearchPhotoResult.value else { return }
        
        for indexPath in indexPaths {
            if indexPath.item == data.results.count - 4 && viewModel.page < data.total_pages {
                viewModel.page += 1
                viewModel.inputPrefetchTrigger.value = ()
            }
        }
    }
}

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
    private let colorOptionView = ColorOptionView()
    private let sortButton = SortOptionButton()
    private let emptyView = EmptyView(type: .searchInit)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: ZigzagFlowLayout())
    
    let viewModel = SearchPhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Navigation.searchPhoto.title
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(colorOptionView)
        view.addSubview(sortButton)
        view.addSubview(collectionView)
        view.addSubview(emptyView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        colorOptionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.trailing.equalTo(sortButton.snp.leading).offset(-4)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(colorOptionView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(colorOptionView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        searchBar.delegate = self
        searchBar.placeholder = "키워드 검색"
        searchBar.searchBarStyle = .minimal
        
        sortButton.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        sortButton.throttle(delay: 1) { [weak self] in
            if self?.sortButton.isClicked ?? false {
                self?.viewModel.inputSortButtonClicked.value = SearchCondition.relevant
            }else{
                self?.viewModel.inputSortButtonClicked.value = SearchCondition.latest
            }
        }
        
        for idx in 0..<colorOptionView.colorButtonList.count{
            colorOptionView.colorButtonList[idx].addTarget(self, action: #selector(colorOptionButtonClicked), for: .touchUpInside)
            colorOptionView.colorButtonList[idx].tag = idx
        }
        
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoResultCollectionViewCell.self, forCellWithReuseIdentifier: PhotoResultCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    @objc private func sortButtonClicked(){
        sortButton.isClicked.toggle()
    }
    
    @objc private func colorOptionButtonClicked(sender: ColorOptionButton){
        searchBar.searchTextField.resignFirstResponder()
        
        sender.isClicked.toggle()
        
        viewModel.inputColorOptionButtonClicked.value = (sender.tag, sender.isClicked)
        
        for idx in 0..<colorOptionView.colorButtonList.count {
            if idx != sender.tag {
                colorOptionView.colorButtonList[idx].isClicked = false
            }
        }
    }
    
    @objc private func retryButtonClicked(){
        viewModel.inputRetryButtonClick.value = ()
    }
    
}

extension SearchPhotoViewController {
    private func bindData(){
        
        viewModel.outputSearchFilterPhotoResult.bind { [weak self] value in
            guard let value else { return }
            if value.results.isEmpty {
                self?.emptyView.isHidden = false
            }else{
                self?.emptyView.isHidden = true
            }
            
            self?.collectionView.reloadData()
            
        }
        
        viewModel.outputScrollTopTrigger.bind { [weak self] _ in
            if let value = self?.viewModel.outputSearchFilterPhotoResult.value?.results, !value.isEmpty {
                self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
        
        viewModel.outputNetworkError.bind { [weak self] value in
            self?.showToast(value.localizedDescription)
            self?.searchBar.text = ""
        }
        
        viewModel.outputInitialSearch.bind { [weak self] value in
            self?.emptyView.setDescription(.search)
            self?.emptyView.isHidden = true
        }
        
        viewModel.outputInitColorOptionTrigger.bind { [weak self] _ in
            self?.colorOptionView.colorButtonList.forEach{ button in
                button.isClicked = false
            }
            self?.sortButton.isClicked = false
        }
    }
}

extension SearchPhotoViewController: ResultLikeDelegate {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool) {
        guard let response = viewModel.outputSearchFilterPhotoResult.value else { return }
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
        guard let input = searchBar.searchTextField.text else { return }
        
        if !input.trimmingCharacters(in: .whitespaces).isEmpty {
            searchBar.searchTextField.resignFirstResponder()
        }
        
        viewModel.inputSearchText.value = input
    }
}

extension SearchPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let response = viewModel.outputSearchFilterPhotoResult.value else { return 0 }
        return response.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoResultCollectionViewCell.identifier, for: indexPath) as? PhotoResultCollectionViewCell else { return UICollectionViewCell() }
        guard let response = viewModel.outputSearchFilterPhotoResult.value else {
            return UICollectionViewCell()
        }
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        let data = response.results[indexPath.item]
        cell.configureData(.searchPhoto, data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let width = (collectionView.frame.width - 32) / 2
          return CGSize(width: width, height: width * 1.5)
      }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = PhotoDetailViewController()
        guard let data = viewModel.outputSearchFilterPhotoResult.value else { return }
        
        photoDetailVC.viewModel.inputPhotoResult = data.results[indexPath.item]
        photoDetailVC.viewModel.viewType = .search
        
        if viewModel.isColorOptionClicked {
            let index = viewModel.inputColorOptionButtonClicked.value.idx
            photoDetailVC.viewModel.color = ColorCondition.allCases[index].rawValue
        }
        
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

extension SearchPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let data = viewModel.outputSearchFilterPhotoResult.value else { return }
        
        for indexPath in indexPaths {
            if indexPath.item == data.results.count - 4 {
                if viewModel.isColorOptionClicked && viewModel.filterPage < data.total_pages {
                    viewModel.filterPage += 1
                    viewModel.inputPrefetchTrigger.value = ()
                }else if !viewModel.isColorOptionClicked && viewModel.page < data.total_pages {
                    viewModel.page += 1
                    viewModel.inputPrefetchTrigger.value = ()
                }
            }
        }
    }
}

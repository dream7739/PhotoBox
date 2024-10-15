//
//  TopicPhotoViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit
import SnapKit

final class TopicPhotoViewController: BaseViewController {
    private let titleLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let sectionHeader = "section-element-kind-header"
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoResult>!
    
    let viewModel = TopicPhotoViewModel()
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(170), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(6)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: sectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = 6
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10
        layout.configuration = configuration
        
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureDataSource()
        updateSnapshot()
    }
    
    override func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
       
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    
    }
    
    override func configureUI() {
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.text = Navigation.topicPhoto.title
        collectionView.delegate = self
    }
    
    override func retryNetworkCall() {
        viewModel.inputRetryButtonClick.value = ()
    }

    @objc private func retryButtonClicked(){
        viewModel.inputRetryButtonClick.value = ()
    }
}

extension TopicPhotoViewController {
    enum Section: String, CaseIterable {
        case goldenHour = "Golden Hour"
        case businessWork = "Busniness Work"
        case architectureInterior = "Architecture & Interior"
        
        var topicID: String {
            switch self {
            case .goldenHour:
                return "golden-hour"
            case .businessWork:
                return "business-work"
            case .architectureInterior:
                return "architecture-interior"
            }
        }
    }
    
    private func bindData(){
        
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.outputUpdateSnapshotTrigger.bind { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputErrorOccured.bind { [weak self] _ in
            self?.showToast(NetworkError.error.localizedDescription)
        }
        
    }
    
    private func configureDataSource(){
        let registeration = UICollectionView.CellRegistration<PhotoResultCollectionViewCell, PhotoResult> { cell, indexPath, itemIdentifier in
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: sectionHeader) { supplementaryView, string, indexPath in
            let title = self.dataSource.sectionIdentifier(for: indexPath.section)?.rawValue
            supplementaryView.configureTitle(title)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registeration, for: indexPath, item: itemIdentifier)
            cell.configureData(.topicPhoto, itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = {(collectionView, elementKind, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
    }
    
    private func updateSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoResult>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.outputGoldenHourReulst, toSection: .goldenHour)
        snapshot.appendItems(viewModel.outputBusinessWorkReulst, toSection: .businessWork)
        snapshot.appendItems(viewModel.outputArchitectureInteriorReulst, toSection: .architectureInterior)
        dataSource.apply(snapshot)
    }
}

extension TopicPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        let photoDetailVC = PhotoDetailViewController()
        photoDetailVC.viewModel.viewType = .search
        photoDetailVC.viewModel.inputPhotoResult = item
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

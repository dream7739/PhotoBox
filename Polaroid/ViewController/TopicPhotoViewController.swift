//
//  TopicPhotoViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit

enum Section: String, CaseIterable {
    case goldenHour = "골든아워"
    case businessWork = "비지니스 및 업무"
    case architectureInterior = "건축 및 인테리어"
    
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

final class TopicPhotoViewController: BaseViewController {
    private let profileImage = RoundImageView(type: .highlight)
    private let titleLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let sectionHeader = "section-element-kind-header"
    private var dataSource: UICollectionViewDiffableDataSource<Section, PhotoResult>!
    
    let viewModel = TopicPhotoViewModel()
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(270))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(6)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: sectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
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
        view.addSubview(profileImage)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(4)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.text = Navigation.topicPhoto.title
        
        profileImage.image = UIImage(named: UserManager.profileImage)
    }
}

extension TopicPhotoViewController {
    private func bindData(){
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.outputUpdateSnapshotTrigger.bind { [weak self] _ in
            self?.updateSnapshot()
        }
    }
    
    private func configureDataSource(){
        let registeration = UICollectionView.CellRegistration<PhotoResultCollectionViewCell, PhotoResult> { cell, indexPath, itemIdentifier in
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: sectionHeader) { supplementaryView, string, indexPath in
            supplementaryView.titleLabel.text = self.dataSource.sectionIdentifier(for: indexPath.section)?.rawValue
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registeration, for: indexPath, item: itemIdentifier)
            cell.configureData(itemIdentifier)
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

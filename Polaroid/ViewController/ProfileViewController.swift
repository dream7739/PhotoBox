//
//  ProfileViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/24/24.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    private let profileView = RoundProfileView()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: profileLayout()
    )
    
    var viewType: ViewType = .add
    var profileImage: String?
    var profileImageSender: ((String?) -> Void)?
    private var selectedIndexPath: IndexPath?
    
    private func profileLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 10
        let verticalInset: CGFloat = 20
        let horizontalInset: CGFloat = 20
        let width = (view.bounds.width - (spacing * 3) - (horizontalInset * 2)) / 4
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Navigation.profile.title
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileImageSender?(profileImage)
    }
    
    override func configureHierarchy() {
        view.addSubview(profileView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(130)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        if let profileImage {
            profileView.profileImage.image = UIImage(named: profileImage)
        }
    }
    
}

extension ProfileViewController {
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
    }
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell()
        }
        
        let data = ProfileType.allCases[indexPath.row]
        
        cell.configureData(data: data)
        
        guard let selectedIndexPath = selectedIndexPath else{
            if profileImage == data.rawValue {
                cell.isClicked = true
            }else{
                cell.isClicked = false
            }
            return cell
        }
            
        if selectedIndexPath == indexPath {
            cell.isClicked = true
        }else{
            cell.isClicked = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        profileImage = ProfileType.allCases[indexPath.item].rawValue
        profileView.profileImage.image = UIImage(named: profileImage ?? "")
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
}


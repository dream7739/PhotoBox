//
//  PhotoDetailViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import UIKit
import Kingfisher
import SnapKit

final class PhotoDetailViewController: BaseViewController {
    private let headerView = FeedHeaderView()
    private let photoImage = UIImageView()
    private let infoLabel = UILabel()
    private let infoStackView = UIStackView()
    private let sizeStackView = UIStackView()
    private let sizeLabel = UILabel()
    private let sizeTextLabel = UILabel()
    private let viewCountStackView = UIStackView()
    private let viewCountLabel = UILabel()
    private let viewCountTextLabel = UILabel()
    private let downloadStackView = UIStackView()
    private let downloadLabel = UILabel()
    private let downloadTextLabel = UILabel()
    
    let viewModel = PhotoDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppearTrigger.value = ()
    }

    override func configureHierarchy() {
        view.addSubview(headerView)
        view.addSubview(photoImage)
        view.addSubview(infoLabel)
        view.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(sizeStackView)
        infoStackView.addArrangedSubview(viewCountStackView)
        infoStackView.addArrangedSubview(downloadStackView)
        
        sizeStackView.addArrangedSubview(sizeLabel)
        sizeStackView.addArrangedSubview(sizeTextLabel)
        
        viewCountStackView.addArrangedSubview(viewCountLabel)
        viewCountStackView.addArrangedSubview(viewCountTextLabel)
        
        downloadStackView.addArrangedSubview(downloadLabel)
        downloadStackView.addArrangedSubview(downloadTextLabel)
    }
    
    override func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.equalTo(photoImage.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel)
            make.leading.equalTo(infoLabel.snp.trailing).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
    }
    
    override func configureUI() {
        photoImage.contentMode = .scaleAspectFill
        photoImage.clipsToBounds = true
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 10
        
        sizeStackView.axis = .horizontal
        viewCountStackView.axis = .horizontal
        downloadStackView.axis = .horizontal
        
        infoLabel.text = "정보"
        infoLabel.font = .systemFont(ofSize: 17, weight: .bold)
        infoLabel.textColor = .black
        
        sizeLabel.text = "크기"
        sizeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        sizeLabel.textColor = .black
        
        sizeTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        sizeTextLabel.textColor = .deep_gray
        sizeTextLabel.textAlignment = .right
        
        viewCountLabel.text = "조회수"
        viewCountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        viewCountLabel.textColor = .black
        
        viewCountTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        viewCountTextLabel.textColor = .deep_gray
        viewCountTextLabel.textAlignment = .right
        
        downloadLabel.text = "다운로드"
        downloadLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        downloadLabel.textColor = .black
        
        downloadTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        downloadTextLabel.textColor = .deep_gray
        downloadTextLabel.textAlignment = .right
        
        headerView.heartButton.addTarget(self, action: #selector(heartButtonClicked), for: .touchUpInside)
    }
    
    @objc func heartButtonClicked(){
        headerView.isClicked.toggle()
        
        guard let data = viewModel.inputPhotoResult else { return }
        configureImageFile(headerView.isClicked, data)
        
        viewModel.inputHeartButtonClicked.value = headerView.isClicked
    }
    
}

extension PhotoDetailViewController {
    private func bindData(){
        
        viewModel.outputPhotoStatResult.bind { [weak self] value in
            guard let data = value else { return }
            self?.configurePhotoData()
            self?.configureStatData(data)
        }
        
        viewModel.outputPhotoIsLiked.bind { [weak self] value in
            self?.headerView.isClicked = value
        }
        
        viewModel.outputErrorOccured.bind { [weak self]  in
            self?.showToast(NetworkError.error.localizedDescription)
            self?.headerView.configureDisabled()
            self?.photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.5)
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()

    }
    
    private func configurePhotoData(){
        guard let value = viewModel.inputPhotoResult else { return }
        
        headerView.configureHeaderView(profileImage: value.user.profile_image.medium, userName: value.user.name, createDate: value.created_at)

        if let url = URL(string: value.urls.raw) {
            photoImage.kf.setImage(with: url)
        }else{
            photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
        }
        
        sizeTextLabel.text = "\(value.width) x \(value.height)"
    }
    
    private func configureStatData(_ data: PhotoStatResponse){
        viewCountTextLabel.text = data.views.total.formatted(.number)
        downloadTextLabel.text = data.downloads.total.formatted(.number)
    }
}

//
//  PhotoDetailViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/25/24.
//

import UIKit
import SwiftUI
import Kingfisher
import SnapKit

final class PhotoDetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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
    private let chartSegment = UISegmentedControl(items: ["조회", "다운로드"])
    private let chartLabel = UILabel()
    private let childView = UIHostingController(rootView: ChartView())
    
    let viewModel = PhotoDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePhotoData()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(photoImage)
        contentView.addSubview(infoLabel)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(sizeStackView)
        infoStackView.addArrangedSubview(viewCountStackView)
        infoStackView.addArrangedSubview(downloadStackView)
        
        sizeStackView.addArrangedSubview(sizeLabel)
        sizeStackView.addArrangedSubview(sizeTextLabel)
        
        viewCountStackView.addArrangedSubview(viewCountLabel)
        viewCountStackView.addArrangedSubview(viewCountTextLabel)
        
        downloadStackView.addArrangedSubview(downloadLabel)
        downloadStackView.addArrangedSubview(downloadTextLabel)
        
        if #available(iOS 16.0, *) {
            contentView.addSubview(chartLabel)
            contentView.addSubview(chartSegment)
            
            addChild(childView)
            childView.view.frame = .zero
            contentView.addSubview(childView.view)
            childView.didMove(toParent: self)
        }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        headerView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        photoImage.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.equalTo(photoImage.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        if #available(iOS 16.0, *) {
            infoStackView.snp.makeConstraints { make in
                make.top.equalTo(infoLabel)
                make.leading.equalTo(infoLabel.snp.trailing).offset(4)
                make.trailing.equalToSuperview().inset(20)
            }
            
            chartLabel.snp.makeConstraints { make in
                make.top.equalTo(infoStackView.snp.bottom).offset(20)
                make.leading.equalTo(infoLabel)
            }
            
            chartSegment.snp.makeConstraints { make in
                make.top.equalTo(chartLabel)
                make.leading.equalTo(infoStackView)
            }
            
            childView.view.snp.makeConstraints { make in
                make.top.equalTo(chartSegment.snp.bottom).offset(15)
                make.leading.equalTo(chartSegment)
                make.height.equalTo(200)
                make.bottom.trailing.equalToSuperview().inset(20)
            }
        }else{
            infoStackView.snp.makeConstraints { make in
                make.top.equalTo(infoLabel)
                make.leading.equalTo(infoLabel.snp.trailing).offset(4)
                make.trailing.bottom.equalToSuperview().inset(20)
            }
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
        infoLabel.font = FontType.primary_bold
        infoLabel.textColor = .black
        
        sizeLabel.text = "크기"
        sizeLabel.font = FontType.tertiary_bold
        sizeLabel.textColor = .black
        
        sizeTextLabel.font = FontType.tertiary_bold
        sizeTextLabel.textColor = .deep_gray
        sizeTextLabel.textAlignment = .right
        
        viewCountLabel.text = "조회수"
        viewCountLabel.font = FontType.tertiary_bold
        viewCountLabel.textColor = .black
        
        viewCountTextLabel.font = FontType.tertiary_bold
        viewCountTextLabel.textColor = .deep_gray
        viewCountTextLabel.textAlignment = .right
        
        downloadLabel.text = "다운로드"
        downloadLabel.font = FontType.tertiary_bold
        downloadLabel.textColor = .black
        
        downloadTextLabel.font = FontType.tertiary_bold
        downloadTextLabel.textColor = .deep_gray
        downloadTextLabel.textAlignment = .right
        
        headerView.likeButton.addTarget(self, action: #selector(heartButtonClicked), for: .touchUpInside)
        
        if #available(iOS 16.0, *) {
            chartLabel.text = "차트"
            chartLabel.font = FontType.primary_bold
            chartLabel.textColor = .black
            chartSegment.selectedSegmentIndex = 0
            chartSegment.addTarget(self, action: #selector(chartSegmentClicked), for: .valueChanged)
        }
        
    }
    
    @objc func heartButtonClicked(){
        headerView.isClicked.toggle()
        
        guard let data = viewModel.inputPhotoResult else { return }
        configureImageFile(headerView.isClicked, data)
        
        viewModel.inputHeartButtonClicked.value = headerView.isClicked
        
        switch viewModel.viewType {
        case .search:
            if headerView.isClicked {
                showToast(Literal.like)
            }else{
                showToast(Literal.unlike)
            }
        case .like:
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    @objc func chartSegmentClicked(sender: UISegmentedControl){
        guard let data = viewModel.outputPhotoStatResult.value else { return }
        
        switch sender.selectedSegmentIndex {
        case 0:
            childView.rootView.data = data.views.historical.values
        case 1:
            childView.rootView.data = data.downloads.historical.values
        default:
            print("ERROR")
        }
    }
}

extension PhotoDetailViewController {
    private func configurePhotoData(){
        guard let value = viewModel.inputPhotoResult else { return }
        
        switch viewModel.viewType {
        case .search:
            if let url = URL(string: value.user.profile_image.medium) {
                headerView.userProfileImage.kf.setImage(with: url)
            }else{
                headerView.userProfileImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            headerView.usernameLabel.text = value.user.name
            headerView.createDateLabel.text = value.dateDescription
            
            if let url = URL(string: value.urls.small) {
                photoImage.kf.indicatorType = .activity
                photoImage.kf.setImage(with: url)
            }else{
                photoImage.backgroundColor = .deep_gray.withAlphaComponent(0.2)
            }
            
            sizeTextLabel.text = value.sizeDescription
        case .like:
            if let profileImage = ImageFileManager.loadImageToDocument(filename: value.id + Literal.profileFileName){
                headerView.userProfileImage.image = profileImage
            }
            headerView.usernameLabel.text = value.user.name
            headerView.createDateLabel.text = value.dateDescription
            
            if let image = ImageFileManager.loadImageToDocument(filename: value.id){
                photoImage.image = image
            }
            sizeTextLabel.text = value.sizeDescription
        }
    }
    
    private func bindData(){
        
        viewModel.outputPhotoStatResult.bind { [weak self] value in
            guard let data = value else { return }
            self?.configureStatData(data)
        }
        
        viewModel.outputPhotoIsLiked.bind { [weak self] value in
            self?.headerView.isClicked = value
        }
        
        viewModel.outputNetworkError.bind { [weak self] value in
            self?.showToast(value.localizedDescription)
            self?.configureDisabled()
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()
        
    }
    
    private func configureDisabled(){
        downloadStackView.removeFromSuperview()
        viewCountStackView.removeFromSuperview()
        chartLabel.removeFromSuperview()
        chartSegment.removeFromSuperview()
        childView.willMove(toParent: nil)
        childView.view.removeFromSuperview()
        childView.removeFromParent()
        infoStackView.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func configureStatData(_ data: PhotoStatResponse){
        childView.rootView.data = data.views.historical.values
        viewCountTextLabel.text = data.views.total.formatted(.number)
        downloadTextLabel.text = data.downloads.total.formatted(.number)
    }
    
}


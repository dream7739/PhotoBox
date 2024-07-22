//
//  BaseViewController.swift
//  Polaroid
//
//  Created by 홍정민 on 7/22/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy(){ }
    func configureLayout(){ }
    func configureUI(){ }
}

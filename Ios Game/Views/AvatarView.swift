//
//  Avatariew.swift
//  Ios Game
//
//  Created by Martin on 2/10/21.
//

import UIKit
import SnapKit

class AvatarView: UIView {
    
    var username: String? {
        didSet {
            lblUsername.text = username
        }
    }
    
    var image: String? {
        didSet {
            if let image = image {
                avatarImage.image = UIImage(named: image)
            }
        }
    }
    
    enum avatarUIState {
        case loading
    }
    
   private lazy var lblUsername: UILabel = {
       let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.textColor = .white
    label.textAlignment = .center
        return label
    }()
    
  private  lazy var lblWinsLoses: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    

    var state: avatarUIState
    
    init (state: avatarUIState) {
        self.state = state
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        switch state {
        case .loading:
            addSubview(stackView)
            stackView.addArrangedSubview(lblUsername)
            stackView.addArrangedSubview(avatarImage)
            stackView.addArrangedSubview(lblWinsLoses)
            
        }
        setupConstraints()
    }
    private func setupConstraints() {
        switch state {
        case .loading:
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            avatarImage.snp.makeConstraints { make in
                make.width.equalTo(85)
                make.height.equalTo(100)
            }
        }
    }
}


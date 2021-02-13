//
//  LoadingView.swift
//  Ios Game
//
//  Created by Martin on 2/10/21.
//

import UIKit
import SnapKit

class LoadingView: UIView {

    private lazy var avatarMe: AvatarView = {
       
        let avatar = AvatarView(state: .loading)
        return avatar
        
    }()
    
    private lazy var AvatarOpponent: AvatarView = {
       
        let avatar = AvatarView(state: .loading)
        return avatar
        
    }()
    
    private lazy var lblVs: UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 56, weight: .heavy)
        label.textColor = UIColor(hex: "#FFB24C")
        label.text = "VS"
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var lblRequestStatus: UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = UIColor(hex: "#FFB24C")
        return label
    }()
    
    private lazy var gardientView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gradientBackground"))
        return imageView
    }()
    
    private lazy var btnClose: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(onClose), for:.touchCancel)
        button.tintColor = .black
        return button
    }()
    
    private var me: User
    private var opponent: User
    private var closeTimer: Timer?
    
    init(me: User,opponent: User) {
        self.me = me
        self.opponent = opponent
        super.init(frame: .zero)
        backgroundColor = UIColor(hex: "#3545C8")
        setupView()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setuptimer () {
        closeTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerTick), userInfo: nil, repeats: false)
    }
    
    @objc func timerTick () {
        btnClose.isHidden = false
        closeTimer?.invalidate()
        closeTimer = nil
    }
    
    private func setupView() {
        addSubview(gardientView)
        addSubview(avatarMe)
        addSubview(lblVs)
        addSubview(AvatarOpponent)
        addSubview(lblRequestStatus)
        addSubview(btnClose)
        
        btnClose.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
            make.size.equalTo(50)
        }
        
        gardientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarMe.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.width.equalTo(130)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        lblVs.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.top.equalTo(avatarMe.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        AvatarOpponent.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(lblVs.snp.bottom).offset(25)
        }
        
        lblRequestStatus.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }
    private func setupData() {
        avatarMe.username = me.username
        AvatarOpponent.username = opponent.username
        
        avatarMe.image = "avatarMe"
        AvatarOpponent.image = "avatarOpponent"
        lblRequestStatus.text = "Waiting opponent..."
    }
    
    @objc private func onClose () {
        
    }
}


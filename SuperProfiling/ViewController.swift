//
//  ViewController.swift
//  SuperProfiling
//
//  Created by Andrey Yoshua Manik on 02/08/22.
//

import ComposableArchitecture
import Kingfisher
import SuperPlayer
import SnapKit
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let videos = [
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tableView = UITableView(frame: view.bounds)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.description())
        tableView.rowHeight = 400
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.description(), for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.addInside(viewController: self, urlString: videos[indexPath.row % videos.count])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

}

class TableViewCell: UITableViewCell {
    // 1
    lazy var store = Store<SuperPlayerState, SuperPlayerAction>(initialState: SuperPlayerState(), reducer: superPlayerReducer, environment: SuperPlayerEnvironment.live())
    lazy var superPlayer = SuperPlayerViewController(store: store)
    
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let userBadgeImageView = UIImageView()
    let userStatusLabel = UILabel()
    let userNameLabel2 = UILabel()
    let captionLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        superPlayer.view.backgroundColor = .black
        superPlayer.view.cornerRadius = 8
        superPlayer.view.clipsToBounds = true
        superPlayer.view.layer.masksToBounds = true
        
        userImageView.kf.setImage(with: .network(URL(string: "https://unsplash.com/photos/cRY7PUSOJVs/download?ixid=MnwxMjA3fDB8MXxhbGx8N3x8fHx8fDJ8fDE2NTk3ODU0MTA&force=true&w=640")!))
        contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
            make.width.height.equalTo(32)
        }
        
        userBadgeImageView.kf.setImage(with: .network(URL(string: "https://images.tokopedia.net/img/official_store/badge_os.png")!))
        contentView.addSubview(userBadgeImageView)
        userBadgeImageView.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(16)
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.text = "SuperProfiling Official Store"
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 12)
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userBadgeImageView.snp.trailing).offset(4)
            make.top.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(userStatusLabel)
        userStatusLabel.text = "Barang Diskon"
        userStatusLabel.font = UIFont.systemFont(ofSize: 12)
        userStatusLabel.snp.makeConstraints { make in
            make.leading.equalTo(userBadgeImageView)
            make.top.equalTo(userBadgeImageView.snp.bottom).offset(4)
        }
        
        
        contentView.addSubview(dateLabel)
        dateLabel.text = "1 Hari"
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor.gray
        dateLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(captionLabel)
        captionLabel.text = "🎉 Kejutan spesial! Ada diskon buat barang pilihan ini! Ayo bawa pulang sebelum diskonnya berakhir~"
        captionLabel.font = UIFont.systemFont(ofSize: 12)
        captionLabel.numberOfLines = 0
        captionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(dateLabel.snp.top).inset(-8)
        }
        
        contentView.addSubview(userNameLabel2)
        userNameLabel2.text = "SuperProfiling Official Store"
        userNameLabel2.font = UIFont.boldSystemFont(ofSize: 12)
        userNameLabel2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(captionLabel.snp.top).inset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addInside(viewController: UIViewController, urlString: String) {
        superPlayer.view.removeFromSuperview()
        if superPlayer.parent == nil {
            viewController.addChild(superPlayer)
        }
        
        // 2
        contentView.addSubview(superPlayer.view)
        superPlayer.didMove(toParent: viewController)
        superPlayer.view.snp.makeConstraints { make in
            make.top.equalTo(userStatusLabel.snp.bottom).inset(-8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(userNameLabel2.snp.top).inset(-8)
        }

        // 3
        let viewStore = ViewStore(store)
        viewStore.send(.load(URL(string: urlString)!, autoPlay: true))
        
    }
}


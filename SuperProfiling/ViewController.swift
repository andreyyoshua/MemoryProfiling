//
//  ViewController.swift
//  SuperProfiling
//
//  Created by Andrey Yoshua Manik on 02/08/22.
//

import ComposableArchitecture
import SuperPlayer
import SnapKit
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tableView = UITableView(frame: view.bounds)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.description())
        tableView.rowHeight = 216
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func handleVideo() {
        // 1
        let store = Store<SuperPlayerState, SuperPlayerAction>(initialState: SuperPlayerState(), reducer: superPlayerReducer, environment: SuperPlayerEnvironment.live())
        let superPlayer = SuperPlayerViewController(store: store)

        // 2
        superPlayer.view.frame = view.bounds
        superPlayer.view.backgroundColor = .black
        addChild(superPlayer)
        view.addSubview(superPlayer.view)
        superPlayer.didMove(toParent: self)

        // 3
        let viewStore = ViewStore(store)
        viewStore.send(.load(URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!, autoPlay: true))
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.description(), for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.addInside(viewController: self)
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
    
    func addInside(viewController: UIViewController) {
        superPlayer.view.removeFromSuperview()
        if superPlayer.parent == nil {
            viewController.addChild(superPlayer)
        }
        
        // 2
        superPlayer.view.backgroundColor = .black
        contentView.addSubview(superPlayer.view)
        superPlayer.didMove(toParent: viewController)
        superPlayer.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        // 3
        let viewStore = ViewStore(store)
        viewStore.send(.load(URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!, autoPlay: true))
        
    }
}


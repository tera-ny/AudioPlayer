//
//  AlbamListViewController.swift
//  AudioPlayer
//
//  Created by haruta yamada on 2019/01/29.
//  Copyright © 2019 teranyan. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class AlbamListViewController: UIViewController {
    
    @IBOutlet weak var albamTable: UITableView!
    
    var datasource = AlbamListDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albamTable.register(UINib(nibName: "AlbamListCell", bundle: nil), forCellReuseIdentifier: "AlbamCell")
        self.albamTable.dataSource = self.datasource
        self.albamTable.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.generateAlbamTable()
    }
    private func generateAlbamTable() {
        guard datasource.fetchAlbam() else {
            return
        }
        self.albamTable.reloadData()
    }
}
extension AlbamListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let player = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MusicPlayer") as? MusicPlayViewController else {
            fatalError()
        }
        let queueController: MediaPlayerInputQueueProtocol = AudioPlayer.shared
        queueController.setQueue(query: MPMediaQuery.songs(), firstPlayIndex: 1, isPlay: true)
        self.navigationController?.show(player, sender: nil)
    }
}
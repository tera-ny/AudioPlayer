//
//  ArtistListViewController.swift
//  AudioPlayer
//
//  Created by haruta yamada on 2019/02/03.
//  Copyright © 2019 teranyan. All rights reserved.
//

import UIKit
import MediaPlayer
import RxCocoa
import RxSwift

class ArtistListViewController: BaseListViewController {
    
    let cellHeight: CGFloat = 50
    let headerHeight: CGFloat = 70
    deinit {
        DebugUtil.log("ArtistList is deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ArtistListTableViewCell", bundle: nil), forCellReuseIdentifier: "List")
        self.tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        bind()
    }
    
    func bind() {
        Observable.of(
            rx.sentMessage(#selector(viewWillAppear(_:))).map {_ in},
            willEnterForeground.asObservable().map {_ in},
            mediaListAuth.asObservable().map {_ in}
            )
            .merge()
            .map { _ in
                return MPMediaLibrary.authorizationStatus()
            }
            .subscribe { [weak self] status in
                guard let status = status.element else {
                    return
                }
                if status == MPMediaLibraryAuthorizationStatus.authorized {
                    self?.queryFetch(case: .album)
                    self?.accessView.removeFromSuperview()
                } else {
                    self?.showRequestView()
                }
        }.disposed(by: disposeBag)
    }
}
extension ArtistListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = ArtistDetailListViewController()
        guard let collection = self.query?.collections else {
            return
        }
        detailView.artistName = collection[indexPath.item].representativeItem?.artist
        self.navigationController?.show(detailView, sender: nil)
    }
}
extension ArtistListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let collection = self.query?.collections else {
            return 0
        }
        return collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath) as? ArtistListTableViewCell else {
            fatalError()
        }
        guard let collection = self.query?.collections else {
            return cell
        }
        cell.updateView(artist: collection[indexPath.item].representativeItem?.artist)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? HomeHeaderView else {
            fatalError()
        }
        view.updateView(text: "Artist")
        return view
    }
}

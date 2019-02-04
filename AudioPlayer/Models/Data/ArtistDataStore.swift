//
//  ArtistDataStore.swift
//  AudioPlayer
//
//  Created by haruta yamada on 2019/02/03.
//  Copyright © 2019 teranyan. All rights reserved.
//

import Foundation
import MediaPlayer

class ArtistDataStore: ItemDataStore {
    func fetchAllItem() -> MPMediaQuery {
        return MPMediaQuery.artists()
    }
    
    func serchItem(keyword: String) -> MPMediaQuery {
        let query = MPMediaQuery.artists()
        let predicate = MPMediaPropertyPredicate(value: keyword, forProperty: MPMediaItemPropertyArtist)
        query.addFilterPredicate(predicate)
        return query
    }
}

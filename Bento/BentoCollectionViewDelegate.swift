//
//  BentoCollectionViewDelegate.swift
//  Bento
//
//  Created by Jenny Gallegos Cardenas on 17/10/24.
//

internal protocol BentoCollectionViewDelegate: AnyObject {
    func updateItems(diffingWith newItems: [String])
}

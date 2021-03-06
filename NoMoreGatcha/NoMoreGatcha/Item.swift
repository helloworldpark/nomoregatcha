//
//  Pickable.swift
//  NoMoreGatcha
//
//  Created by Helloworld Park on 2017. 3. 17..
//  Copyright © 2017년 Helloworld Park. All rights reserved.
//

import Foundation

public struct Item : Hashable
{
    public var name: String
    private var _hash: Int
    public var hashValue: Int {
        get {
            return _hash
        }
    }
    
    public init(name: String)
    {
        self.name = name
        self._hash = name.hashValue
    }
    
    public static func ==(lhs: Item, rhs: Item) -> Bool
    {
        return lhs.name == rhs.name
    }
    
    public static func convenientItems(count: Int) -> [Item]
    {
        guard count > 0 else {
            fatalError("Must have at least 1 item")
        }
        var items = [Item]()
        for i in 1...count
        {
            items.append(Item(name: "item-\(i)"))
        }
        return items
    }
}

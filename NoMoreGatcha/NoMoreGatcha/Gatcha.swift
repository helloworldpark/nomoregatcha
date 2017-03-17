//
//  Gatcha.swift
//  NoMoreGatcha
//
//  Created by Helloworld Park on 2017. 3. 17..
//  Copyright © 2017년 Helloworld Park. All rights reserved.
//

import Foundation

public class Gatcha
{
    public var name: String
    public let items: [Item]
    private let discreteHelper: ERDiscrete<Item>
    private var appearedItems: Set<Item>
    
    public init(items: [Item], odds: [Double])
    {
        guard items.count == odds.count else {
            fatalError("Items and Odds don't match")
        }
        self.name = "gatcha-\(Date().hashValue)"
        self.items = items
        self.discreteHelper = ERDiscrete(x: items, probability: odds)
        self.appearedItems = Set<Item>(minimumCapacity: items.count)
    }
    
    public convenience init(odds: [Double])
    {
        self.init(items: Item.convenientItems(count: odds.count), odds: odds)
    }
    
    public func run(forRounds r: Int, maximumPick p: UInt64, reportAsFile: Bool = false)
    {
        guard r > 0 else {
            return
        }
        guard p > 0 else {
            return
        }
        
        var pickArr = [UInt64]()
        for _ in 1...r
        {
            var picks = UInt64(0)
            while self.appearedItems.count < items.count && picks < p
            {
                picks = picks + 1
                self.appearedItems.insert(self.discreteHelper.generate())
            }
            self.appearedItems.removeAll(keepingCapacity: true)
            pickArr.append(picks)
        }
        
        self.report(withData: pickArr, saveAsFile: reportAsFile)
    }
    
    private func report(withData data: [UInt64], saveAsFile: Bool)
    {
        let mean = data.reduce(0.0) { (old, fresh) -> Double in
            return old + Double(fresh)
        } / Double(data.count)
        let sqmean = data.reduce(0.0) { (old, fresh) -> Double in
            return old + Double(fresh) * Double(fresh)
        } / Double(data.count)
        let stdev = sqrt(sqmean - mean*mean)
        let maxPick = data.max()!
        let minPick = data.min()!
        
        print("Random Boxes: \(items.count) Rounds: \(data.count)")
        print("Mean: \(mean) Stdev: \(stdev)")
        print("Min: \(minPick) Max: \(maxPick)")
        
        if saveAsFile == true {
            let path = Gatcha.documentsDirectory().appendingPathComponent("\(self.name).csv")
            let joined = data.flatMap({ String($0)}).joined(separator: "\n")
            let txtToWrite = "Picks\n".appending(joined)
            do {
                try txtToWrite.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                print("Saving failed")
                return
            }
            print("Saved at \(path)")
        }
    }
    
    private static func documentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public static func uniformDistribution(count: Int) -> [Double]
    {
        guard count > 0 else {
            fatalError("At least one")
        }
        return [Double](repeating: 1.0 / Double(count), count: count)
    }
    
    public static func rareDistribution(count: Int, rare: Double) -> [Double]
    {
        guard count > 1 else {
            fatalError("At least two")
        }
        guard rare < 1.0 else {
            fatalError("Rare be smaller than one")
        }
        var distribution = [Double](repeating: (1.0 - rare) / Double(count - 1), count: count)
        distribution[distribution.count-1] = rare
        return distribution
    }
}

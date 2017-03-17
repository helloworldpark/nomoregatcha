//
//  IdealGatcha.swift
//  NoMoreGatcha
//
//  Created by Helloworld Park on 2017. 3. 18..
//  Copyright © 2017년 Helloworld Park. All rights reserved.
//

import Foundation

public class IdealGatcha
{
    private var combination: [[UInt64]]
    
    public init(N: Int)
    {
        var combination = [[UInt64]](repeating: [UInt64](), count: N+1)
        combination[0].append(UInt64(0))
        for i in 1...N {
            combination[i] = [UInt64](repeating: UInt64(0), count: i+1)
        }
        self.combination = combination
        self.initCombination()
    }
    
    public func mean(_ k: Int) -> Double
    {
        var m = 0.0
        for j in 0..<k {
            let r = Double(j+1)/Double(k)
            var mp = self.bitSign(j) * Double(self.combination[k][j+1])
            mp = mp * (Double(k-1) + (1.0/r))
            mp = mp * pow(1.0 - r, Double(k-1))
            m = m + mp
        }
        return m
    }
    
    private func bitSign(_ n: Int) -> Double
    {
        return (n & 1 == 0 ? 1.0 : -1.0)
    }
    
    private func initCombination()
    {
        self.combination[1][0] = 1
        self.combination[1][1] = 1
        
        for i in 2..<(self.combination.count) {
            self.combination[i][0] = 1
            self.combination[i][i] = 1
        }
        
        for i in 2..<(self.combination.count) {
            for j in 1..<i {
                self.combination[i][j] = self.combination[i-1][j-1] + self.combination[i-1][j]
            }
        }
    }
    
    private func printCombination()
    {
        for i in 0..<self.combination.count
        {
            for j in 0..<self.combination[i].count
            {
                print("(\(i) \(j)) = \(self.combination[i][j])")
            }
        }
    }
}

//
//  main.swift
//  NoMoreGatcha
//
//  Created by Helloworld Park on 2017. 3. 17..
//  Copyright © 2017년 Helloworld Park. All rights reserved.
//

import Foundation

let rounds = 10000
let maximumPick = UInt64(1000)

let idealGatcha = IdealGatcha(N: 30)

print("Experiment for uniform distribution")
for itemCount in 1...30
{
    print("----------------------------")
    print("Ideal Gatcha Size: \(itemCount) Mean: \(idealGatcha.mean(itemCount))")
    let test = Gatcha(odds: Gatcha.uniformDistribution(count: itemCount))
    test.name = "gatcha_uniform_\(itemCount)"
//    test.run(forRounds: rounds, maximumPick: maximumPick, reportAsFile: false)
    print("----------------------------")
    print("Testing Branch")
}

print("Experiment for rare distribution with 8 items, varying probability")
for oddCount in (1...12).reversed()
{
    print("----------------------------")
    let rareProbability = Double(oddCount)/100.0
    let test = Gatcha(odds: Gatcha.rareDistribution(count: 8, rare: rareProbability))
    test.name = "gatcha_rare_\(rareProbability)"
    print("Test Name \(test.name)")
    let report = test.run(forRounds: rounds, maximumPick: maximumPick, reportAsFile: false)
    print("Mean \(report.mean)")
    print("----------------------------")
}


//
//  main.swift
//  NoMoreGatcha
//
//  Created by LinePlus on 2017. 3. 17..
//  Copyright © 2017년 Helloworld Park. All rights reserved.
//

import Foundation

let rounds = 1000
let maximumPick = UInt64(1000)

print("Experiment for uniform distribution")
for itemCount in 1...30
{
    print("----------------------------")
    let test = Gatcha(odds: Gatcha.uniformDistribution(count: itemCount))
    test.name = "gatcha_uniform_\(itemCount)"
    test.run(forRounds: rounds, maximumPick: maximumPick, reportAsFile: true)
    print("----------------------------")
}

print("Experiment for rare distribution with 8 items, varying probability")
for oddCount in (1...12).reversed()
{
    print("----------------------------")
    let rareProbability = Double(oddCount)/100.0
    let test = Gatcha(odds: Gatcha.rareDistribution(count: 8, rare: rareProbability))
    test.name = "gatcha_rare_\(rareProbability)"
    test.run(forRounds: rounds, maximumPick: maximumPick, reportAsFile: true)
    print("----------------------------")
}


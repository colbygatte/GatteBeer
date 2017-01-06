//
//  GBBeerSorter.swift
//  GatteBeer
//
//  Created by Colby Gatte on 1/6/17.
//  Copyright © 2017 colbyg. All rights reserved.
//


enum GBSortOptions: String {
    case best, worst, newest, oldest
}

struct GBBeerSorter {
    static func sort(beers: [GBBeer], order: GBSortOptions) -> [GBBeer] {
        switch order {
        case .best:
            return beers.sorted(by: { (beer1, beer2) in
                let rating1 = beer1.rating ?? -1
                let rating2 = beer2.rating ?? -1
                return rating1 > rating2
            })
            break
        case .worst:
            return beers.sorted(by: { (beer1, beer2) in
                let rating1 = beer1.rating ?? -1
                let rating2 = beer2.rating ?? -1
                return rating1 < rating2
            })
            break
        case .oldest:
            return beers.sorted(by: { (beer1, beer2) in
                return beer1.date < beer2.date
            })
            break
        case .newest:
            return beers.sorted(by: { (beer1, beer2) in
                return beer1.date > beer2.date
            })
            break
        }
    }
}

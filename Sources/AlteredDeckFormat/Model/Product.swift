//
//  Product.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 08/09/2024.
//

enum Product: String, CaseIterable {
	case booster = "B"
	case promotion = "P"
	case alternativeArt = "A"
}

extension Product {
	var deckfmtValue: UInt16 {
		switch self {
		// Coded on 1 bit
		case .booster: return 1
		// Coded on 3 bits
		case .promotion: return 1
		case .alternativeArt: return 2
		}
	}

	var deckfmtBitCount: UInt8 {
		switch self {
		case .booster: return 1
		default: return 3
		}
	}

	static func product(from shortDeckfmtValue: UInt16, extendedDeckfmtValue: UInt16?) -> Product? {
		if let extendedDeckfmtValue {
			return Product.allCases.first(where: { $0.deckfmtValue == extendedDeckfmtValue && $0.deckfmtBitCount == 3 })
		} else {
			return .booster
		}
	}
}


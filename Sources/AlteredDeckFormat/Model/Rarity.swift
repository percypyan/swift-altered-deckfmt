//
//  Rarity.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 08/09/2024.
//

enum Rarity: String, CaseIterable {
	case common = "C"
	case rareInFaction = "R1"
	case rareOutOfFaction = "R2"
	case unique = "U"
}

extension Rarity {
	var deckfmtValue: UInt16 {
		switch self {
		case .common: return 0
		case .rareInFaction: return 1
		case .rareOutOfFaction: return 2
		case .unique: return 3
		}
	}

	static func rarity(from deckfmtValue: UInt16) -> Rarity? {
		return Rarity.allCases.first(where: { $0.deckfmtValue == deckfmtValue })
	}
}

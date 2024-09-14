//
//  Faction.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 08/09/2024.
//

enum Faction: String, CaseIterable {
	case axiom = "AX"
	case bravos = "BR"
	case lyra = "LY"
	case muna = "MU"
	case ordis = "OR"
	case yzmir = "YZ"
	case neutral = "NE"
}

extension Faction {
	var deckfmtValue: UInt16 {
		switch self {
		case .axiom: return 1
		case .bravos: return 2
		case .lyra: return 3
		case .muna: return 4
		case .ordis: return 5
		case .yzmir: return 6
		case .neutral: return 7
		}
	}

	static func faction(from deckfmtValue: UInt16) -> Faction? {
		return Faction.allCases.first(where: { $0.deckfmtValue == deckfmtValue })
	}
}

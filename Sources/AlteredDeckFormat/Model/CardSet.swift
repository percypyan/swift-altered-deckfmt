//
//  CardSet.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 08/09/2024.
//

enum CardSet: String, CaseIterable {
	case coreKickstarter = "COREKS"
	case core = "CORE"
}

extension CardSet: Comparable {
	static func < (lhs: CardSet, rhs: CardSet) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

extension CardSet {
	var deckfmtValue: UInt16 {
		switch self {
		case .coreKickstarter: return 1
		case .core: return 2
		}
	}

	static func cardSet(from deckfmtValue: UInt16) -> CardSet? {
		return CardSet.allCases.first(where: { $0.deckfmtValue == deckfmtValue })
	}
}

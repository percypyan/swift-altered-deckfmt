//
//  Card.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 08/09/2024.
//

import Foundation

private let equinoxIDPrefix: String = "ALT"

struct Card {
	let cardSet: CardSet
	let product: Product
	let originFaction: Faction
	let idInFaction: UInt
	let rarity: Rarity
	let uniqueID: UInt?

	init(
		set: CardSet,
		product: Product,
		originFaction: Faction,
		idInFaction: UInt,
		rarity: Rarity,
		uniqueID: UInt? = nil
	) {
		self.cardSet = set
		self.product = product
		self.originFaction = originFaction
		self.idInFaction = idInFaction
		self.rarity = rarity
		self.uniqueID = uniqueID
	}

	var equinoxID: String {
		let idFormatter = NumberFormatter()
		idFormatter.minimumIntegerDigits = (originFaction == .neutral ? 1 : 2)

		let idString = idFormatter.string(from: NSNumber(value: idInFaction))!
		let uniqueIDSuffix = uniqueID != nil ? "_\(uniqueID!)" : ""

		return "\(equinoxIDPrefix)_\(cardSet.rawValue)_\(product.rawValue)_\(originFaction.rawValue)_\(idString)_\(rarity.rawValue)\(uniqueIDSuffix)"
	}
}

extension Card: Equatable {
	static func == (lhs: Card, rhs: Card) -> Bool {
		return (
			lhs.cardSet == rhs.cardSet
			&& lhs.product == rhs.product
			&& lhs.originFaction == rhs.originFaction
			&& lhs.idInFaction == rhs.idInFaction
			&& lhs.rarity == rhs.rarity
			&& lhs.uniqueID == rhs.uniqueID)
	}
}

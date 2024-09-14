//
//  Deck.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 12/09/2024.
//

struct Deck {
	struct Entry {
		let card: Card
		let count: UInt
	}

	private(set) var cardSetGroups: [CardSet : [Entry]] = [:]

	mutating func addCard(_ card: Card, count: UInt) {
		if cardSetGroups[card.cardSet] == nil {
			cardSetGroups[card.cardSet] = []
		}
		cardSetGroups[card.cardSet]!.append(.init(card: card, count: count))
	}
}

extension Deck {
	var listString: String {
		let string = cardSetGroups.values
			.map({ entries in
				return entries
					.map({ $0.listLineString })
					.joined(separator: "\n")
			})
			.joined(separator: "\n")
		return string
	}
}

extension Deck.Entry {
	var listLineString: String {
		return "\(count) \(card.equinoxID)"
	}
}

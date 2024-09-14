//
//  DeckParser.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Foundation

struct DeckParser {
	static func parseDeck(_ input: String) throws -> Deck {
		var deck = Deck()
		try input.split(separator: "\n").forEach { line in
			guard line.count > 0 else { return } // Skip empty lines

			let parts = line
				.trimmingCharacters(in: .whitespaces)
				.split(separator: " ")
				.map(String.init)
			guard
				parts.count == 2,
				let count = UInt(parts[0]),
				let card = try CardIdentifierParser.parse(parts[1])
			else {
				throw AlteredDeckFormat.ParseError.invalidFormat(faultyLine: String(line))
			}

			if count > 0 {
				deck.addCard(card, count: count)
			}
		}
		return deck
	}
}

//
//  CardIdentifierParser.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 12/09/2024.
//



private let gamePrefix = "ALT"

struct CardIdentifierParser {
	static func parse(_ identifier: String) throws -> Card? {
		let parts = identifier.split(separator: "_").map(String.init)

		guard parts.count >= 6 else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}

		guard parts[0] == gamePrefix else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}

		guard let set = CardSet(rawValue: parts[1]) else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}

		guard let product = Product(rawValue: parts[2]) else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}

		guard let faction = Faction(rawValue: parts[3]) else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}
		
		guard let cardNumber = UInt(parts[4]), cardNumber > 0 && cardNumber <= 32 else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}
		
		guard let rarity = Rarity(rawValue: parts[5]) else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}
		
		if rarity != .unique {
			guard parts.count == 6 else {
				throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
			}

			return Card(
				set: set,
				product: product,
				originFaction: faction,
				idInFaction: cardNumber,
				rarity: rarity,
				uniqueID: nil)
		}

		guard parts.count == 7, let uniqueId = UInt(parts[6]) else {
			throw AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: identifier)
		}
		
		return Card(
			set: set,
			product: product,
			originFaction: faction,
			idInFaction: cardNumber,
			rarity: .unique,
			uniqueID: uniqueId)
	}
}

//
//  DeckDecoder.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Foundation

struct DeckDecoder {
	static func decode(_ data: Data) throws -> Deck {
		let bitDataReader = BitDataReader(data)

		var deck = Deck()

		// Header
		_ = try decodeVersion(bitDataReader: bitDataReader)
		let cardSetCount = try decodeCardSetCount(bitDataReader: bitDataReader)

		for _ in 0..<cardSetCount {
			let cardSet = try decodeCardSet(bitDataReader: bitDataReader)
			let entryCount = try decodeCardEntryCount(bitDataReader: bitDataReader)

			for _ in 0..<entryCount {
				let count = try decodeCardQuantity(bitDataReader: bitDataReader)
				let product = try decodeProduct(bitDataReader: bitDataReader)
				let faction = try decodeFaction(bitDataReader: bitDataReader)
				let idInFaction = try decodeCardIDInFaction(bitDataReader: bitDataReader)
				let rarity = try decodeRarity(bitDataReader: bitDataReader)
				var uniqueID: UInt? = nil
				if rarity == .unique {
					uniqueID = try decodeUniqueID(bitDataReader: bitDataReader)
				}

				let card = Card(
					set: cardSet,
					product: product,
					originFaction: faction,
					idInFaction: idInFaction,
					rarity: rarity,
					uniqueID: uniqueID)
				deck.addCard(card, count: count)
			}
		}

		return deck
	}

	private static func decodeVersion(bitDataReader: BitDataReader) throws -> UInt16 {
		let deckfmtVersion = try bitDataReader.read(4)
		guard deckfmtVersion == 1 else {
			throw AlteredDeckFormat.DecodeError.invalidVersion
		}
		return deckfmtVersion
	}

	private static func decodeCardSetCount(bitDataReader: BitDataReader) throws -> UInt16 {
		return try bitDataReader.read(8)
	}

	private static func decodeCardEntryCount(bitDataReader: BitDataReader) throws -> UInt16 {
		return try bitDataReader.read(6)
	}

	private static func decodeCardSet(bitDataReader: BitDataReader) throws -> CardSet {
		let setCode = try bitDataReader.read(8)

		guard let cardSet = CardSet.cardSet(from: setCode) else {
			throw AlteredDeckFormat.DecodeError.invalidCardSet
		}

		return cardSet
	}

	private static func decodeCardQuantity(bitDataReader: BitDataReader) throws -> UInt {
		var count = try bitDataReader.read(2)

		if count == 0 {
			count = try bitDataReader.read(6) + 3
		}

		return UInt(count)
	}

	private static func decodeProduct(bitDataReader: BitDataReader) throws -> Product {
		let shortProductCode = try bitDataReader.read(1)

		var longProductCode: UInt16? = nil

		if shortProductCode == 0 {
			longProductCode = try bitDataReader.read(2)
		}

		guard let product = Product.product(from: shortProductCode, extendedDeckfmtValue: longProductCode) else {
			throw AlteredDeckFormat.DecodeError.invalidProduct
		}

		return product
	}

	private static func decodeFaction(bitDataReader: BitDataReader) throws -> Faction {
		let factionCode = try bitDataReader.read(3)

		guard let faction = Faction.faction(from: factionCode) else {
			throw AlteredDeckFormat.DecodeError.invalidFaction
		}

		return faction
	}

	private static func decodeCardIDInFaction(bitDataReader: BitDataReader) throws -> UInt {
		return UInt(try bitDataReader.read(5))
	}

	private static func decodeRarity(bitDataReader: BitDataReader) throws -> Rarity {
		let rarityCode = try bitDataReader.read(2)

		guard let rarity = Rarity.rarity(from: rarityCode) else {
			throw AlteredDeckFormat.DecodeError.invalidRarity
		}

		return rarity
	}

	private static func decodeUniqueID(bitDataReader: BitDataReader) throws -> UInt {
		return UInt(try bitDataReader.read(16))
	}
}

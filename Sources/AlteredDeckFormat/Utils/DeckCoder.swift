//
//  DeckCoder.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Foundation

struct DeckCoder {}

// MARK: - Encoder

extension DeckCoder {
	static func encode(_ deck: Deck) throws -> Data {
		let bitData = BitData()

		// Header
		// 4-bit version
		// 8-bit groups count
		// ... sub groups
		bitData.append(1, bitCount: 4)
		bitData.append(UInt16(deck.cardSetGroups.count), bitCount: 8)

		// Sub Group
		// 8-bit set code
		// 6-bit card refs count
		// ... card refs
		let sortedGroupKeys = deck.cardSetGroups.keys.sorted()
		for groupKey in sortedGroupKeys {
			let cardEntries = deck.cardSetGroups[groupKey]!
			bitData.append(groupKey.deckfmtValue, bitCount: 8)
			bitData.append(UInt16(cardEntries.count), bitCount: 6)

			// Card ref
			// 2-bit quantity
			// 6-bit extended quantity (optional)
			// ... card
			for entry in cardEntries {
				guard entry.count <= 65 else {
					throw AlteredDeckFormat.EncodeError.exceedMaxCardQuantity
				}
				guard entry.card.idInFaction <= 32 else {
					throw AlteredDeckFormat.EncodeError.invalidCardIDInFaction
				}

				if entry.count <= 3 {
					bitData.append(UInt16(entry.count), bitCount: 2)
				} else {
					bitData.append(0, bitCount: 2)
					bitData.append(UInt16(entry.count - 3), bitCount: 6)
				}

				// Card
				// 1-bit Is booster product
				// 2-bit product (optional, only if is not booster)
				bitData.append(
					entry.card.product.deckfmtValue,
					bitCount: entry.card.product.deckfmtBitCount)
				// 3-bit faction
				bitData.append(entry.card.originFaction.deckfmtValue, bitCount: 3)
				// 5-bit ID in faction
				bitData.append(UInt16(entry.card.idInFaction), bitCount: 5)
				// 2-bit rarity
				bitData.append(entry.card.rarity.deckfmtValue, bitCount: 2)
				// 16-bit unique ID (optional)
				if entry.card.rarity == .unique, let uniqueID = entry.card.uniqueID {
					bitData.append(UInt16(uniqueID), bitCount: 16)
				}
			}
		}

		bitData.commitBuffer()
		return bitData.data
	}
}

// MARK: - Decoder

extension DeckCoder {
	static func decode(_ data: Data) throws -> Deck {
		let bitData = BitData(data)
		var bitReadCount: UInt = 0

		var deck = Deck()

		// Header
		_ = try decodeVersion(bitData: bitData, bitReadCount: &bitReadCount)
		let cardSetCount = try decodeCardSetCount(bitData: bitData, bitReadCount: &bitReadCount)

		for _ in 0..<cardSetCount {
			let cardSet = try decodeCardSet(bitData: bitData, bitReadCount: &bitReadCount)
			let entryCount = try decodeCardEntryCount(bitData: bitData, bitReadCount: &bitReadCount)

			for _ in 0..<entryCount {
				let count = try decodeCardQuantity(bitData: bitData, bitReadCount: &bitReadCount)
				let product = try decodeProduct(bitData: bitData, bitReadCount: &bitReadCount)
				let faction = try decodeFaction(bitData: bitData, bitReadCount: &bitReadCount)
				let idInFaction = try decodeCardIDInFaction(bitData: bitData, bitReadCount: &bitReadCount)
				let rarity = try decodeRarity(bitData: bitData, bitReadCount: &bitReadCount)
				var uniqueID: UInt? = nil
				if rarity == .unique {
					uniqueID = try decodeUniqueID(bitData: bitData, bitReadCount: &bitReadCount)
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

	private static func decodeVersion(bitData: BitData, bitReadCount: inout UInt) throws -> UInt16 {
		let deckfmtVersion = try bitData.read(atBitIndex: bitReadCount, bitCount: 4)
		bitReadCount += 4
		guard deckfmtVersion == 1 else {
			throw AlteredDeckFormat.DecodeError.invalidVersion
		}
		return deckfmtVersion
	}

	private static func decodeCardSetCount(bitData: BitData, bitReadCount: inout UInt) throws -> UInt16 {
		let cardSetCount = try bitData.read(atBitIndex: bitReadCount, bitCount: 8)
		bitReadCount += 8

		return cardSetCount
	}

	private static func decodeCardEntryCount(bitData: BitData, bitReadCount: inout UInt) throws -> UInt16 {
		let entryCount = try bitData.read(atBitIndex: bitReadCount, bitCount: 6)
		bitReadCount += 6

		return entryCount
	}

	private static func decodeCardSet(bitData: BitData, bitReadCount: inout UInt) throws -> CardSet {
		let setCode = try bitData.read(atBitIndex: bitReadCount, bitCount: 8)
		bitReadCount += 8

		guard let cardSet = CardSet.cardSet(from: setCode) else {
			throw AlteredDeckFormat.DecodeError.invalidCardSet
		}

		return cardSet
	}

	private static func decodeCardQuantity(bitData: BitData, bitReadCount: inout UInt) throws -> UInt {
		var count = try bitData.read(atBitIndex: bitReadCount, bitCount: 2)
		bitReadCount += 2

		if count == 0 {
			count = try bitData.read(atBitIndex: bitReadCount, bitCount: 6) + 3
			bitReadCount += 6
		}

		return UInt(count)
	}

	private static func decodeProduct(bitData: BitData, bitReadCount: inout UInt) throws -> Product {
		let shortProductCode = try bitData.read(atBitIndex: bitReadCount, bitCount: 1)
		bitReadCount += 1

		var longProductCode: UInt16? = nil

		if shortProductCode == 0 {
			longProductCode = try bitData.read(atBitIndex: bitReadCount, bitCount: 2)
			bitReadCount += 2
		}

		guard let product = Product.product(from: shortProductCode, extendedDeckfmtValue: longProductCode) else {
			throw AlteredDeckFormat.DecodeError.invalidProduct
		}

		return product
	}

	private static func decodeFaction(bitData: BitData, bitReadCount: inout UInt) throws -> Faction {
		let factionCode = try bitData.read(atBitIndex: bitReadCount, bitCount: 3)
		bitReadCount += 3

		guard let faction = Faction.faction(from: factionCode) else {
			throw AlteredDeckFormat.DecodeError.invalidFaction
		}

		return faction
	}

	private static func decodeCardIDInFaction(bitData: BitData, bitReadCount: inout UInt) throws -> UInt {
		let idInFaction = try bitData.read(atBitIndex: bitReadCount, bitCount: 5)
		bitReadCount += 5

		return UInt(idInFaction)
	}

	private static func decodeRarity(bitData: BitData, bitReadCount: inout UInt) throws -> Rarity {
		let rarityCode = try bitData.read(atBitIndex: bitReadCount, bitCount: 2)
		bitReadCount += 2

		guard let rarity = Rarity.rarity(from: rarityCode) else {
			throw AlteredDeckFormat.DecodeError.invalidRarity
		}

		return rarity
	}

	private static func decodeUniqueID(bitData: BitData, bitReadCount: inout UInt) throws -> UInt {
		let uniqueID = try bitData.read(atBitIndex: bitReadCount, bitCount: 16)
		bitReadCount += 16

		return UInt(uniqueID)
	}
}

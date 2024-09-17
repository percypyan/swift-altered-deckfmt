//
//  DeckEncoder.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Foundation

// MARK: - Encoder

struct DeckEncoder {
	static func encode(_ deck: Deck) throws -> Data {
		let bitDataWriter = BitDataWriter()

		// Header
		// 4-bit version
		// 8-bit groups count
		// ... sub groups
		bitDataWriter.append(1, bitCount: 4)
		bitDataWriter.append(UInt16(deck.cardSetGroups.count), bitCount: 8)

		// Sub Group
		// 8-bit set code
		// 6-bit card refs count
		// ... card refs
		let sortedGroupKeys = deck.cardSetGroups.keys.sorted()
		for groupKey in sortedGroupKeys {
			let cardEntries = deck.cardSetGroups[groupKey]!
			bitDataWriter.append(groupKey.deckfmtValue, bitCount: 8)
			bitDataWriter.append(UInt16(cardEntries.count), bitCount: 6)

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
					bitDataWriter.append(UInt16(entry.count), bitCount: 2)
				} else {
					bitDataWriter.append(0, bitCount: 2)
					bitDataWriter.append(UInt16(entry.count - 3), bitCount: 6)
				}

				// Card
				// 1-bit Is booster product
				// 2-bit product (optional, only if is not booster)
				bitDataWriter.append(
					entry.card.product.deckfmtValue,
					bitCount: entry.card.product.deckfmtBitCount)
				// 3-bit faction
				bitDataWriter.append(entry.card.originFaction.deckfmtValue, bitCount: 3)
				// 5-bit ID in faction
				bitDataWriter.append(UInt16(entry.card.idInFaction), bitCount: 5)
				// 2-bit rarity
				bitDataWriter.append(entry.card.rarity.deckfmtValue, bitCount: 2)
				// 16-bit unique ID (optional)
				if entry.card.rarity == .unique, let uniqueID = entry.card.uniqueID {
					bitDataWriter.append(UInt16(uniqueID), bitCount: 16)
				}
			}
		}

		bitDataWriter.commitBuffer()
		return bitDataWriter.data
	}
}

//
//  DeckParserTests.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Testing
@testable import AlteredDeckFormat

@Test("Parse deck from list string")
func parseDeckFromListString() throws {
	let deckListString = "1 ALT_CORE_B_YZ_02_C\n1 ALT_CORE_B_AX_11_R1\n3 ALT_COREKS_B_LY_28_C\n"

	let deck = try DeckParser.parseDeck(deckListString)

	#expect(deck.cardSetGroups.count == 2)
	#expect(deck.cardSetGroups[.core]?.count == 2)

	#expect(deck.cardSetGroups[.core]?[0].count == 1)
	#expect(deck.cardSetGroups[.core]?[0].card == Card(
		set: .core,
		product: .booster,
		originFaction: .yzmir,
		idInFaction: 2,
		rarity: .common))

	#expect(deck.cardSetGroups[.core]?[1].count == 1)
	#expect(deck.cardSetGroups[.core]?[1].card == Card(
		set: .core,
		product: .booster,
		originFaction: .axiom,
		idInFaction: 11,
		rarity: .rareInFaction))

	#expect(deck.cardSetGroups[.coreKickstarter]?[0].count == 3)
	#expect(deck.cardSetGroups[.coreKickstarter]?[0].card == Card(
		set: .coreKickstarter,
		product: .booster,
		originFaction: .lyra,
		idInFaction: 28,
		rarity: .common))
}

@Test("Parser should filter card with quantity 0")
func parseShouldFilterOutZeroQtCards() throws {
	let deckListString = "1 ALT_CORE_B_YZ_02_C\n0 ALT_CORE_B_AX_11_R1\n3 ALT_CORE_B_LY_28_C\n"

	let deck = try DeckParser.parseDeck(deckListString)

	#expect(deck.cardSetGroups.count == 1)
	#expect(deck.cardSetGroups[.core]?.count == 2)

	#expect(deck.cardSetGroups[.core]?[0].count == 1)
	#expect(deck.cardSetGroups[.core]?[0].card == Card(
		set: .core,
		product: .booster,
		originFaction: .yzmir,
		idInFaction: 2,
		rarity: .common))

	#expect(deck.cardSetGroups[.core]?[1].count == 3)
	#expect(deck.cardSetGroups[.core]?[1].card == Card(
		set: .core,
		product: .booster,
		originFaction: .lyra,
		idInFaction: 28,
		rarity: .common))
}

@Test("Parser should works with and empty list")
func parseEmptyDeckListString() throws {
	let deckListString = ""

	let deck = try DeckParser.parseDeck(deckListString)

	#expect(deck.cardSetGroups.count == 0)
}

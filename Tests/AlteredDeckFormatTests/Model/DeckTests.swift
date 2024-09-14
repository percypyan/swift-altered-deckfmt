//
//  DeckTests.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 13/09/2024.
//

import Testing
@testable import AlteredDeckFormat

@Test("Create a new deck")
func createDeck() {
	let deck = Deck()
	#expect(deck.cardSetGroups.isEmpty)
}

@Test("Add a card from a new set")
func addCardFromNewSet() {
	var deck = Deck()
	let cardCore = Card(
		set: .core,
		product: .booster,
		originFaction: .axiom,
		idInFaction: 3,
		rarity: .common)
	let cardCoreKS = Card(
		set: .coreKickstarter,
		product: .booster,
		originFaction: .lyra,
		idInFaction: 2,
		rarity: .common)

	deck.addCard(cardCore, count: 3)

	#expect(deck.cardSetGroups.count == 1)
	#expect(deck.cardSetGroups[.core]?.count == 1)
	#expect(deck.cardSetGroups[.core]?[0].card == cardCore)
	#expect(deck.cardSetGroups[.core]?[0].count == 3)

	deck.addCard(cardCoreKS, count: 2)

	#expect(deck.cardSetGroups.count == 2)
	#expect(deck.cardSetGroups[.core]?.count == 1)
	#expect(deck.cardSetGroups[.core]?[0].card == cardCore)
	#expect(deck.cardSetGroups[.core]?[0].count == 3)
	#expect(deck.cardSetGroups[.coreKickstarter]?.count == 1)
	#expect(deck.cardSetGroups[.coreKickstarter]?[0].card == cardCoreKS)
	#expect(deck.cardSetGroups[.coreKickstarter]?[0].count == 2)
}

@Test("Add a card from a existing set")
func addCardFromExistingSet() {
	var deck = Deck()
	let cardCore = Card(
		set: .core,
		product: .booster,
		originFaction: .axiom,
		idInFaction: 3,
		rarity: .common)
	let card2Core = Card(
		set: .core,
		product: .booster,
		originFaction: .lyra,
		idInFaction: 7,
		rarity: .rareInFaction)

	deck.addCard(cardCore, count: 2)

	#expect(deck.cardSetGroups.count == 1)
	#expect(deck.cardSetGroups[.core]?.count == 1)
	#expect(deck.cardSetGroups[.core]?[0].card == cardCore)
	#expect(deck.cardSetGroups[.core]?[0].count == 2)

	deck.addCard(card2Core, count: 1)

	#expect(deck.cardSetGroups.count == 1)
	#expect(deck.cardSetGroups[.core]?.count == 2)
	#expect(deck.cardSetGroups[.core]?[0].card == cardCore)
	#expect(deck.cardSetGroups[.core]?[0].count == 2)
	#expect(deck.cardSetGroups[.core]?[1].card == card2Core)
	#expect(deck.cardSetGroups[.core]?[1].count == 1)
}

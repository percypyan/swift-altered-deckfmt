//
//  CardIdentifierParserTests.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 12/09/2024.
//

import Testing
@testable import AlteredDeckFormat

@Test("Throws when identifier is invalid", arguments: [
	"AL_CORE_B_BR_03_C",
	"ALT_CRE_B_BR_03_C",
	"ALT_CORE_T_B_C",
	"ALT_CORE_B_BR_03_F",
	"ALT_CORE_B_BR_03_C_20391192332",
	"ALT_CORE_B_BR_03_U",
	"ALT_CORE_BR_B_03_C",
	"ALT-CORE-B-BR-03-C",
	"ALT_CORE_B_BR_00_C",
	"ALT_CORE_B_BR_33_C",
])
func throwForInvalidIdentifiers(invalidID: String) async throws {
	#expect(throws: AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: invalidID), performing: {
		try CardIdentifierParser.parse(invalidID)
	})
}

@Test("Throws when identifier is invalid", arguments: [
	("ALT_CORE_B_BR_03_C", Card(set: .core, product: .booster, originFaction: .bravos, idInFaction: 3, rarity: .common)),
	("ALT_CORE_A_AX_09_C", Card(set: .core, product: .alternativeArt, originFaction: .axiom, idInFaction: 9, rarity: .common)),
	("ALT_CORE_P_LY_23_R1", Card(set: .core, product: .promotion, originFaction: .lyra, idInFaction: 23, rarity: .rareInFaction)),
	("ALT_COREKS_B_MU_30_R2", Card(set: .coreKickstarter, product: .booster, originFaction: .muna, idInFaction: 30, rarity: .rareOutOfFaction)),
	("ALT_CORE_B_YZ_01_R1", Card(set: .core, product: .booster, originFaction: .yzmir, idInFaction: 1, rarity: .rareInFaction)),
	("ALT_CORE_B_BR_03_U_118218", Card(set: .core, product: .booster, originFaction: .bravos, idInFaction: 3, rarity: .unique, uniqueID: 118218)),
])
func parseCard(forID id: String, matchingCard: Card) async throws {
	#expect(try CardIdentifierParser.parse(id) == matchingCard)
}

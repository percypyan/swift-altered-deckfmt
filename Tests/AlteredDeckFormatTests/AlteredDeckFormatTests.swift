//
//  AlteredDeckFormatTests.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 14/09/2024.
//

import Foundation
import Testing
@testable import AlteredDeckFormat

func sortAndTrimDeckList(_ deckList: String) -> String {
	let lines = deckList.split(separator: "\n")
	return lines
		.sorted()
		.joined(separator: .init("\n"))
		.trimmingCharacters(in: .whitespacesAndNewlines)
}

extension AlteredDeckFormat.ParseError: Equatable {
	public static func == (lhs: AlteredDeckFormat.ParseError, rhs: AlteredDeckFormat.ParseError) -> Bool {
		switch (lhs, rhs) {
		case (.invalidFormat(let l), .invalidFormat(let r)): return l == r
		case (.invalidIdentifier(let l), .invalidIdentifier(let r)): return l == r
		default: return false
		}
	}
}

@Test("Altered Deck Format encoding", arguments: [
	("List1Offs.txt", "ECAi6XDK1p0zBpiM2WcFPRv0zkZygKbIxlCygpOUtKSrKlkiyYZWMuaYFi5mQ7GpsM4afDPk"),
	("List2Sets.txt", "ECAjGhnSHpR0s6gdRaqPWRrRVp64deQESnV0UqcdPA"),
	("ListUniques.txt", "EBAVnBjhHww4lcSeILFNjDx5S-so2TPLDRcOHGX4iUOcWt1XazI5t8wW8g"),
	("ListYzmir.txt", "EBAk3hnUK4h8daVOIvjFyx5h846zfTGuXmb6p9YuwPaHsgA"),
	("TestExtdQty.txt", "EBAgTTMo"),
	("TestLongUniques.txt", "EBARGz4JpNnycPbPmBy2f__8"),
	("TestManaOrb.txt", "EBAg3hHfC8IA"),
	("TestProducts.txt", "EBAg04RrTJLU")
])
func encodeDeckList(_ testFilePath: String, _ base64String: String) throws {
	let deckListURL = Bundle.module.url(forResource: testFilePath, withExtension: nil)!
	let content = try String(contentsOf: deckListURL)
	let result = try AlteredDeckFormat.encodeToBase64URL(content)
	#expect(result == base64String)
}

@Test("Altered Deck Format decoding", arguments: [
	("ECAi6XDK1p0zBpiM2WcFPRv0zkZygKbIxlCygpOUtKSrKlkiyYZWMuaYFi5mQ7GpsM4afDPk", "List1Offs.txt"),
	("ECARKdXRSpx08AjGhnSHpR0s6gdRaqPWRrRVp64deQ", "List2Sets.txt"),
	("EBAVnBjhHww4lcSeILFNjDx5S-so2TPLDRcOHGX4iUOcWt1XazI5t8wW8g", "ListUniques.txt"),
	("EBAk3hnUK4h8daVOIvjFyx5h846zfTGuXmb6p9YuwPaHsgA", "ListYzmir.txt"),
	("EBAgTTMo", "TestExtdQty.txt"),
	("EBARGz4JpNnycPbPmBy2f__8", "TestLongUniques.txt"),
	("EBAg3hHfC8IA", "TestManaOrb.txt"),
	("EBAg04RrTJLU", "TestProducts.txt")

])
func decodeDeckList(_ base64String: String, _ testFilePath: String) throws {
	let deckListURL = Bundle.module.url(forResource: testFilePath, withExtension: nil)!
	let deckListString = try String(contentsOf: deckListURL)

	let result = try AlteredDeckFormat.decodeFromBase64URL(base64String)

	#expect(sortAndTrimDeckList(result) == sortAndTrimDeckList(deckListString))
}

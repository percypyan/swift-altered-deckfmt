//
//  AlteredDeckFormat.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 14/09/2024.
//

import Foundation

public struct AlteredDeckFormat {
	/// Encode a deck list string into binary data using the altered-deckfmt.
	/// - Parameters:
	///   - deckListString: A deck list string.
	/// - Returns: A Data object containing the deck list encoded with altered-deckfmt.
	static func encode(_ deckListString: String) throws -> Data {
		let deck = try DeckParser.parseDeck(deckListString)
		return try DeckCoder.encode(deck)
	}

	/// Decode binary data using the altered-deckfmt into a deck list string.
	/// - Parameters:
	///   - data: Data encoded in altered-deckfmt.
	/// - Returns: A deck list string.
	static func decode(_ data: Data) throws -> String {
		let deck = try DeckCoder.decode(data)
		return deck.listString
	}

	/// Encode a deck list string into a base64URL string using the altered-deckfmt.
	/// - Parameters:
	///   - deckListString: A deck list string.
	/// - Returns: A base64URL string containing the deck list encoded with altered-deckfmt.
	static func encodeToBase64URL(_ deckListString: String) throws -> String {
		let data = try encode(deckListString)
		let base64 = data.base64EncodedString()
		return Base64URLConverter.makeURLSafe(base64)
	}

	/// Decode a base64URL string using the altered-deckfmt into a deck list string.
	/// - Parameters:
	///   - base64URLSafeString: A base64URL string encoded in altered-deckfmt.
	/// - Returns: A deck list string.
	static func decodeFromBase64URL(_ base64URLSafeString: String) throws -> String {
		let base64String = Base64URLConverter.convertToStandardBase64(base64URLSafeString)

		guard let data = Data(base64Encoded: base64String) else {
			throw DecodeError.invalidBase64URLString
		}

		return try decode(data)
	}
}

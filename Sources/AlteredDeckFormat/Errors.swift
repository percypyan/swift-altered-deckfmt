//
//  Errors.swift
//  AlteredDeckFormat
//
//  Created by Perceval Archimbaud on 16/09/2024.
//

public extension AlteredDeckFormat {
	enum ParseError: Error {
		/// The deck list string contains a invalid line that doesn't respect the convention.
		case invalidFormat(faultyLine: String)
		/// The deck list string contains a invalid card identifier.
		case invalidIdentifier(faultyIdentifier: String)
	}
	enum EncodeError: Error {
		/// Maximum number of copies (65) exceed for a card.
		case exceedMaxCardQuantity
		/// The ID in faction of on a card is invalid (must be between 0 and 32 included).
		case invalidCardIDInFaction
	}
	enum DecodeError: Error {
		/// The base64URL string is invalid and cannot be converted back to binary data.
		case invalidBase64URLString
		/// The version of the altered-deckfmt used is unsupported.
		case invalidVersion
		/// A card set ID is unsupported.
		case invalidCardSet
		/// A product ID is unsupported.
		case invalidProduct
		/// A faction ID is unsupported.
		case invalidFaction
		/// A rarity ID is unsupported.
		case invalidRarity
	}
}

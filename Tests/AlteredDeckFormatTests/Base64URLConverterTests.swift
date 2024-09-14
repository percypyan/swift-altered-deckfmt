//
//  Base64URLConverterTests.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 14/09/2024.
//

import Testing
@testable import AlteredDeckFormat

@Test("Make a base64 URL safe", arguments: [
	("EBARGz4JpNnycPbPmBy2f//8", "EBARGz4JpNnycPbPmBy2f__8"),
	("QQ==", "QQ"),
	("SGVsbG+gV29ybGQhDQo=", "SGVsbG-gV29ybGQhDQo"),
	("SGVsbG+gV29/+GQhDQo=", "SGVsbG-gV29_-GQhDQo")
])
func convertBase64ToURLSafeVersion(_ base64: String, _ expectedBase64URL: String) async throws {
	#expect(Base64URLConverter.makeURLSafe(base64) == expectedBase64URL)
}

@Test("Retrieve a base64 string from URL safe base64 string", arguments: [
	("EBARGz4JpNnycPbPmBy2f__8", "EBARGz4JpNnycPbPmBy2f//8"),
	("QQ", "QQ=="),
	("SGVsbG-gV29ybGQhDQo", "SGVsbG+gV29ybGQhDQo="),
	("SGVsbG-gV29_-GQhDQo", "SGVsbG+gV29/+GQhDQo=")
])
func convertBase64URLSafeToBase64Version(_ base64URL: String, _ expectedBase64: String) async throws {
	#expect(Base64URLConverter.convertToStandardBase64(base64URL) == expectedBase64)
}

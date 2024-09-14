//
//  Base64URLConverter.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 14/09/2024.
//

struct Base64URLConverter {
	static func makeURLSafe(_ base64: String) -> String {
		return base64
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
			.replacingOccurrences(of: "\n", with: "")

	}
	static func convertToStandardBase64(_ base64URLSafe: String) -> String {
		var validBase64 = base64URLSafe
			.replacingOccurrences(of: "-", with: "+")
			.replacingOccurrences(of: "_", with: "/")

		while !validBase64.count.isMultiple(of: 4) {
			validBase64.append("=")
		}

		return validBase64
	}
}

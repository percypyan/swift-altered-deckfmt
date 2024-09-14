# Swift Package altered-deckfmt

_This project is a Swift port of the [Taum's altered-deckfmt](https://github.com/Taum/altered-deckfmt) npm module._ 

A compact format to share deck lists for Altered TCG.

This binary format can be encoded to Base64URL to share decks in URL-safe codes. As an example, a reasonable deck list such as:

```
1 ALT_CORE_B_YZ_03_C
3 ALT_CORE_B_BR_16_R2
2 ALT_CORE_B_YZ_04_C
3 ALT_CORE_B_YZ_07_R1
1 ALT_CORE_B_BR_10_R2
1 ALT_CORE_B_MU_08_R2
3 ALT_CORE_B_YZ_06_C
2 ALT_CORE_B_YZ_11_C
1 ALT_CORE_B_YZ_12_C
3 ALT_CORE_B_YZ_14_C
3 ALT_CORE_B_BR_25_R2
3 ALT_CORE_B_YZ_19_C
1 ALT_CORE_B_BR_28_R2
3 ALT_CORE_B_MU_25_R2
3 ALT_CORE_B_YZ_21_C
3 ALT_CORE_B_YZ_22_C
2 ALT_CORE_B_YZ_24_C
1 ALT_CORE_B_YZ_26_C
1 ALT_CORE_B_YZ_25_C
```

Can be encoded into the string:
```
EBAk3DNQrEPHVKmIvGLLHMPONZvTFcuZvVPWLYHaHZA=
```

This project provides a Swift Package containing an API to encode of decode this format.

The format specification is available under the original project, see **External documentation**.

## External documentation

- [Original altered-deckfmt repository](https://github.com/Taum/altered-deckfmt)
- [Original altered-deckfmt format specification](https://github.com/Taum/altered-deckfmt/blob/main/FORMAT_SPEC.md)
- [Base64URL specification](https://base64.guru/standards/base64url)

## Basic usage

See `Tests/altered-deckfmtTests/AlteredDeckFormatTests` for an example of using the basic API.

### Encoding

```swift
import AlteredDeckFormat

let myList = "1 ALT_CORE_B_YZ_03_C\n3 ALT_CORE_B_BR_16_R2 ..."
let base64URLDeck = try AlteredDeckFormat.encodeToBase64URL(myList)

print(base64URLDeck) // "EBAk3DNQrEPHVKmIvGLLHMPONZvTFcuZvVPWLYHaHZA="
```

### Decoding

```swift
import AlteredDeckFormat

let base64URLDeck = "EBAk3DNQrEPHVKmIvGLLHMPONZvTFcuZvVPWLYHaHZA="
let deckList = try AlteredDeckFormat.decodeFromBase64URL(base64URLDeck)

print(deckList) // "1 ALT_CORE_B_YZ_03_C\n3 ALT_CORE_B_BR_16_R2 ..."
```

## Full API

### Encoding

Encode a deck list string into binary data using the altered-deckfmt.
```swift
AlteredDeckFormat.encode(_ deckListString: String) throws -> Data
```

Encode a deck list string into a base64URL string using the altered-deckfmt.
```swift
AlteredDeckFormat.encodeToBase64URL(_ deckListString: String) throws -> String
```

**Errors**

`AlteredDeckFormat.ParseError.invalidFormat(faultyLine: String)`

_The deck list string contains at least an invalid line (that you can retrieve through `faultyLine` parameter)._


`AlteredDeckFormat.ParseError.invalidIdentifier(faultyIdentifier: String)`

_The deck list string contains at least an invalid card identifier (that you can retrieve through `faultyIdentifier` parameter)._


`AlteredDeckFormat.EncodeError.exceedMaxCardQuantity`

_One of the cards in the list exceed to maximum quantity of 65 copies._


`AlteredDeckFormat.EncodeError.invalidCardIDInFaction`

_One of the cards in the list has an invalid ID in faction (allowed range: 0-32)._

### Decoding

Decode binary data using the altered-deckfmt into a deck list string.
```swift
AlteredDeckFormat.decode(_ data: Data) throws -> String
```

Decode a base64URL string using the altered-deckfmt into a deck list string.
```swift
AlteredDeckFormat.decodeFromBase64URL(_ base64URLSafeString: String) throws -> String
```

**Errors**

`AlteredDeckFormat.DecodeError.invalidFormat`

_The provided base64URL string is invalid._


`AlteredDeckFormat.DecodeError.invalidVersion`

_The format version isn't supported._


`AlteredDeckFormat.DecodeError.invalidCardSet`

_Data contains an unsupported card set value._


`AlteredDeckFormat.DecodeError.invalidProduct`

_Data contains an unsupported product value._


`AlteredDeckFormat.DecodeError.invalidFaction`

_Data contains an unsupported faction value._


`AlteredDeckFormat.DecodeError.invalidRarity`

_Data contains an unsupported rarity value._

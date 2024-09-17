//
//  BitDataTests.swift
//  altered-deckfmt
//
//  Created by Perceval Archimbaud on 14/09/2024.
//

import Testing
import Foundation
@testable import AlteredDeckFormat

@Test("Create empty BitDataWriter instance")
func createEmptyBitData() {
	#expect(BitDataWriter().data.isEmpty)
}

@Test("Create BitDataReader from existing data")
func createBitDataFromExistingData() {
	let data = Data([1, 2, 3])
	#expect(BitDataReader(data).data == data)
}

@Test("Append bits to BitDataWriter - simple")
func appendBitsToBitDataSimple() {
	let bitData = BitDataWriter()
	bitData.append(15, bitCount: 4)
	#expect(bitData.data.isEmpty)
	bitData.commitBuffer()
	#expect(bitData.data.first == 15 << 4)
}

@Test("Append bits to BitDataWriter - medium")
func appendBitsToBitDataMedium() {
	let bitData = BitDataWriter()
	bitData.append(15, bitCount: 4)
	bitData.append(1, bitCount: 6)
	bitData.append(7, bitCount: 3)
	bitData.commitBuffer()

	#expect(bitData.data.count == 2)
	#expect(bitData.data.first == 15 << 4)
	#expect(bitData.data.last == (1 << 6) + (7 << 3))
}

@Test("Append bits to BitDataWriter - hard")
func appendBitsToBitDataHard() {
	let bitData = BitDataWriter()
	bitData.append(15, bitCount: 4)
	bitData.append(1, bitCount: 6)
	bitData.append(7, bitCount: 3)
	bitData.append(320, bitCount: 16)
	bitData.commitBuffer()

	#expect(bitData.data.count == 4)
	#expect(bitData.data.first == 15 << 4)
	#expect(bitData.data[1] == 120)
	#expect(bitData.data[2] == 10)
	#expect(bitData.data[3] == 0)
}

@Test("Read bits to BitDataReader")
func readBits() throws {
	let bitData = BitDataReader(Data([0b0110_1101, 0b0100_0001, 0b1110_0100]))

	#expect(try bitData.read(2) == 0b01)
	#expect(try bitData.read(4) == 0b1011)
	#expect(try bitData.read(4) == 0b0101)

	let bitData2 = BitDataReader(Data([0b0110_1101, 0b0100_0001, 0b1110_0100]))
	#expect(try bitData2.read(7) == 0b0011_0110)
	#expect(try bitData2.read(16) == 0b1010_0000_1111_0010)
}

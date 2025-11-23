import 'dart:typed_data';

class EnhancedAES128 {
  final Uint8List key; // 16 bytes

  EnhancedAES128(Uint8List key)
    : assert(key.length == 16),
      key = Uint8List.fromList(key);

  // Standard AES Substitution-box
  static const List<int> _sbox = [
    0x63,
    0x7C,
    0x77,
    0x7B,
    0xF2,
    0x6B,
    0x6F,
    0xC5,
    0x30,
    0x01,
    0x67,
    0x2B,
    0xFE,
    0xD7,
    0xAB,
    0x76,
    0xCA,
    0x82,
    0xC9,
    0x7D,
    0xFA,
    0x59,
    0x47,
    0xF0,
    0xAD,
    0xD4,
    0xA2,
    0xAF,
    0x9C,
    0xA4,
    0x72,
    0xC0,
    0xB7,
    0xFD,
    0x93,
    0x26,
    0x36,
    0x3F,
    0xF7,
    0xCC,
    0x34,
    0xA5,
    0xE5,
    0xF1,
    0x71,
    0xD8,
    0x31,
    0x15,
    0x04,
    0xC7,
    0x23,
    0xC3,
    0x18,
    0x96,
    0x05,
    0x9A,
    0x07,
    0x12,
    0x80,
    0xE2,
    0xEB,
    0x27,
    0xB2,
    0x75,
    0x09,
    0x83,
    0x2C,
    0x1A,
    0x1B,
    0x6E,
    0x5A,
    0xA0,
    0x52,
    0x3B,
    0xD6,
    0xB3,
    0x29,
    0xE3,
    0x2F,
    0x84,
    0x53,
    0xD1,
    0x00,
    0xED,
    0x20,
    0xFC,
    0xB1,
    0x5B,
    0x6A,
    0xCB,
    0xBE,
    0x39,
    0x4A,
    0x4C,
    0x58,
    0xCF,
    0xD0,
    0xEF,
    0xAA,
    0xFB,
    0x43,
    0x4D,
    0x33,
    0x85,
    0x45,
    0xF9,
    0x02,
    0x7F,
    0x50,
    0x3C,
    0x9F,
    0xA8,
    0x51,
    0xA3,
    0x40,
    0x8F,
    0x92,
    0x9D,
    0x38,
    0xF5,
    0xBC,
    0xB6,
    0xDA,
    0x21,
    0x10,
    0xFF,
    0xF3,
    0xD2,
    0xCD,
    0x0C,
    0x13,
    0xEC,
    0x5F,
    0x97,
    0x44,
    0x17,
    0xC4,
    0xA7,
    0x7E,
    0x3D,
    0x64,
    0x5D,
    0x19,
    0x73,
    0x60,
    0x81,
    0x4F,
    0xDC,
    0x22,
    0x2A,
    0x90,
    0x88,
    0x46,
    0xEE,
    0xB8,
    0x14,
    0xDE,
    0x5E,
    0x0B,
    0xDB,
    0xE0,
    0x32,
    0x3A,
    0x0A,
    0x49,
    0x06,
    0x24,
    0x5C,
    0xC2,
    0xD3,
    0xAC,
    0x62,
    0x91,
    0x95,
    0xE4,
    0x79,
    0xE7,
    0xC8,
    0x37,
    0x6D,
    0x8D,
    0xD5,
    0x4E,
    0xA9,
    0x6C,
    0x56,
    0xF4,
    0xEA,
    0x65,
    0x7A,
    0xAE,
    0x08,
    0xBA,
    0x78,
    0x25,
    0x2E,
    0x1C,
    0xA6,
    0xB4,
    0xC6,
    0xE8,
    0xDD,
    0x74,
    0x1F,
    0x4B,
    0xBD,
    0x8B,
    0x8A,
    0x70,
    0x3E,
    0xB5,
    0x66,
    0x48,
    0x03,
    0xF6,
    0x0E,
    0x61,
    0x35,
    0x57,
    0xB9,
    0x86,
    0xC1,
    0x1D,
    0x9E,
    0xE1,
    0xF8,
    0x98,
    0x11,
    0x69,
    0xD9,
    0x8E,
    0x94,
    0x9B,
    0x1E,
    0x87,
    0xE9,
    0xCE,
    0x55,
    0x28,
    0xDF,
    0x8C,
    0xA1,
    0x89,
    0x0D,
    0xBF,
    0xE6,
    0x42,
    0x68,
    0x41,
    0x99,
    0x2D,
    0x0F,
    0xB0,
    0x54,
    0xBB,
    0x16,
  ];
  // Number of rounds
  static const int numRounds = 8;
  // words each state
  static const int keyWords = 4;
  // number of State columns
  static const int stateColumns = 4;

  // Expanded round keys
  late final Uint8List _roundKeys = _keyExpansion();

  Uint8List encryptBlock(Uint8List input16) {
    assert(input16.length == 16);
    // State as 4x4 column-major
    final state = Uint8List.fromList(input16);

    _addRoundKey(state, 0);

    // Full rounds 1 to (numRounds-1)
    for (int round = 1; round < numRounds; round++) {
      _subBytes(state);
      _dynamicShiftRows(state);
      _lfsrMixColumns(state);
      _addRoundKey(state, round);
    }

    // Final round (no MixColumns)
    _subBytes(state);
    _dynamicShiftRows(state);
    _addRoundKey(state, numRounds);

    return state;
  }

  //priv helpers

  //key expansion function
  Uint8List _keyExpansion() {
    final w = List<int>.filled(stateColumns * (numRounds + 1) * 4, 0);
    // Initial key bytes
    for (int i = 0; i < keyWords * 4; i++) {
      w[i] = key[i];
    }

    int rcon = 1;
    int i = keyWords;
    while (i < stateColumns * (numRounds + 1)) {
      final temp = [
        w[(i - 1) * 4 + 0],
        w[(i - 1) * 4 + 1],
        w[(i - 1) * 4 + 2],
        w[(i - 1) * 4 + 3],
      ];
      if (i % keyWords == 0) {
        // RotWord
        final rotated = [temp[1], temp[2], temp[3], temp[0]];
        // SubWord
        final subbed = rotated.map((b) => _sbox[b]).toList();
        // Rcon XOR
        final rconned = [subbed[0] ^ rcon, subbed[1], subbed[2], subbed[3]];
        rcon = _xtime(rcon);
        // Use rconned as temp
        for (int j = 0; j < 4; j++) {
          w[i * 4 + j] = w[(i - keyWords) * 4 + j] ^ rconned[j];
        }
      } else {
        // Direct XOR
        for (int j = 0; j < 4; j++) {
          w[i * 4 + j] = w[(i - keyWords) * 4 + j] ^ temp[j];
        }
      }
      i++;
    }

    // Flatten to column-major round keys
    final expanded = Uint8List((numRounds + 1) * stateColumns * 4);
    for (int rk = 0; rk <= numRounds; rk++) {
      for (int col = 0; col < stateColumns; col++) {
        for (int row = 0; row < 4; row++) {
          expanded[rk * (stateColumns * 4) + col * 4 + row] =
              w[(rk * stateColumns + col) * 4 + row];
        }
      }
    }
    return expanded;
  }

  int _xtime(int a) {
    // Multiply by x in GF(2^8)
    return ((a << 1) ^ ((a & 0x80) != 0 ? 0x1B : 0)) & 0xFF;
  }

  void _addRoundKey(Uint8List state, int round) {
    final base = round * (stateColumns * 4);
    for (int i = 0; i < stateColumns * 4; i++) {
      //perform xor operation each byte
      state[i] ^= _roundKeys[base + i];
    }
  }

  void _subBytes(Uint8List s) {
    for (int i = 0; i < 16; i++) {
      s[i] = _sbox[s[i]];
    }
  }

  // Dynamic ShiftRows
  void _dynamicShiftRows(Uint8List state) {
    //shift position based on the current key
    final shifts = [0, key[0] & 0x03, key[1] & 0x03, key[2] & 0x03];

    final temp = Uint8List(16); //temporary 16-byte array
    for (int row = 0; row < 4; row++) {
      //iterates over each row (0 to 3)
      for (int col = 0; col < 4; col++) {
        //iterates over each column (0 to 3).
        final fromCol =
            (col + shifts[row]) %
            4; //computes which column in the original state the current byte should come from — after applying the shift
        temp[col * 4 + row] =
            state[fromCol * 4 +
                row]; //actual copying of bytes to their new shifted positions.
      }
    }
    //Write back the new shifted state
    state.setAll(0, temp);
  }

  // LFSR-inspired MixColumns (GF(2^8) variant
  void _lfsrMixColumns(Uint8List state) {
    //loop over columns
    for (int col = 0; col < stateColumns; col++) {
      //Compute index of the column’s first byte
      final idx = col * 4;

      //Extract the four bytes of that column
      final b0 = state[idx + 0];
      final b1 = state[idx + 1];
      final b2 = state[idx + 2];
      final b3 = state[idx + 3];

      //Apply LFSR-inspired feedback logic
      final nb0 = (b0 ^ b1) & 0xFF;
      final nb1 = (b1 ^ b2) & 0xFF;
      final nb2 = (b2 ^ b3) & 0xFF;
      final nb3 = (b3 ^ _xtime(b0)) & 0xFF;

      //Write new column values back to state
      state[idx + 0] = nb0;
      state[idx + 1] = nb1;
      state[idx + 2] = nb2;
      state[idx + 3] = nb3;
    }
  }
}

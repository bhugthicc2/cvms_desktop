// Enhanced AES-128 (8 rounds) with Dynamic ShiftRows and LFSR-based MixColumns.
// Intended for small fixed-size plaintexts (16 bytes) such as VehicleID blocks.
// WARNING: Research prototype — not a certified replacement for AES in production.

import 'dart:typed_data';

class EnhancedAES128 {
  final Uint8List key; // 16 bytes

  EnhancedAES128(Uint8List key)
    : assert(key.length == 16),
      key = Uint8List.fromList(key);

  // AES S-box (standard)
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

  // AES inverse S-box (standard)
  static const List<int> _invSbox = [
    0x52,
    0x09,
    0x6A,
    0xD5,
    0x30,
    0x36,
    0xA5,
    0x38,
    0xBF,
    0x40,
    0xA3,
    0x9E,
    0x81,
    0xF3,
    0xD7,
    0xFB,
    0x7C,
    0xE3,
    0x39,
    0x82,
    0x9B,
    0x2F,
    0xFF,
    0x87,
    0x34,
    0x8E,
    0x43,
    0x44,
    0xC4,
    0xDE,
    0xE9,
    0xCB,
    0x54,
    0x7B,
    0x94,
    0x32,
    0xA6,
    0xC2,
    0x23,
    0x3D,
    0xEE,
    0x4C,
    0x95,
    0x0B,
    0x42,
    0xFA,
    0xC3,
    0x4E,
    0x08,
    0x2E,
    0xA1,
    0x66,
    0x28,
    0xD9,
    0x24,
    0xB2,
    0x76,
    0x5B,
    0xA2,
    0x49,
    0x6D,
    0x8B,
    0xD1,
    0x25,
    0x72,
    0xF8,
    0xF6,
    0x64,
    0x86,
    0x68,
    0x98,
    0x16,
    0xD4,
    0xA4,
    0x5C,
    0xCC,
    0x5D,
    0x65,
    0xB6,
    0x92,
    0x6C,
    0x70,
    0x48,
    0x50,
    0xFD,
    0xED,
    0xB9,
    0xDA,
    0x5E,
    0x15,
    0x46,
    0x57,
    0xA7,
    0x8D,
    0x9D,
    0x84,
    0x90,
    0xD8,
    0xAB,
    0x00,
    0x8C,
    0xBC,
    0xD3,
    0x0A,
    0xF7,
    0xE4,
    0x58,
    0x05,
    0xB8,
    0xB3,
    0x45,
    0x06,
    0xD0,
    0x2C,
    0x1E,
    0x8F,
    0xCA,
    0x3F,
    0x0F,
    0x02,
    0xC1,
    0xAF,
    0xBD,
    0x03,
    0x01,
    0x13,
    0x8A,
    0x6B,
    0x3A,
    0x91,
    0x11,
    0x41,
    0x4F,
    0x67,
    0xDC,
    0xEA,
    0x97,
    0xF2,
    0xCF,
    0xCE,
    0xF0,
    0xB4,
    0xE6,
    0x73,
    0x96,
    0xAC,
    0x74,
    0x22,
    0xE7,
    0xAD,
    0x35,
    0x85,
    0xE2,
    0xF9,
    0x37,
    0xE8,
    0x1C,
    0x75,
    0xDF,
    0x6E,
    0x47,
    0xF1,
    0x1A,
    0x71,
    0x1D,
    0x29,
    0xC5,
    0x89,
    0x6F,
    0xB7,
    0x62,
    0x0E,
    0xAA,
    0x18,
    0xBE,
    0x1B,
    0xFC,
    0x56,
    0x3E,
    0x4B,
    0xC6,
    0xD2,
    0x79,
    0x20,
    0x9A,
    0xDB,
    0xC0,
    0xFE,
    0x78,
    0xCD,
    0x5A,
    0xF4,
    0x1F,
    0xDD,
    0xA8,
    0x33,
    0x88,
    0x07,
    0xC7,
    0x31,
    0xB1,
    0x12,
    0x10,
    0x59,
    0x27,
    0x80,
    0xEC,
    0x5F,
    0x60,
    0x51,
    0x7F,
    0xA9,
    0x19,
    0xB5,
    0x4A,
    0x0D,
    0x2D,
    0xE5,
    0x7A,
    0x9F,
    0x93,
    0xC9,
    0x9C,
    0xEF,
    0xA0,
    0xE0,
    0x3B,
    0x4D,
    0xAE,
    0x2A,
    0xF5,
    0xB0,
    0xC8,
    0xEB,
    0xBB,
    0x3C,
    0x83,
    0x53,
    0x99,
    0x61,
    0x17,
    0x2B,
    0x04,
    0x7E,
    0xBA,
    0x77,
    0xD6,
    0x26,
    0xE1,
    0x69,
    0x14,
    0x63,
    0x55,
    0x21,
    0x0C,
    0x7D,
  ];

  // Number of rounds
  static const int Nr = 8;
  static const int Nk = 4; // 128-bit key (words)
  static const int Nb = 4; // State columns

  // Expanded round keys
  late final Uint8List _roundKeys = _keyExpansion();

  Uint8List encryptBlock(Uint8List input16) {
    assert(input16.length == 16);
    // State as 4x4 column-major
    final state = Uint8List.fromList(input16);

    _addRoundKey(state, 0);

    // Full rounds 1 to (Nr-1)
    for (int round = 1; round < Nr; round++) {
      _subBytes(state);
      _dynamicShiftRows(state);
      _lfsrMixColumns(state);
      _addRoundKey(state, round);
    }

    // Final round (no MixColumns)
    _subBytes(state);
    _dynamicShiftRows(state);
    _addRoundKey(state, Nr);

    return state;
  }

  Uint8List decryptBlock(Uint8List input16) {
    assert(input16.length == 16);
    final state = Uint8List.fromList(input16);

    _addRoundKey(state, Nr);

    // Inverse final round
    _invDynamicShiftRows(state);
    _invSubBytes(state);

    // Inverse full rounds (Nr-1) down to 1
    for (int round = Nr - 1; round >= 1; round--) {
      _addRoundKey(state, round);
      _invLfsrMixColumns(state);
      _invDynamicShiftRows(state);
      _invSubBytes(state);
    }

    _addRoundKey(state, 0);
    return state;
  }

  // ---------- Private Helpers ----------

  // Key expansion: produce (Nr+1)*Nb*4 bytes of round keys
  Uint8List _keyExpansion() {
    final w = List<int>.filled(Nb * (Nr + 1) * 4, 0);
    // Initial key bytes
    for (int i = 0; i < Nk * 4; i++) {
      w[i] = key[i];
    }

    int rcon = 1;
    int i = Nk;
    while (i < Nb * (Nr + 1)) {
      final temp = [
        w[(i - 1) * 4 + 0],
        w[(i - 1) * 4 + 1],
        w[(i - 1) * 4 + 2],
        w[(i - 1) * 4 + 3],
      ];
      if (i % Nk == 0) {
        // RotWord
        final rotated = [temp[1], temp[2], temp[3], temp[0]];
        // SubWord
        final subbed = rotated.map((b) => _sbox[b]).toList();
        // Rcon XOR
        final rconned = [subbed[0] ^ rcon, subbed[1], subbed[2], subbed[3]];
        rcon = _xtime(rcon);
        // Use rconned as temp
        for (int j = 0; j < 4; j++) {
          w[i * 4 + j] = w[(i - Nk) * 4 + j] ^ rconned[j];
        }
      } else {
        // Direct XOR
        for (int j = 0; j < 4; j++) {
          w[i * 4 + j] = w[(i - Nk) * 4 + j] ^ temp[j];
        }
      }
      i++;
    }

    // Flatten to column-major round keys
    final expanded = Uint8List((Nr + 1) * Nb * 4);
    for (int rk = 0; rk <= Nr; rk++) {
      for (int col = 0; col < Nb; col++) {
        for (int row = 0; row < 4; row++) {
          expanded[rk * (Nb * 4) + col * 4 + row] =
              w[(rk * Nb + col) * 4 + row];
        }
      }
    }
    return expanded;
  }

  int _xtime(int a) {
    // Multiply by x (i.e., 2) in GF(2^8)
    return ((a << 1) ^ ((a & 0x80) != 0 ? 0x1B : 0)) & 0xFF;
  }

  // GF(2^8) multiplication
  int _gfMult(int a, int b) {
    int p = 0;
    for (int i = 0; i < 8; i++) {
      if ((b & 1) != 0) p ^= a;
      final hiBitSet = (a & 0x80) != 0;
      a = ((a << 1) & 0xFF);
      if (hiBitSet) a ^= 0x1B;
      b >>= 1;
    }
    return p;
  }

  void _addRoundKey(Uint8List state, int round) {
    final base = round * (Nb * 4);
    for (int i = 0; i < Nb * 4; i++) {
      state[i] ^= _roundKeys[base + i];
    }
  }

  void _subBytes(Uint8List s) {
    for (int i = 0; i < 16; i++) {
      s[i] = _sbox[s[i]];
    }
  }

  void _invSubBytes(Uint8List s) {
    for (int i = 0; i < 16; i++) {
      s[i] = _invSbox[s[i]];
    }
  }

  // Dynamic ShiftRows: key-derived shifts (row 0 fixed at 0)
  void _dynamicShiftRows(Uint8List state) {
    final shifts = [0, key[0] & 0x03, key[1] & 0x03, key[2] & 0x03];

    final temp = Uint8List(16);
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        final fromCol = (col + shifts[row]) % 4;
        temp[col * 4 + row] = state[fromCol * 4 + row];
      }
    }
    state.setAll(0, temp);
  }

  void _invDynamicShiftRows(Uint8List state) {
    final shifts = [0, key[0] & 0x03, key[1] & 0x03, key[2] & 0x03];

    final temp = Uint8List(16);
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        var fromCol = (col - shifts[row]) % 4;
        if (fromCol < 0) fromCol += 4;
        temp[col * 4 + row] = state[fromCol * 4 + row];
      }
    }
    state.setAll(0, temp);
  }

  // LFSR-inspired MixColumns (GF(2^8) variant for invertibility)
  void _lfsrMixColumns(Uint8List state) {
    for (int col = 0; col < Nb; col++) {
      final idx = col * 4;
      final b0 = state[idx + 0];
      final b1 = state[idx + 1];
      final b2 = state[idx + 2];
      final b3 = state[idx + 3];

      final nb0 = (b0 ^ b1) & 0xFF;
      final nb1 = (b1 ^ b2) & 0xFF;
      final nb2 = (b2 ^ b3) & 0xFF;
      final nb3 = (b3 ^ _xtime(b0)) & 0xFF;

      state[idx + 0] = nb0;
      state[idx + 1] = nb1;
      state[idx + 2] = nb2;
      state[idx + 3] = nb3;
    }
  }

  // Inverse LFSR MixColumns
  void _invLfsrMixColumns(Uint8List state) {
    const int inv3 = 0xF6; // 3^{-1} in GF(2^8)
    for (int col = 0; col < Nb; col++) {
      final idx = col * 4;
      final b0p = state[idx + 0];
      final b1p = state[idx + 1];
      final b2p = state[idx + 2];
      final b3p = state[idx + 3];

      final s = b0p ^ b1p ^ b2p ^ b3p;
      final b0 = _gfMult(s, inv3) & 0xFF;
      final b1 = (b0p ^ b0) & 0xFF;
      final b2 = (b1p ^ b1) & 0xFF;
      final b3 = (b2p ^ b2) & 0xFF;

      state[idx + 0] = b0;
      state[idx + 1] = b1;
      state[idx + 2] = b2;
      state[idx + 3] = b3;
    }
  }
}

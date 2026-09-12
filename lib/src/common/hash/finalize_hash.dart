/// Applies a final avalanche step to improve bit distribution of [hash].
int finalizeHash(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash ^= hash >> 11;
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}

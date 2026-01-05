class AppConfig {
  // Emulator Android
  // static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Alamat HP fisik
  // static const String baseUrl = 'http://192.168.0.105:8000/api';

  // ===== AUTH (PUBLIC) =====
  static const String register = '/register';
  static const String login = '/login';

  // 🔥 GOOGLE LOGIN (TAMBAHAN)
  static const String googleLogin = '/google-login';

  // ===== PRODUK ROUTES (PUBLIC) =====
  static const String produk = '/produk';
  static const String produkKategori = '/produk/kategori';

  static String getProdukByKategori(String kategori) =>
      '/produk/kategori/$kategori';

  static String getProdukById(int id) => '/produk/$id';

  // ===== PROTECTED ROUTES (SANCTUM) =====

  // Auth
  static const String getUser = '/get-user';
  static const String logout = '/logout';

  // Profile Update
  static const String updateProfile = '/user/profile';

  // Keranjang
  static const String keranjang = '/keranjang';

  static String updateKeranjang(int id) => '/keranjang/$id';
  static String deleteKeranjang(int id) => '/keranjang/$id';

  // Wishlist
  static const String wishlist = '$baseUrl/wishlist';

  // Rating
  static const String ratings = '/ratings';
}

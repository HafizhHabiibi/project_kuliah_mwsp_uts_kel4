class AppConfig {
  // Emulator Android
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Alamat HP fisik
  // static const String baseUrl = 'http://192.168.0.104:8000/api';

  // ===== AUTH (PUBLIC) =====
  static const String register = '/register';
  static const String login = '/login';

  // ===== PRODUK ROUTES (PUBLIC) =====
  static const String produk = '/produk'; // Get all products
  static const String produkKategori = '/produk/kategori'; // Get all categories

  // Dynamic routes - use with string interpolation
  static String getProdukByKategori(String kategori) =>
      '/produk/kategori/$kategori';

  static String getProdukById(int id) => '/produk/$id';

  // ===== PROTECTED ROUTES (SANCTUM) =====

  // Auth
  static const String getUser = '/get-user';
  static const String logout = '/logout';

  // Profile Update
  static const String updateProfile = '/user/profile';

  // Keranjang (Shopping Cart)
  static const String keranjang = '/keranjang'; // View cart & Add to cart

  // Dynamic routes for cart operations
  static String updateKeranjang(int id) => '/keranjang/$id'; // Update quantity
  static String deleteKeranjang(int id) => '/keranjang/$id'; // Remove from cart

  //WISHLIST
  static const String wishlist = '$baseUrl/wishlist';
}

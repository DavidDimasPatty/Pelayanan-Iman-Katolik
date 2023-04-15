import 'package:flutter_dotenv/flutter_dotenv.dart';

var MONGO_CONN_URL = dotenv.env['mongo_url'];
const USER_COLLECTION = "user";
const IMAM_COLLECTION = "imam";
const GEREJA_COLLECTION = "Gereja";
const BAPTIS_COLLECTION = "baptis";
const KRISMA_COLLECTION = "krisma";
const UMUM_COLLECTION = "umum";
const KOMUNI_COLLECTION = "komuni";
const USER_KOMUNI_COLLECTION = "userKomuni";
const USER_BAPTIS_COLLECTION = "userBaptis";
const USER_UMUM_COLLECTION = "userUmum";
const USER_KRISMA_COLLECTION = "userKrisma";
const PEMBERKATAN_COLLECTION = "pemberkatan";
const PERKAWINAN_COLLECTION = "perkawinan";
const GAMBAR_GEREJA_COLLECTION = "gambarGereja";
const ATURAN_PELAYANAN_COLLECTION = "aturanPelayanan";
const ADMIN_COLLECTION = "admin";

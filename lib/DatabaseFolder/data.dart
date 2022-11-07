import 'package:flutter_dotenv/flutter_dotenv.dart';

const MONGO_CONN_URL =
    "mongodb+srv://i18040:wearedead@cluster0.hw29l.mongodb.net/GerejaDB?retryWrites=true&w=majority";
//const MONGO_CONN_URL = dotenv.env['email'].toString();
const USER_COLLECTION = "user";
const GEREJA_COLLECTION = "Gereja";
const JADWAL_GEREJA_COLLECTION = "jadwalGereja";
const TIKET_COLLECTION = "tiket";
const BAPTIS_COLLECTION = "baptis";
const KRISMA_COLLECTION = "krisma";
const UMUM_COLLECTION = "umum";
const KOMUNI_COLLECTION = "komuni";
const USER_KOMUNI_COLLECTION = "userKomuni";
const USER_BAPTIS_COLLECTION = "userBaptis";
const USER_UMUM_COLLECTION = "userUmum";
const USER_KRISMA_COLLECTION = "userKrisma";
const PEMBERKATAN_COLLECTION = "pemberkatan";

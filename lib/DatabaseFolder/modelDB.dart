import 'package:mongo_dart/mongo_dart.dart';

//Kelas model collection database
class modelDB {
  //Model disesuaikan dengan nama, tipe data,
  // dan key pada collection di GerejaDB//////
  static user(
      String nama,
      String email,
      String password,
      String picture,
      int banned,
      bool notifGD,
      DateTime tanggalDaftar,
      String paroki,
      String alamat,
      String lingkungan,
      String notelp,
      String token,
      DateTime updatedAt) {
    var model = {
      "nama": nama,
      "email": email,
      "password": password,
      "picture": picture,
      "banned": banned,
      "notifGD": notifGD,
      "tanggalDaftar": tanggalDaftar,
      "paroki": paroki,
      "alamat": alamat,
      "lingkungan": lingkungan,
      "notelp": notelp,
      "token": token,
      "updatedAt": updatedAt
    };
    return model;
  }

  static imam(
    String email,
    String password,
    ObjectId idGereja,
    String nama,
    String picture,
    String notelp,
    int banned,
    int role,
    int statusPemberkatan,
    int statusPerminyakan,
    int statusTobat,
    int statusPerkawinan,
    DateTime createdAt,
    DateTime updatedAt,
    ObjectId updatedBy,
    ObjectId createdBy,
  ) {
    var model = {
      "email": email,
      "password": password,
      "idGereja": idGereja,
      "nama": nama,
      "picture": picture,
      "notelp": notelp,
      "banned": banned,
      "role": role,
      "statusPemberkatan": statusPemberkatan,
      "statusPerminyakan": statusPerminyakan,
      "statusTobat": statusTobat,
      "statusPerkawinan": statusPerkawinan,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdBy": createdBy,
    };
    return model;
  }

  static Gereja(
      String nama,
      String address,
      String paroki,
      String lingkungan,
      String deskripsi,
      double lat,
      double lng,
      int banned,
      String gambar,
      DateTime createdAt,
      ObjectId createdBy,
      DateTime updatedAt,
      ObjectId updatedBy) {
    var model = {
      "nama": nama,
      "address": address,
      "paroki": paroki,
      "lingkungan": lingkungan,
      "deskripsi": deskripsi,
      "lat": lat,
      "lng": lng,
      "banned": banned,
      "gambar": gambar,
      "createdAt": createdAt,
      "createdBy": createdBy,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy
    };
    return model;
  }

  static baptis(
    ObjectId idGereja,
    String jenis,
    int status,
    int kapasitas,
    DateTime jadwalBuka,
    DateTime jadwalTutup,
    DateTime updatedAt,
    ObjectId updatedBy,
    DateTime createdAt,
    ObjectId createdBy,
  ) {
    var model = {
      "idGereja": idGereja,
      "jenis": jenis,
      "status": status,
      "kapasitas": kapasitas,
      "jadwalBuka": jadwalBuka,
      "jadwalTutup": jadwalTutup,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdAt": createdAt,
      "createdBy": createdBy,
    };
    return model;
  }

  static krisma(
    ObjectId idGereja,
    String jenis,
    int status,
    int kapasitas,
    DateTime jadwalBuka,
    DateTime jadwalTutup,
    DateTime updatedAt,
    ObjectId updatedBy,
    DateTime createdAt,
    ObjectId createdBy,
  ) {
    var model = {
      "idGereja": idGereja,
      "jenis": jenis,
      "status": status,
      "kapasitas": kapasitas,
      "jadwalBuka": jadwalBuka,
      "jadwalTutup": jadwalTutup,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdAt": createdAt,
      "createdBy": createdBy,
    };
    return model;
  }

  static komuni(
    ObjectId idGereja,
    String jenis,
    int status,
    int kapasitas,
    DateTime jadwalBuka,
    DateTime jadwalTutup,
    DateTime updatedAt,
    ObjectId updatedBy,
    DateTime createdAt,
    ObjectId createdBy,
  ) {
    var model = {
      "idGereja": idGereja,
      "jenis": jenis,
      "status": status,
      "kapasitas": kapasitas,
      "jadwalBuka": jadwalBuka,
      "jadwalTutup": jadwalTutup,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdAt": createdAt,
      "createdBy": createdBy,
    };
    return model;
  }

  static umum(
    ObjectId idGereja,
    String namaKegiatan,
    String temaKegiatan,
    String jenisKegiatan,
    String deskripsiKegiatan,
    String tamu,
    DateTime tanggal,
    int kapasitas,
    String lokasi,
    String picture,
    int status,
    DateTime createdAt,
    ObjectId createdBy,
    DateTime updatedAt,
    ObjectId updatedBy,
  ) {
    var model = {
      "idGereja": idGereja,
      "namaKegiatan": namaKegiatan,
      "temaKegiatan": temaKegiatan,
      "deskripsiKegiatan": deskripsiKegiatan,
      "tamu": tamu,
      "kapasitas": kapasitas,
      "tanggal": tanggal,
      "lokasi": lokasi,
      "jenisKegiatan": jenisKegiatan,
      "picture": picture,
      "status": status,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdAt": createdAt,
      "createdBy": createdBy,
    };
    return model;
  }

  static userKomuni(
    ObjectId idKomuni,
    ObjectId idUser,
    DateTime tanggalDaftar,
    int status,
    DateTime updatedAt,
    ObjectId updatedBy,
  ) {
    var model = {
      "idKomuni": idKomuni,
      "idUser": idUser,
      "status": status,
      "tanggalDaftar": tanggalDaftar,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
    };
    return model;
  }

  static userBaptis(
    ObjectId idBaptis,
    ObjectId idUser,
    DateTime tanggalDaftar,
    int status,
    DateTime updatedAt,
    ObjectId updatedBy,
  ) {
    var model = {
      "idBaptis": idBaptis,
      "idUser": idUser,
      "status": status,
      "tanggalDaftar": tanggalDaftar,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
    };
    return model;
  }

  static userUmum(
    ObjectId idKegiatan,
    ObjectId idUser,
    DateTime tanggalDaftar,
    int status,
    DateTime updatedAt,
    ObjectId updatedBy,
  ) {
    var model = {
      "idKrisma": idKegiatan,
      "idUser": idUser,
      "status": status,
      "tanggalDaftar": tanggalDaftar,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
    };
    return model;
  }

  static userKrisma(
    ObjectId idKrisma,
    ObjectId idUser,
    DateTime tanggalDaftar,
    int status,
    DateTime updatedAt,
    ObjectId updatedBy,
  ) {
    var model = {
      "idKrisma": idKrisma,
      "idUser": idUser,
      "status": status,
      "tanggalDaftar": tanggalDaftar,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
    };
    return model;
  }

  static pemberkatan(
    ObjectId idUser,
    ObjectId idGereja,
    ObjectId idImam,
    String namaLengkap,
    String paroki,
    String lingkungan,
    String notelp,
    String alamat,
    String jenis,
    DateTime tanggal,
    String note,
    int status,
    DateTime updatedAt,
    ObjectId updatedBy,
    DateTime createdAt,
  ) {
    var model = {
      "idUser": idUser,
      "idGereja": idGereja,
      "idImam": idImam,
      "namaLengkap": namaLengkap,
      "paroki": paroki,
      "lingkungan": lingkungan,
      "notelp": notelp,
      "alamat": alamat,
      "jenis": jenis,
      "tanggal": tanggal,
      "note": note,
      "status": status,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdAt": createdAt,
    };
    return model;
  }

  static perkawinan(
    ObjectId idUser,
    ObjectId idGereja,
    ObjectId idImam,
    String namaPria,
    String namaPerempuan,
    String notelp,
    String alamat,
    String email,
    DateTime tanggal,
    String note,
    int status,
    DateTime updatedAt,
    ObjectId updatedBy,
    DateTime createdAt,
  ) {
    var model = {
      "idUser": idUser,
      "idGereja": idGereja,
      "idImam": idImam,
      "namaPria": namaPria,
      "namaPerempuan": namaPerempuan,
      "alamat": alamat,
      "notelp": notelp,
      "email": email,
      "tanggal": tanggal,
      "note": note,
      "status": status,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdAt": createdAt,
    };
    return model;
  }

  static gambarGereja(
    ObjectId idGereja,
    String gambar,
    String caption,
    int status,
    String title,
    DateTime createdAt,
    ObjectId createdBy,
    DateTime updatedAt,
    ObjectId updatedBy,
  ) {
    var model = {
      'idGereja': idGereja,
      'gambar': gambar,
      'caption': caption,
      'status': status,
      'title': title,
      "createdAt": createdAt,
      "createdBy": createdBy,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
    };
    return model;
  }

  static aturanPelayanan(
    ObjectId idGereja,
    String baptis,
    String komuni,
    String krisma,
    String perkawinan,
    String perminyakan,
    String tobat,
    String pemberkatan,
    DateTime updatedAt,
    ObjectId updatedBy,
    DateTime createdAt,
    ObjectId createdBy,
  ) {
    var model = {
      "idGereja": idGereja,
      "baptis": baptis,
      "komuni": komuni,
      "krisma": krisma,
      "perkawinan": perkawinan,
      "perminyakan": perminyakan,
      "tobat": tobat,
      "pemberkatan": pemberkatan,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
      "createdAt": createdAt,
      "createdBy": createdBy,
    };
    return model;
  }

  static admin(String user, String password) {
    var model = {
      "user": user,
      "password": password,
    };
    return model;
  }

//////KHUSUS PELAYANAN IMAM KATOLIK
  static userPelayanan(
    String id,
    ObjectId idPelayanan,
    ObjectId idUser,
    DateTime tanggalDaftar,
    int status,
    DateTime updatedAt,
    ObjectId updatedBy,
  ) {
    var model = {
      id: idPelayanan,
      "idUser": idUser,
      "status": status,
      "tanggalDaftar": tanggalDaftar,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy,
    };
    return model;
  }
}

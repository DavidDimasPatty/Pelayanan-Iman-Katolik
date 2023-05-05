class Goals {
  //Merepresentasikan tujuan tindakan/ pengerjaan agen
  String request; //Tindakan yang dilakukan agen
  Type goals; //Tujuan tipe data hasil pengerjaan
  int? time; //Tujuan batas waktu pengerjaan

  //Konstruktor
  Goals(this.request, this.goals, this.time);
}

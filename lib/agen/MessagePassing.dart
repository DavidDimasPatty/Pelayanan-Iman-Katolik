import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/agen/agenAkun.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/agenPencarian.dart';
import 'package:pelayanan_iman_katolik/agen/agenPendaftaran.dart';
import 'package:pelayanan_iman_katolik/agen/agenSetting.dart';

import 'Agent.dart';

class MessagePassing {
  //Kelas distributor pengiriman pesan antara agen
  //
  //Kumpulan agen yang dibuat pada sistem
  Map<String, Agent> agents = {'Agent Pencarian': AgentPencarian(), 'Agent Pendaftaran': AgentPendaftaran(), 'Agent Setting': AgentSetting(), 'Agent Akun': AgentAkun(), 'Agent Page': AgentPage()};

  ///
  Future<dynamic> sendMessage(Messages message) async {
    //Fungsi pengiriman pesan dari agen pengirim kepada agen penerima
    if (agents.containsKey(message.receiver)) {
      //Jika agen penerima terdaftar pada map agents
      Agent? agent = agents[message.receiver];
      if (agent!.canPerformTask(message) == 1) {
        //jika agen bisa melakukan tugas yang berada dalam pesan yang dikirim
        //oleh agen pengirim, maka agen akan menerima pesan
        return await agent.receiveMessage(message, message.sender);
      } else if (agent.canPerformTask(message) == -1) {
        //jika agen tidak bisa melakukan tugas yang berada dalam pesan yang dikirim
        //oleh agen pengirim, maka agen akan menerima pesan
        Messages msg = agent.rejectTask(message, message.sender);
        return await sendMessage(msg);
      }
    } else {
      //Jika nama agen penerima tidak terdaftar dalam sistem
      print("Agen Not Found!");
      return null;
    }
  }
}

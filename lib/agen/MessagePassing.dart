import 'package:pelayanan_iman_katolik/agen/Message.dart';
import 'package:pelayanan_iman_katolik/agen/agenAkun.dart';
import 'package:pelayanan_iman_katolik/agen/agenPage.dart';
import 'package:pelayanan_iman_katolik/agen/agenPencarian.dart';
import 'package:pelayanan_iman_katolik/agen/agenPendaftaran.dart';
import 'package:pelayanan_iman_katolik/agen/agenSetting.dart';

import 'Agent.dart';

class MessagePassing {
  Map<String, Agent> agents = {
    'Agent Pencarian': AgentPencarian(),
    'Agent Pendaftaran': AgentPendaftaran(),
    'Agent Setting': AgentSetting(),
    'Agent Akun': AgentAkun(),
    'Agent Page': AgentPage()
  };

  Future<dynamic> sendMessage(Messages message) async {
    if (agents.containsKey(message.receiver)) {
      Agent? agent = agents[message.receiver];
      if (agent!.canPerformTask(message)) {
        return await agent.receiveMessage(message, message.sender);
      } else {
        agent.rejectTask(message.task, message.sender);
      }
      return null;
    }
  }
}

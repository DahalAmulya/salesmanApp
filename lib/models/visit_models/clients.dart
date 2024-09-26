import 'package:deskgoo/models/visit_models/visit_client_model.dart';

class Cllents {
  List<VisitClientModel> _clients = [];
  List<VisitClientModel> get clients => _clients;

  // clients.add
  void addClient() {
    _clients.add(
      VisitClientModel(
        clientName: 'Ram Sharma',
        clientPhoneNumber: '9812345678',
        clientEmail: 'ramsharma@gmail.com',
        clientAddress: 'biratnagar,mahendra chowk',
        clientWhatsApp: '9812345678',
        clientVisitedPerson: 'Rita Sharma',
        clientVisitedPersonRelation: 'Wife',
        visitDetails: [
          VisitDetails(
            visitedDate: '2024-09-26 05:29:32',
            note: 'Person was not a home. Please visit again',
            isFollowUp: true,
            newFollowUpdate: '2024-09-28',
          ),
        ],
      ),
    );
    // _clients.add(client);
  }

  void getClientsList() {
    print(_clients);
  }
}

import 'package:deskgoo/models/visit_models/visit_client_model.dart';

class ClientsList {
  static List<VisitClientModel> _clients = [];
  static List<VisitClientModel> get clients => _clients;

  // Add a new client to the list
  static void addClient(VisitClientModel client) {
    _clients.add(client);
    print('Client added: ${client.clientName}');
  }

  // Update a client's information by phone number
  static void updateClient(
      String clientPhoneNumber, VisitClientModel updatedClient) {
    for (int i = 0; i < _clients.length; i++) {
      if (_clients[i].clientPhoneNumber == clientPhoneNumber) {
        _clients[i] = updatedClient;
        print('Client updated: ${updatedClient.clientName}');
        return;
      }
    }
    print('Client not found.');
  }

  static void updateClientDetails(int index, VisitClientModel details) {
    try {
      String name = details.clientName.isEmpty
          ? _clients[index].clientName
          : details.clientName;
      String phoneNumber = details.clientPhoneNumber.isEmpty
          ? _clients[index].clientPhoneNumber
          : details.clientPhoneNumber;
      String address = details.clientAddress.isEmpty
          ? _clients[index].clientAddress
          : details.clientAddress;
      String email = details.clientEmail.isEmpty
          ? _clients[index].clientEmail
          : details.clientEmail;
      String whatsapp = details.clientWhatsApp.isEmpty
          ? _clients[index].clientWhatsApp
          : details.clientWhatsApp;
      List<VisitDetails>? visitDetails = _clients[index].visitDetails;
      VisitClientModel updatedClientDetails = VisitClientModel(
        clientName: name,
        clientPhoneNumber: phoneNumber,
        clientEmail: email,
        clientAddress: address,
        clientWhatsApp: whatsapp,
        visitDetails:
            visitDetails, // If visitDetails are null, it will throw an error here. Use a null-safe operator to avoid this error.
      );
      _clients[index] = updatedClientDetails;
    } catch (err) {
      print('err = $err');
    }
  }

  static void addVisitDetails(int index, VisitDetails details) {
    try {
      if (_clients[index].visitDetails == null) {
        print('${_clients[index].visitDetails}');
        VisitDetails followUpDetails = VisitDetails(
          visitCount: 1,
          visitedDate: details.visitedDate,
          note: details.note,
          isFollowUp: details.isFollowUp,
          newFollowUpdate: details.newFollowUpdate,
        );
        VisitClientModel visitClientModel = VisitClientModel(
          clientName: _clients[index].clientName,
          clientPhoneNumber: _clients[index].clientPhoneNumber,
          clientEmail: _clients[index].clientEmail,
          clientAddress: _clients[index].clientAddress,
          clientWhatsApp: _clients[index].clientWhatsApp,
          visitDetails: [followUpDetails],
        );
        // _clients[index].visitDetails?.add(followUpDetails);
        _clients[index] = visitClientModel;
      } else {
        int followUpCount = _clients[index].visitDetails!.last.visitCount! + 1;
        VisitDetails followUpDetails = VisitDetails(
          visitCount: followUpCount,
          visitedDate: details.visitedDate,
          note: details.note,
          isFollowUp: details.isFollowUp,
          newFollowUpdate: details.newFollowUpdate,
        );
        _clients[index].visitDetails?.add(followUpDetails);
      }
      print('Updated successfully.');
      print('${_clients[index].toMap()}');
    } catch (err) {
      print('err = $err');
    }
  }

  // Remove a client by phone number
  static void removeClient(String clientPhoneNumber) {
    _clients
        .removeWhere((client) => client.clientPhoneNumber == clientPhoneNumber);
    print('Client removed with phone number: $clientPhoneNumber');
  }

  // Print all clients and their visit details
  static void getClientsList() {
    for (VisitClientModel client in _clients) {
      print(client.toMap()); // Will print the client details as a map
      // }
      // for (int i = 0; i < _clients.length; i++) {
      //   print(_clients[i].toMap()); // Will print the client details as a map
      // print(_clients[i]); // Will print the client details as a map
    }
  }
}

// class ClientsList {
//   static List<VisitClientModel> _clients = [];
//   static List<VisitClientModel> get clients => _clients;

//   // clients.add
//   static void addClient() {
//     _clients.add(
//       VisitClientModel(
//         clientName: 'Ram Sharma',
//         clientPhoneNumber: '9812345678',
//         clientEmail: 'ramsharma@gmail.com',
//         clientAddress: 'biratnagar,mahendra chowk',
//         clientWhatsApp: '9812345678',
//         clientVisitedPerson: 'Rita Sharma',
//         clientVisitedPersonRelation: 'Wife',
//         visitDetails: [
//           VisitDetails(
//             visitCount: 1,
//             visitedDate: '2024-09-26 05:29:32',
//             note: 'Person was not a home. Please visit again',
//             isFollowUp: true,
//             newFollowUpdate: '2024-09-28',
//           ),
//         ],
//       ),
//     );
//     _clients.add(
//       VisitClientModel(
//         clientName: 'Shali kumar Jha',
//         clientPhoneNumber: '9823145678',
//         clientEmail: 'sahilkumarjha@gmail.com',
//         clientAddress: 'biratnagar,traffic chowk',
//         clientWhatsApp: '9823145678',
//         clientVisitedPerson: '',
//         clientVisitedPersonRelation: '',
//         visitDetails: [
//           VisitDetails(
//             visitCount: 2,
//             visitedDate: '2024-09-27 15:12:10',
//             note: 'Person was at home. Not interested in product',
//             isFollowUp: false,
//             newFollowUpdate: '',
//           ),
//         ],
//       ),
//     );
//     print('Client added');
//     // _clients.add(client);
//   }

//   static void getClientsList() {
//     for (int i = 0; i < _clients.length; i++) {
//       // Map<String, dynamic> values = _clients[i];
//       print(_clients[i]);
//     }
//   }
// }

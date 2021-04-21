import 'package:cloud_firestore/cloud_firestore.dart';

class Invitation {
  final String groupId;
  final String mailAddress;
  final String invitingUid;

  Invitation(this.groupId, this.mailAddress, this.invitingUid);

  Invitation.fromDoc(QueryDocumentSnapshot doc)
      : this.groupId = doc.data()['group-id'],
        this.mailAddress = doc.data()['mail-address'],
        this.invitingUid = doc.data()['inviting-uid'];

  Map<String, dynamic> toJson() => {
    'group-id': groupId,
    'mail-address': mailAddress,
    'inviting-uid': invitingUid
  };
}

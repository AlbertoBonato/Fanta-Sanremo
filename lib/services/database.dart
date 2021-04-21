import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanta_sanremo/models/event.dart';
import 'package:fanta_sanremo/models/gettone.dart';
import 'package:fanta_sanremo/models/group.dart';
import 'package:fanta_sanremo/models/invitation.dart';
import 'package:fanta_sanremo/models/question.dart';
import 'package:fanta_sanremo/utils/shared_helpers.dart';
import 'package:fanta_sanremo/models/user.dart' as u;
import 'package:fanta_sanremo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

final INVITATIONS_COLLECTION_KEY = 'invitations';
final USERS_COLLECTION_KEY = 'users';
final GROUPS_COLLECTION_KEY = 'groups';
final EVENTS_COLLECTION_KEY = 'events';
final QUESTIONS_COLLECTION_KEY = 'questions2';
final GETTONI_COLLECTION_KEY = 'gettoni';

final CollectionReference userCollection =
    FirebaseFirestore.instance.collection(USERS_COLLECTION_KEY);

CollectionReference groupCollection =
    FirebaseFirestore.instance.collection(GROUPS_COLLECTION_KEY);

CollectionReference questionsCollection =
    FirebaseFirestore.instance.collection(QUESTIONS_COLLECTION_KEY);

CollectionReference gettoniCollection =
    FirebaseFirestore.instance.collection(GETTONI_COLLECTION_KEY);

Future<void> addInvitations(List<String> emailAddresses) async {
  String groupId = await getGroupId();
  CollectionReference invitations =
      FirebaseFirestore.instance.collection(INVITATIONS_COLLECTION_KEY);
  String myUid = FirebaseAuth.instance.currentUser.uid;
  emailAddresses.map((e) => Invitation(groupId, e, myUid)).forEach((inv) {
    invitations.add(inv.toJson()).catchError((error) =>
        print("Failed to add ${inv.mailAddress} to invites: $error"));
  });
}

Future<QuerySnapshot> getMyInvitations() async {
  String userEmail = await getEmail();
  CollectionReference invitationsCollection =
      FirebaseFirestore.instance.collection(INVITATIONS_COLLECTION_KEY);
  Future<QuerySnapshot> myInvitations =
      invitationsCollection.where('mail-address', isEqualTo: userEmail).get();
  return myInvitations;
}

Future<QuerySnapshot> getGroups(List<String> groupIds) {
  return groupCollection
      .where(FieldPath.documentId, whereIn: groupIds.toSet().toList())
      .get();
}

Future<bool> joinGroup(Group group) async {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  String myDisplayName = await getDisplayName();
  try {
    group.membersUid.add(myUid);
    await groupCollection
        .doc(group.id)
        .update({'members-uid': FieldValue.arrayUnion(group.membersUid)});
    QuerySnapshot userSnapshot =
        await userCollection.where('firebase-uid', isEqualTo: myUid).get();
    bool isUserAlreadyDefined =
        userSnapshot.docs != null && userSnapshot.docs.length > 0;
    if (isUserAlreadyDefined) {
      await userCollection
          .doc(userSnapshot.docs.first.reference.id)
          .update({'group-id': group.id});
      return true;
    } else {
      u.User newUser = u.User(null, group.id, myUid, myDisplayName, null);
      await userCollection
          .add(newUser.toJsonNoId())
          .catchError((err) => print('errore creazione utente $myUid'));
    }
  } catch (err) {
    print("Failed to update group: $err");
    return false;
  }
}

Future<bool> leaveGroup() async {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  String groupId = await getGroupId();
  try {
    QuerySnapshot userSnapshot =
        await userCollection.where('firebase-uid', isEqualTo: myUid).get();
    if (userSnapshot.docs.length == 1) {
      u.User user = u.User.fromQueryDoc(userSnapshot.docs[0]);
      user.groupId = null;
      try {
        await userCollection.doc(user.id).update({'group-id': null});
      } catch (err) {
        print("Failed to cancel groupId in user $myUid: $err");
        return false;
      }
      try {
        await groupCollection.doc(groupId).update({
          'members-uid': FieldValue.arrayRemove([myUid])
        });
        await saveGroupId(null);
        return true;
      } catch (err) {
        print("Failed to cancel user $myUid in groupid: $err");
        return false;
      }
    } else {
      print('Internal error, duplicated users $myUid');
      return false;
    }
  } catch (err) {
    print("Failed to update group: $err");
    return false;
  }
}

Future<String> getGroupName() async {
  return Group.fromDoc(await groupCollection.doc(await getGroupId()).get())
      .name;
}

Future<List<String>> getGroupMemberNames() async {
  QuerySnapshot users = await userCollection
      .where('group-id', isEqualTo: await getGroupId())
      .get();
  return users.docs.map((e) => u.User.fromDoc(e).name).toList();
}

Future<String> getMyGroupSize() async {
  return Group.fromDoc(await groupCollection.doc(await getGroupId()).get())
      .membersUid
      .length
      .toString();
}

Future<u.UserGettone> setUserGettone(String gettoneName) async {
  QuerySnapshot myUser = await userCollection
      .where('firebase-uid',
        isEqualTo: FirebaseAuth.instance.currentUser.uid)
      .get();
  u.UserGettone gettoneSelected = u.UserGettone.createWithDate(gettoneName,
      DateTime.now());
  if (myUser.size == 1) {
    try {
      await userCollection
          .doc(myUser.docs[0].id)
          .update({'gettone': gettoneSelected
          .toJson()});
      return gettoneSelected;
    } catch (error) {
      print("Failed to update user: $error");
      return u.UserGettone.noValue();
    }
  } else {
    print('ERRORE: Più di un user con stesso firebase-uid');
    return u.UserGettone.noValue();
  }
}

Future<String> getMyBet() async {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  QuerySnapshot querySnapshot =
      await userCollection.where('firebase-uid', isEqualTo: myUid).get();
  return querySnapshot?.docs[0]?.data()['bet'] ?? '';
}

Future<DocumentReference> addGettoneEvent(
    Gettone gettone, DateTime eventTime) async {
  CollectionReference events =
      FirebaseFirestore.instance.collection(EVENTS_COLLECTION_KEY);
  Event gettoneEvent = Event(
      insertDate: eventTime,
      type: GETTONE_EVENT_TYPE,
      key: gettone.name,
      points: gettone.points);
  try {
    return await events.add(gettoneEvent.toJsonNoId());
  } catch (error) {
    print("Failed to add gettone event ${gettone.name} : $error");
    return null;
  }
}

Future<void> showQuestion(Question question) async {
  QuerySnapshot questionToUpdate =
      await questionsCollection.where('index', isEqualTo: question.index).get();
  questionsCollection
      .doc(questionToUpdate.docs[0].id)
      .update({'visible': true});
}

void updateUsersPoints(
    Gettone gettone, String eventId, DateTime eventTime) async {
  int pointsToAdd = gettone.points;
  WriteBatch batch = FirebaseFirestore.instance.batch();
  // leggo gli user con gettone uguale a quello inserito
  // e data inserimento antecedente di al massimo 15 min
  QuerySnapshot scoringUsers = await userCollection
      .where(FieldPath(['gettone', 'name']), isEqualTo: gettone.name)
      .where(FieldPath(['gettone', 'selection-date']),
          isGreaterThanOrEqualTo: eventTime.subtract(gettoneExpiration))
      .where(FieldPath(['gettone', 'selection-date']), isLessThan: eventTime)
      .get();
  scoringUsers?.docs?.forEach((el) {
    batch.update(
        el.reference, {'points.total': FieldValue.increment(pointsToAdd)});
    batch.update(el.reference, {
      'points.event-ids': FieldValue.arrayUnion([eventId])
    });
  });
  batch.commit();
}

Future<String> readMyPoints() async {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  QuerySnapshot querySnapshot =
      await userCollection.where('firebase-uid', isEqualTo: myUid).get();
  u.UserPoints up =
      u.UserPoints.fromJson(querySnapshot.docs[0].data()['points']);
  return up.total.toString();
}

Future<List<u.User>> getRank() async {
  String myGroupId = await getGroupId();
  QuerySnapshot querySnapshot = await userCollection
      .where('group-id', isEqualTo: myGroupId)
      .orderBy('points.total')
      .get();
  List<u.User> rank = List.from(
      querySnapshot.docs.map((e) => u.User.fromQueryDoc(e)).toList());
  rank.sort((a, b) => b.points.total.compareTo(a.points.total));
  return rank;
}

Future<List<Question>> getQuestions() async {
  QuerySnapshot querySnapshot = await questionsCollection.get();
  List<Question> questions =
      List.from(querySnapshot.docs.map((e) => Question.fromDoc(e)).toList());
  questions.sort((a, b) => a.index.compareTo(b.index));
  return questions;
}

Future<List<Gettone>> getGettoni() async {
  QuerySnapshot querySnapshot = await gettoniCollection.get();
  List<Gettone> gettoni =
    List.from(querySnapshot.docs.map((e) => Gettone.fromDoc(e)).toList());
  return gettoni;
}

Future<DocumentReference> addQuestionEvent(int questionIndex, bool guessed) async {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  CollectionReference events =
      FirebaseFirestore.instance.collection(EVENTS_COLLECTION_KEY);
  Event questionEvent = Event(
      insertDate: DateTime.now(),
      type: QUESTION_EVENT_TYPE,
      key: '$questionIndex-$myUid',
      points: guessed ? questionPoints : 0);
  try {
    return await events.add(questionEvent.toJsonNoId());
  } catch (error) {
    print("Failed to add question event $questionIndex : $error");
    return null;
  }
}

Future<bool> updatePointsAfterQuestion(String eventId) async {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  QuerySnapshot querySnapshot =
      await userCollection.where('firebase-uid', isEqualTo: myUid).get();
  querySnapshot?.docs[0]?.reference?.update({
    'points.total': FieldValue.increment(questionPoints),
    'points.event-ids': FieldValue.arrayUnion([eventId])
  });
  return (querySnapshot?.docs[0] != null && querySnapshot.size > 0);
}

Future<bool> addBet(String competitor) async {
  String myUid = FirebaseAuth.instance.currentUser.uid;
  QuerySnapshot querySnapshot =
      await userCollection.where('firebase-uid', isEqualTo: myUid).get();
  querySnapshot?.docs[0]?.reference?.update({'bet': competitor});
  return (querySnapshot?.docs[0] != null && querySnapshot.size > 0);
}

Future<bool> createGroup(String groupName) async {
  User user = FirebaseAuth.instance.currentUser;
  try {
    DocumentReference newGroup = await groupCollection.add({
      'name': groupName,
      'members-uid': [user.uid]
    });
    QuerySnapshot userSnapshot =
        await userCollection.where('firebase-uid', isEqualTo: user.uid).get();
    bool isUserAlreadyDefined = userSnapshot.docs.length > 0;
    if (userSnapshot.docs.length > 1) {
      print('Errore interno, utente ${user.uid} duplicato');
    }
    if (isUserAlreadyDefined) {
      userSnapshot.docs.forEach((elem) {
        userCollection.doc(elem.id).update({'group-id': newGroup.id});
      });
    } else {
      u.User newUser =
          u.User(null, newGroup.id, user.uid, user.displayName, null);
      await userCollection
          .add(newUser.toJsonNoId())
          .catchError((err) => print('errore creazione utente ${user.uid}'));
    }
    return await saveGroupId(newGroup.id) &&
        await saveDisplayName(user.displayName);
  } catch (err) {
    print("Failed to add group: $err");
    return false;
  }
}

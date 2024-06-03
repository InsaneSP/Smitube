import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleSubscription(String channelId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('You must be logged in to subscribe.');
    }

    final userSubscriptionsRef = _firestore.collection('subscriptions').doc(currentUser.uid);
    final channelRef = _firestore.collection('channels').doc(channelId);

    await _firestore.runTransaction((transaction) async {
      final userSubscriptionsSnapshot = await transaction.get(userSubscriptionsRef);
      final channelSnapshot = await transaction.get(channelRef);

      if (!channelSnapshot.exists) {
        throw Exception('Channel does not exist.');
      }

      if (!userSubscriptionsSnapshot.exists) {
        // User has no subscriptions, create a new document
        transaction.set(userSubscriptionsRef, {
          'channelIds': [channelId],
        });
        transaction.update(channelRef, {
          'subscribers': FieldValue.increment(1),
        });
      } else {
        final userSubscriptions = userSubscriptionsSnapshot.data() as Map<String, dynamic>;
        final channelIds = List<String>.from(userSubscriptions['channelIds']);

        if (channelIds.contains(channelId)) {
          // User is already subscribed, unsubscribe
          channelIds.remove(channelId);
          transaction.update(channelRef, {
            'subscribers': FieldValue.increment(-1),
          });
        } else {
          // User is not subscribed, subscribe
          channelIds.add(channelId);
          transaction.update(channelRef, {
            'subscribers': FieldValue.increment(1),
          });
        }

        transaction.update(userSubscriptionsRef, {
          'channelIds': channelIds,
        });
      }
    });
  }

  Future<bool> isSubscribed(String channelId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return false;
    }

    final userSubscriptionsRef = _firestore.collection('subscriptions').doc(currentUser.uid);
    final userSubscriptionsSnapshot = await userSubscriptionsRef.get();

    if (!userSubscriptionsSnapshot.exists) {
      return false;
    }

    final userSubscriptions = userSubscriptionsSnapshot.data() as Map<String, dynamic>;
    final channelIds = List<String>.from(userSubscriptions['channelIds']);

    return channelIds.contains(channelId);
  }
}

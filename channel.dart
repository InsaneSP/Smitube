import 'package:flutter/material.dart';
import 'subscription_service.dart';

class ChannelPage extends StatefulWidget {
  final String channelId;
  final String channelName;
  final String channelImage;
  final int subscribers;

  const ChannelPage({
    Key? key,
    required this.channelId,
    required this.channelName,
    required this.channelImage,
    required this.subscribers,
  }) : super(key: key);

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  late bool isSubscribed;

  @override
  void initState() {
    super.initState();
    checkSubscriptionStatus();
  }

  Future<void> checkSubscriptionStatus() async {
    isSubscribed = await _subscriptionService.isSubscribed(widget.channelId);
    setState(() {});
  }

  void toggleSubscription() async {
    await _subscriptionService.toggleSubscription(widget.channelId);
    checkSubscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
        actions: [
          IconButton(
            icon: Icon(isSubscribed ? Icons.subscriptions : Icons.subscriptions_outlined),
            onPressed: toggleSubscription,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(widget.channelImage),
            Text(widget.channelName),
            Text('${widget.subscribers} subscribers'),
            ElevatedButton(
              onPressed: toggleSubscription,
              child: Text(isSubscribed ? 'Unsubscribe' : 'Subscribe'),
            ),
          ],
        ),
      ),
    );
  }
}

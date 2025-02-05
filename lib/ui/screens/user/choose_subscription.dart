import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podlove_flutter/providers/purchase_providers.dart';
import 'package:podlove_flutter/providers/subscriptionProvider.dart';
import 'package:podlove_flutter/routes/route_path.dart';
import 'package:podlove_flutter/ui/widgets/custom_app_bar.dart';
import 'package:podlove_flutter/ui/widgets/subscription_card.dart';
import 'package:podlove_flutter/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseSubscription extends ConsumerStatefulWidget {
  const ChooseSubscription({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseSubscriptionState();
}

class _ChooseSubscriptionState extends ConsumerState<ChooseSubscription> {
  @override
  void initState() {
    super.initState();
    ref.read(subscriptionProvider.notifier).fetchSubscriptionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: "Subscription Plan"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w)
              .copyWith(top: 20.h, bottom: 44.h),
          child: Consumer(
            builder: (context, ref, child) {
              final asyncSubscriptions = ref.watch(subscriptionProvider);
              return asyncSubscriptions.when(
                data: (subscriptions) {
                  final purchaseNotifier = ref.read(purchaseProvider.notifier);
                  return ListView.builder(
                    itemCount: subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = subscriptions[index];
                      final features = subscription.description!
                          .map((desc) => desc.key ?? '')
                          .take(3)
                          .toList();
                      final isCurrentPlan = index == 0;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.0.h),
                        child: SubscriptionCard(
                            width: 100,
                            title: subscription.name!.split(":")[0],
                            subtitle: subscription.name!.split(":")[1],
                            price: subscription.unitAmount == "0"
                                ? "Free / ${subscription.interval}"
                                : "${subscription.unitAmount!} / ${subscription.interval}",
                            features: features,
                            onPressed: isCurrentPlan
                                ? () {}
                                : () {
                                    () async {
                                      logger.i("tap");
                                      final url = await purchaseNotifier
                                          .purchase(subscription.id!);
                                      context.push(RouterPath.purchase,
                                          extra: url);
                                    }();
                                  },
                            isCurrentPlan: isCurrentPlan,
                            onViewDetails: () => showSubscriptionDetails(
                                  context,
                                  subscription.name!,
                                  subscription.unitAmount!,
                                  subscription.description!
                                      .map((desc) => {
                                            "key": desc.key ?? "",
                                            "details": desc.details ?? "",
                                          })
                                      .toList(),
                                )),
                      );
                    },
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (error, stackTrace) => Text('Error: $error'),
              );
            },
          ),
        ));
  }
}

void showSubscriptionDetails(
  BuildContext context,
  String title,
  String price,
  List<Map<String, String>> features,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button (top right corner)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.orange),
                ),
              ),

              // Title
              Center(
                child: Text(
                  "Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Subscription Name & Price
              Text(
                "$title ($price)",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // Description Title
              Text(
                "Everything in the Listener package, plus:",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 8),

              // Features List (Bold key + Normal details)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• ", style: TextStyle(fontSize: 16)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "${feature['key']}: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: feature['details'],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

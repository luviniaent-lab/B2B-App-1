import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/app_bottom_nav.dart';

class RatingsPage extends ConsumerWidget {
  const RatingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock ratings data - in real app this would come from backend
    final ratings = [
      {
        'customerName': 'Rahul Sharma',
        'rating': 5,
        'review': 'Excellent service! The venue was perfect for our wedding reception.',
        'date': '15/12/2024',
        'event': 'Wedding Reception',
        'verified': true,
      },
      {
        'customerName': 'Priya Patel',
        'rating': 4,
        'review': 'Great ambiance and food quality. Staff was very helpful.',
        'date': '10/12/2024',
        'event': 'Birthday Party',
        'verified': true,
      },
      {
        'customerName': 'Amit Kumar',
        'rating': 5,
        'review': 'Amazing experience! Will definitely book again.',
        'date': '05/12/2024',
        'event': 'Corporate Event',
        'verified': false,
      },
      {
        'customerName': 'Sneha Gupta',
        'rating': 3,
        'review': 'Good venue but could improve on timing coordination.',
        'date': '28/11/2024',
        'event': 'Anniversary',
        'verified': true,
      },
    ];

    // Calculate average rating
    final avgRating = ratings.fold<double>(0, (sum, r) => sum + (r['rating'] as int).toDouble()) / ratings.length;
    final totalReviews = ratings.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Ratings & Reviews')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Rating Overview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Overall Rating', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(avgRating.toStringAsFixed(1), 
                                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                       color: Theme.of(context).colorScheme.primary,
                                       fontWeight: FontWeight.bold,
                                     )),
                                const SizedBox(width: 8),
                                ...List.generate(5, (index) => Icon(
                                  index < avgRating.floor() ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                )),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Based on $totalReviews reviews', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.star,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Reviews List
          Text('Customer Reviews', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          if (ratings.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No reviews yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('Customer reviews will appear here', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            )
          else
            ...ratings.map((review) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                          child: Text(
                            (review['customerName'] as String).substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(review['customerName'] as String, style: const TextStyle(fontWeight: FontWeight.w600))),
                                  if (review['verified'] as bool)
                                    const Icon(Icons.verified, color: Colors.green, size: 16),
                                ],
                              ),
                              Row(
                                children: [
                                  ...List.generate(5, (index) => Icon(
                                    index < (review['rating'] as int) ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  )),
                                  const SizedBox(width: 8),
                                  Text(review['date'] as String, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(review['review'] as String),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        review['event'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 4),
    );
  }
}

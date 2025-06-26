import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/glassmorphic_card.dart';
import '../../widgets/trip/day_card.dart';
import '../../providers/trip_provider.dart';

class ItineraryViewScreen extends ConsumerStatefulWidget {
  final String tripId;

  const ItineraryViewScreen({
    Key? key,
    required this.tripId,
  }) : super(key: key);

  @override
  ConsumerState<ItineraryViewScreen> createState() => _ItineraryViewScreenState();
}

class _ItineraryViewScreenState extends ConsumerState<ItineraryViewScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load trip details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripProvider.notifier).loadTripById(widget.tripId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripProvider);
    final trip = tripState.currentTrip;

    if (tripState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (trip == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: const Center(
          child: Text('Trip not found'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            actions: [
              IconButton(
                onPressed: () => context.push('/chat/${trip.id}'),
                icon: const Icon(Icons.chat_bubble_outline),
              ),
              IconButton(
                onPressed: () => _showOptionsMenu(context),
                icon: const Icon(Icons.more_vert),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                trip.destination,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.secondaryPurple,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      Icons.location_on,
                      size: 60,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Trip Info Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GlassmorphicCard(
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppColors.primaryBlue,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${trip.duration} Days',
                                style: AppTextStyles.labelLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Duration',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassmorphicCard(
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.secondaryPurple,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                trip.budgetRange,
                                style: AppTextStyles.labelLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Budget',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlassmorphicCard(
                          child: Column(
                            children: [
                              Icon(
                                Icons.category,
                                color: AppColors.accentOrange,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                trip.tripType,
                                style: AppTextStyles.labelLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Type',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().slideInUp(delay: 100.ms),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primaryBlue,
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: Colors.grey[600],
                tabs: const [
                  Tab(text: 'Itinerary'),
                  Tab(text: 'Places'),
                  Tab(text: 'Tips'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildItineraryTab(trip),
                _buildPlacesTab(trip),
                _buildTipsTab(trip),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryTab(trip) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trip.itinerary?.days?.length ?? 0,
      itemBuilder: (context, index) {
        final day = trip.itinerary.days[index];
        return DayCard(
          day: day,
          dayNumber: index + 1,
        ).animate().slideInLeft(
          delay: Duration(milliseconds: index * 100),
        );
      },
    );
  }

  Widget _buildPlacesTab(trip) {
    final places = trip.itinerary?.recommendedPlaces ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return GlassmorphicCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: Icon(
                _getPlaceIcon(place.type),
                color: AppColors.primaryBlue,
              ),
            ),
            title: Text(
              place.name,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.description),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.accentOrange,
                    ),
                    Text(
                      ' ${place.rating}',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    Text(
                      ' ${place.distance}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                // Open location in maps
              },
              icon: const Icon(Icons.directions),
            ),
          ),
        ).animate().fadeInUp(
          delay: Duration(milliseconds: index * 50),
        );
      },
    );
  }

  Widget _buildTipsTab(trip) {
    final tips = trip.itinerary?.tips ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return GlassmorphicCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.accentOrange.withOpacity(0.1),
              child: Icon(
                _getTipIcon(tip.category),
                color: AppColors.accentOrange,
              ),
            ),
            title: Text(
              tip.title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(tip.description),
          ),
        ).animate().slideInRight(
          delay: Duration(milliseconds: index * 100),
        );
      },
    );
  }

  IconData _getPlaceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'hotel':
        return Icons.bed;
      case 'attraction':
        return Icons.attractions;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
        return Icons.directions_bus;
      default:
        return Icons.place;
    }
  }

  IconData _getTipIcon(String category) {
    switch (category.toLowerCase()) {
      case 'money':
        return Icons.attach_money;
      case 'weather':
        return Icons.wb_sunny;
      case 'culture':
        return Icons.people;
      case 'safety':
        return Icons.security;
      case 'transport':
        return Icons.directions;
      default:
        return Icons.lightbulb_outline;
    }
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Trip'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Itinerary'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export PDF'),
              onTap: () {
                Navigator.pop(context);
                // Handle export
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Trip', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: const Text('Are you sure you want to delete this trip? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(tripProvider.notifier).deleteTrip(widget.tripId);
              context.go('/home');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
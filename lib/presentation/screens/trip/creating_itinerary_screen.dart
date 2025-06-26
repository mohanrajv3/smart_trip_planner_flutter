import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/glassmorphic_card.dart';
import '../../providers/trip_provider.dart';
import '../../providers/ai_chat_provider.dart';

class CreatingItineraryScreen extends ConsumerStatefulWidget {
  const CreatingItineraryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatingItineraryScreen> createState() => _CreatingItineraryScreenState();
}

class _CreatingItineraryScreenState extends ConsumerState<CreatingItineraryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _durationController = TextEditingController();
  final _budgetController = TextEditingController();
  final _preferencesController = TextEditingController();

  DateTime? _startDate;
  String _selectedBudgetRange = 'Medium';
  String _selectedTripType = 'Leisure';

  final List<String> _budgetRanges = ['Budget', 'Medium', 'Luxury'];
  final List<String> _tripTypes = ['Leisure', 'Business', 'Adventure', 'Cultural', 'Romantic'];

  @override
  void dispose() {
    _destinationController.dispose();
    _durationController.dispose();
    _budgetController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Your Trip'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tell us about your dream trip',
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeInDown(),

                  const SizedBox(height: 8),

                  Text(
                    'Our AI will create a personalized itinerary for you',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.grey[600],
                    ),
                  ).animate().fadeInDown(delay: 100.ms),

                  const SizedBox(height: 32),

                  // Destination
                  CustomTextField(
                    controller: _destinationController,
                    label: 'Destination',
                    prefixIcon: Icons.location_on_outlined,
                    hint: 'e.g., Paris, France',
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a destination';
                      }
                      return null;
                    },
                  ).animate().slideInLeft(delay: 200.ms),

                  const SizedBox(height: 20),

                  // Date and Duration Row
                  Row(
                    children: [
                      Expanded(
                        child: GlassmorphicCard(
                          onTap: _selectStartDate,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: AppColors.primaryBlue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Start Date',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _startDate != null
                                      ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                      : 'Select date',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: _startDate != null ? Colors.black : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          controller: _durationController,
                          label: 'Duration (days)',
                          prefixIcon: Icons.access_time,
                          keyboardType: TextInputType.number,
                          hint: '7',
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter duration';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ).animate().slideInRight(delay: 300.ms),

                  const SizedBox(height: 20),

                  // Budget Range
                  Text(
                    'Budget Range',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _budgetRanges.map((range) {
                      final isSelected = _selectedBudgetRange == range;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedBudgetRange = range),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryBlue
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  range,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeInUp(delay: 400.ms),

                  const SizedBox(height: 20),

                  // Trip Type
                  Text(
                    'Trip Type',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _tripTypes.map((type) {
                      final isSelected = _selectedTripType == type;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTripType = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondaryPurple
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondaryPurple
                                  : Colors.grey[300]!,
                            ),
                          ),
                          child: Text(
                            type,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeInUp(delay: 500.ms),

                  const SizedBox(height: 20),

                  // Special Preferences
                  CustomTextField(
                    controller: _preferencesController,
                    label: 'Special Preferences (Optional)',
                    prefixIcon: Icons.favorite_outline,
                    hint: 'Food preferences, accessibility needs, etc.',
                    maxLines: 3,
                  ).animate().slideInUp(delay: 600.ms),

                  const SizedBox(height: 32),

                  // Create Itinerary Button
                  CustomButton(
                    text: 'Create My Itinerary',
                    onPressed: tripState.isLoading ? null : _handleCreateItinerary,
                    isLoading: tripState.isLoading,
                  ).animate().scale(delay: 700.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _startDate = date);
    }
  }

  void _handleCreateItinerary() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date')),
        );
        return;
      }

      final tripData = {
        'destination': _destinationController.text,
        'startDate': _startDate!.toIso8601String(),
        'duration': int.parse(_durationController.text),
        'budgetRange': _selectedBudgetRange,
        'tripType': _selectedTripType,
        'preferences': _preferencesController.text,
      };

      final success = await ref.read(tripProvider.notifier).createTrip(tripData);

      if (success && mounted) {
        // Navigate to the trip view screen
        final tripId = ref.read(tripProvider).currentTrip?.id;
        if (tripId != null) {
          context.go('/trip/$tripId');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create itinerary. Please try again.')),
        );
      }
    }
  }
}
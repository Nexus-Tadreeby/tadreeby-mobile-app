import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'package:tadreeby/features/admin/data/models/university_model.dart';
import 'package:tadreeby/features/admin/presentation/widgets/Admin_bottom_nav_bar.dart';
import '../cubits/university_cubit.dart';
import '../cubits/university_state.dart';
import '../widgets/university_card.dart';
import '../widgets/university_filter_chip.dart';

class UniversitiesListScreen extends StatefulWidget {
  const UniversitiesListScreen({super.key});

  @override
  State<UniversitiesListScreen> createState() => _UniversitiesListScreenState();
}

class _UniversitiesListScreenState extends State<UniversitiesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'All';
  bool? _isActiveFilter;

  // // Stats
  // int _totalCount = 0;
  // int _activeCount = 0;
  // int _inactiveCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUniversities();
    });
  }

  void _loadUniversities() {
    context.read<UniversityCubit>().getUniversities(
          limit: 20,
          search: _searchController.text.isNotEmpty ? _searchController.text : null,
          isActive: _isActiveFilter,
          // sortBy: 'name',
          // sortOrder: 'asc',
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 
    backgroundColor: Colors.white,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        padding: const EdgeInsets.only(top: 8.0), 
        color: Colors.white,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Universities',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage all universities',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            _buildBadgeIconWithImage(
              imagePath: 'assets/icons/notification.png',
              count: 3,
              onTap: () {
                // TODO: Show notifications
              },
            ),
            const SizedBox(width: 4),
            _buildBadgeIconWithImage(
              imagePath: 'assets/icons/chat.png',
              count: 5,
              onTap: () {
                // TODO: Show chat
              },
            ),
            const SizedBox(width: 12), 
          ],
        ),
      ),
    ),
      body: Column(
        children: [
           Container(
      height: 1,
      color: Colors.grey.shade200.withOpacity(0.5), 
    ),


         // ─── Search Bar with Filter Icon ──────────────────────
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Row(
    children: [
      // ─── Search Field ──────────────────────────────
      Expanded(
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search universities...',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade500,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey.shade500,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _loadUniversities();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 4,
              ),
              isDense: true,
            ),
            onChanged: (_) => _loadUniversities(),
          ),
        ),
      ),
      const SizedBox(width: 12),

      // ─── Filter Icon with Orange Background ──────
      Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.backgroundOrange,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFFD699), // ✅ برتقالي أغمق للبوردر
            width: 1.5,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/filter.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.tune,
              color: AppColors.primaryOrange,
              size: 24,
            ),
          ),
        ),
      ),
    ],
  ),
),

// في universities_list_screen.dart

// ─── Filter Chips ────────────────────────────────────
BlocBuilder<UniversityCubit, UniversityState>(
  builder: (context, state) {
        int totalCount = 0;
    int activeCount = 0;
    int inactiveCount = 0;

   if (state is UniversitiesLoaded) {
        totalCount = state.totalCount;
      activeCount = state.activeCount;
      inactiveCount = state.inactiveCount;
       }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          UniversityFilterChip(
            label: 'All ($totalCount)',
            isSelected: _currentFilter == 'All',
            onSelected: () {
              setState(() {
                _currentFilter = 'All';
                _isActiveFilter = null;
              });
              _loadUniversities();
            },
          ),
          const SizedBox(width: 8),
          
          UniversityFilterChip(
            label: 'Active ($activeCount)',
            isSelected: _currentFilter == 'Active',
            onSelected: () {
              setState(() {
                _currentFilter = 'Active';
                _isActiveFilter = true;
              });
              _loadUniversities();
            },
          ),
          const SizedBox(width: 8),
          
          UniversityFilterChip(
            label: 'Inactive ($inactiveCount)',
            isSelected: _currentFilter == 'Inactive',
            onSelected: () {
              setState(() {
                _currentFilter = 'Inactive';
                _isActiveFilter = false;
              });
              _loadUniversities();
            },
          ),
        
        ],
      ),
    );
  },
),

          // ─── Universities List ──────────────────────────────
          Expanded(
            child: BlocConsumer<UniversityCubit, UniversityState>(
              listener: (context, state) {
                if (state is UniversityActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state is UniversityError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is UniversityLoading && state is! UniversitiesLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is UniversitiesLoaded) {
                  List<UniversityModel> filteredUniversities = state.universities;

                  if (_isActiveFilter != null) {
                    filteredUniversities = filteredUniversities
                        .where((u) => u.isActive == _isActiveFilter)
                        .toList();
                  }

                  if (filteredUniversities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: AppColors.textGrey.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'No universities found matching "${_searchController.text}"'
                                : 'No universities found',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'Try adjusting your search'
                                : 'Tap + to create your first university',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredUniversities.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredUniversities.length) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          context.read<UniversityCubit>().loadMoreUniversities();
                        });
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final university = filteredUniversities[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: UniversityCard(
                          university: university,
                          onTap: () {
                            context.push('/admin/universities/${university.id}');
                          },
                          onEdit: () {
                            // TODO: Navigate to edit screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Edit feature coming soon!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          onToggleStatus: () {
                            if (university.isActive) {
                              context.read<UniversityCubit>().deactivateUniversity(university.id);
                            } else {
                              context.read<UniversityCubit>().activateUniversity(university.id);
                            }
                          },
                          onDelete: () {
                            _showDeleteDialog(context, university);
                          },
                        ),
                      );
                    },
                  );
                }

                if (state is UniversityError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUniversities,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
   // ─── FloatingActionButton ──────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/universities/create'),
        backgroundColor: AppColors.primaryBlue,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ─── Bottom Navigation Bar ──────────────────────────────
      bottomNavigationBar: const AdminBottomNavBar(
        currentIndex: 1, // Universities is index 1
      ),
    );
    
  }

  // ─── Badge Icon Button ──────────────────────────────────────
  Widget _buildBadgeIcon({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, color: AppColors.textDark, size: 26),
          onPressed: onTap,
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ─── Delete Dialog ──────────────────────────────────────────
  void _showDeleteDialog(BuildContext context, UniversityModel university) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete University'),
        content: Text(
          'Are you sure you want to delete "${university.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UniversityCubit>().deleteUniversity(university.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIconWithImage({
  required String imagePath,
  required int count,
  required VoidCallback onTap,
  Color backgroundColor = AppColors.uploadBg,
  double size = 40,
  double iconSize = 22,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.circle_outlined,
                color: Colors.grey.shade400,
                size: iconSize,
              ),
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.white, width: 2),
                ),
              ),
              child: Center(
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
}

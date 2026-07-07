import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'package:tadreeby/features/admin/presentation/widgets/admin_bottom_nav_bar.dart';
import 'package:tadreeby/features/admin/presentation/widgets/pagination_widget.dart';
import '../cubits/users_cubit.dart';
import '../cubits/users_state.dart';
import '../widgets/user_card.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
   bool _isFirstLoad = true; 
  String? _roleFilter;
  bool? _isActiveFilter;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
      print('🔵 [initState] Loading users for first time');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }

  void _loadUsers({int? page}) {
      print('🟡 [_loadUsers] Called with page: $page');

    final cubit = context.read<UsersCubit>();
    
    if (page == null || page == 1) {
      cubit.getUsers(
        page: 1,
        limit: 20,
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        role: _roleFilter,
        isActive: _isActiveFilter,
      );
    } else {
      cubit.goToPage(page);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
                    'All Users',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manage all system users',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey.withOpacity(0.8),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey.shade200.withOpacity(0.5),
          ),

          // ─── Search Bar ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name, email or role...',
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
                                  _loadUsers(page: 1);
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
                      onChanged: (value) {
                        // ✅ تأخير البحث لتجنب الطلبات المتكررة
                        _debounceSearch();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundOrange,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD699),
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

          // ─── Total Users ──────────────────────────────────────
          BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              int total = 0;
              if (state is UsersLoaded) {
                total = state.total;
              }
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Total Users: ',
                          style: TextStyle(
                            color: Color.fromARGB(255, 134, 134, 134),
                          ),
                        ),
                        TextSpan(
                          text: '$total',
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ─── Headers ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'User',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Role',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
          ),

          // ─── Users List ──────────────────────────────────────
          Expanded(
            child: BlocConsumer<UsersCubit, UsersState>(
              listener: (context, state) {
                 if (state is UsersLoaded) {
      print('🟢 [BlocConsumer] Received UsersLoaded with ${state.users.length} users');
    }
                if (state is UsersError) {
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
                 print('🔵 [BlocBuilder] Current state: ${state.runtimeType}');
    if (state is UsersLoaded) {
      print('🟢 [BlocBuilder] Users count: ${state.users.length}');
    }
                if (state is UsersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  );
                }

                if (state is UsersLoaded) {
                    print('📊 [ListView] itemCount: ${state.users.length}');

                  if (state.users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.textGrey.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isNotEmpty
                                ? 'No users found matching "${_searchController.text}"'
                                : 'No users found',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // ─── List of Users ──────────────────────
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                                        print('📊 [ListView] Building item $index of ${state.users.length}');

                            final user = state.users[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: UserCard(
                                user: user,
                                onTap: () {
                                  // TODO: Navigate to user details
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // ─── Pagination ──────────────────────────
                      PaginationWidget(
                        currentPage: state.page,
                        totalPages: state.totalPages,
                        onPrevious: () {
                              print('⬅️ [Pagination] Previous page clicked');
                          context.read<UsersCubit>().previousPage();
                        },
                        onNext: () {
                              print('➡️ [Pagination] Next page clicked');
                          context.read<UsersCubit>().nextPage();
                        },
                        onPageSelected: (page) {
                              print('📄 [Pagination] Page $page selected');

                          context.read<UsersCubit>().goToPage(page);
                        },
                      ),
                    ],
                  );
                }

                if (state is UsersError) {
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
                          onPressed: () => _loadUsers(page: 1),
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
      bottomNavigationBar: const AdminBottomNavBar(
        currentIndex: 3,
      ),
    );
  }

  Timer? _debounceTimer;
  void _debounceSearch() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _loadUsers(page: 1);
    });
  }
}
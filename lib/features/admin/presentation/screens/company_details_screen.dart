import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tadreeby/core/theme/app_colors.dart';
import 'package:tadreeby/features/admin/data/models/company_model.dart';
import '../cubits/company_cubit.dart';
import '../cubits/company_state.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final int companyId;

  const CompanyDetailsScreen({
    super.key,
    required this.companyId,
  });

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  late CompanyModel _company;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyDetails();
  }

  void _loadCompanyDetails() {
    context.read<CompanyCubit>().getCompanyById(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Company Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'View company information',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<CompanyCubit, CompanyState>(
        listener: (context, state) {
          if (state is CompanyLoaded) {
            setState(() {
              _company = state.company;
              _isLoading = false;
            });
          } else if (state is CompanyError) {
            setState(() {
              _isLoading = false;
            });
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
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CompanyLoaded) {
            return _buildContent(context, state.company);
          }

          if (state is CompanyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCompanyDetails,
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CompanyModel company) {
    final isActive = company.isActive;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Card ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Logo ──────────────────────────────────────
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderGrey.withOpacity(0.6)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: company.logo != null && company.logo!.isNotEmpty
                      ? Image.network(
                          company.logo!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.business_outlined,
                            color: AppColors.primaryOrange,
                            size: 28,
                          ),
                        )
                      : const Icon(
                          Icons.business_outlined,
                          color: AppColors.primaryOrange,
                          size: 28,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                        Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(
    color: AppColors.primaryBlue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(6),
    border: Border.all(
      color: AppColors.primaryBlue, 
      width: 1.2,
    ),
  ),
  child: Text(
    company.shortCode,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    ),
  ),
),
                          if (company.location != null &&
                              company.location!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                company.location!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // ─── Status Badge ──────────────────────
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(0.12)
                          : Colors.orange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? Colors.green.withOpacity(0.4)
                            : Colors.orange.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── General Information ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info, color: AppColors.primaryOrange, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'General Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  label: 'Company Name',
                  value: company.name,
                ),
                _buildInfoRow(
                  label: 'Short Code',
                  value: company.shortCode,
                ),
                _buildInfoRow(
                  label: 'Email',
                  value: company.email ?? 'Not provided',
                ),
                _buildInfoRow(
                  label: 'Phone',
                  value: company.phone ?? 'Not provided',
                ),
                _buildInfoRow(
                  label: 'Location',
                  value: company.location ?? 'Not provided',
                ),
                _buildInfoRow(
                  label: 'Description',
                  value: company.description ?? 'No description provided',
                  isMultiLine: true,
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Statistics ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to full statistics screen
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBlue.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      ),
                      child: const Text(
                        'View More',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (company.count != null)
                  Row(
                    children: [
                      _buildStatCard(
                        label: 'Students',
                        value: company.count!.students,
                        color: Colors.blue,
                      ),
                      _buildStatCard(
                        label: 'Admins',
                        value: company.count!.users,
                        color: Colors.purple,
                      ),
                      _buildStatCard(
                        label: 'Trainers',
                        value: company.count!.trainers,
                        color: Colors.orange,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── System Information ──────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderGrey.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'System Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Navigate to add admin screen
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryBlue.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      ),
                      child: const Text(
                        'Add Admin',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ Created By
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSystemInfoRow(
                        icon: Icons.edit_outlined,
                        label: 'Created By',
                        value: _formatDate(company.createdAt),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPersonInfoRow(
                        name: company.createdAt ?? 'Not assigned',
                        role: 'Created By',
                      ),
                    ),
                  ],
                ),
                
                // ✅ Last Updated
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSystemInfoRow(
                        icon: Icons.autorenew_outlined,
                        label: 'Last Updated',
                        value: _formatDate(company.updatedAt),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPersonInfoRow(
                        name: company.updatedAt ?? 'Not assigned',
                        role: 'Last Updated By',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── Info Row ──────────────────────────────────────────────────
  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isMultiLine = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(top: 12),
             
            ),
        ],
      ),
    );
  }

  // ─── Stat Card ──────────────────────────────────────────────────
  Widget _buildStatCard({
    required String label,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ─── System Info Row ────────────────────────────────────────────
  Widget _buildSystemInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.orange, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Person Info Row ────────────────────────────────────────────
  Widget _buildPersonInfoRow({
    required String name,
    required String role,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.infoBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 18, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  role,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper Methods ─────────────────────────────────────────────
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Not available';
    }
    try {
      final date = DateTime.parse(dateString);
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '${date.day}/${date.month}/${date.year} at $hour:$minute';
    } catch (e) {
      return dateString;
    }
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}
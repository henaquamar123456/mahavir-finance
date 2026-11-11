import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahavir_finance/screens/admin_dasboard/patners/patners_details_screen.dart';

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../core/servicess/shared_pref_helper.dart';
import '../../../../utils/currency_formatter.dart';

class PartnerManagementScreen extends StatefulWidget {
  const PartnerManagementScreen({super.key});

  @override
  State<PartnerManagementScreen> createState() => _PartnerManagementScreenState();
}

class _PartnerManagementScreenState extends State<PartnerManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedStatus = 'All Status';
  String _selectedLocation = 'All Locations';
  String _selectedDateRange = 'All Time';
  int _rowsPerPage = 10;
  bool _selectAll = false;
  final Set<int> _selectedRows = {};
  bool _isLoading = false;

  int _totalPartners = 0;
  int _activePartners = 0;
  int _pendingPartners = 0;
  int _inactivePartners = 0;

  final List<String> _statusOptions = const [
    'All Status',
    'Active',
    'Pending',
    'Inactive',
  ];

  final List<String> _locationOptions = const [
    'All Locations',
    'Noida',
    'Delhi',
    'Ghaziabad',
    'Greater Noida',
    'Gurugram',
    'Faridabad',
  ];

  final List<String> _dateOptions = const [
    'All Time',
    'Today',
    'This Month',
    'Last 3 Months',
    'This Year',
  ];

  List _partners = [];

  @override
  void initState() {
    super.initState();
    _fetchPartners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPartners() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/partners'));

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final dynamic rawData = body['data'];

        List<dynamic> list = [];
        Map<String, dynamic>? stats;

        if (rawData is Map) {
          list = rawData['partners'] ?? [];
          stats = rawData['stats'];
        } else if (rawData is List) {
          list = rawData;
        }

        if (list.isNotEmpty) {
          final List loaded = [];
    for (int i = 0; i < list.length; i++) {
    final p = list[i];
    final st = (p['status'] ?? 'Active').toString();
    final num comm = p['commission'] ?? 0;

    loaded.add({
    'id': i + 1,
    '_id': p['_id'] ?? '',
    'code': p['code'] ?? p['dsaCode'] ?? 'DSA${(i + 1).toString().padLeft(3, '0')}',
    'name': p['name'] ?? 'Partner',
    'phone': p['phone'] ?? '+91 9876543210',
    'email': p['email'] ?? 'partner@gmail.com',
    'location': p['location'] ?? p['city'] ?? 'Noida',
    'agencyName': p['agencyName'] ?? '',
    'totalLeads': p['totalLeads'] ?? 0,
    'approved': p['approved'] ?? 0,
    'commission': CurrencyFormatter.formatWhole(comm.toDouble()),
    'rawCommission': comm,
    'status': st,
    'joinDate': p['createdAt'] != null
    ? '${p['createdAt'].toString().substring(0, 10)}\nRecent'
        : 'Recent',
    });
    }

    if (mounted) {
    setState(() {
    _partners = loaded;
    _totalCountFromLoaded(stats, loaded);
    _isLoading = false;
    });
    return;
    }
    }
    }
    _setFallbackPartners();
    } catch (_) {
    _setFallbackPartners();
    }
  }

  void _totalCountFromLoaded(Map<String, dynamic>? stats, List loaded) {
  _totalPartners = stats?['totalPartners'] ?? loaded.length;
  _activePartners = stats?['activePartners'] ??
  loaded.where((x) => x['status'].toString().toLowerCase() == 'active').length;
  _pendingPartners = stats?['pendingPartners'] ??
  loaded.where((x) => x['status'].toString().toLowerCase() == 'pending').length;
  _inactivePartners = stats?['inactivePartners'] ??
  loaded.where((x) => x['status'].toString().toLowerCase() == 'inactive').length;
  }

  void _setFallbackPartners() {
  if (!mounted) return;
  setState(() {
  _partners = [
  {
  'id': 1,
  '_id': 'partner_001',
  'code': 'DSA001',
  'name': 'Rahul Kumar',
  'phone': '+91 98765 43210',
  'email': 'rahul.kumar@gmail.com',
  'location': 'Noida',
  'agencyName': 'RK Associates',
  'totalLeads': 48,
  'approved': 32,
  'commission': '₹ 2,40,000',
  'rawCommission': 240000,
  'status': 'Active',
  'joinDate': '12 Jan 2024\n10:30 AM',
  },
  {
  'id': 2,
  '_id': 'partner_002',
  'code': 'DSA002',
  'name': 'Amit Yadav',
  'phone': '+91 91234 56789',
  'email': 'amit.yadav@gmail.com',
  'location': 'Delhi',
  'agencyName': 'AY Finance',
  'totalLeads': 36,
  'approved': 25,
  'commission': '₹ 1,85,000',
  'rawCommission': 185000,
  'status': 'Active',
  'joinDate': '08 Feb 2024\n02:15 PM',
  },
  {
  'id': 3,
  '_id': 'partner_003',
  'code': 'DSA003',
  'name': 'Sunil Sharma',
  'phone': '+91 99887 66554',
  'email': 'sunil.sharma@gmail.com',
  'location': 'Ghaziabad',
  'agencyName': 'Sharma Consultants',
  'totalLeads': 32,
  'approved': 20,
  'commission': '₹ 1,60,000',
  'rawCommission': 160000,
  'status': 'Active',
  'joinDate': '15 Mar 2024\n11:20 AM',
  },
  ];
  _totalPartners = _partners.length;
  _activePartners = _partners.where((p) => p['status'] == 'Active').length;
  _pendingPartners = _partners.where((p) => p['status'] == 'Pending').length;
  _inactivePartners = _partners.where((p) => p['status'] == 'Inactive').length;
  _isLoading = false;
  });
  }

  void _resetFilters() {
  setState(() {
  _searchController.clear();
  _selectedStatus = 'All Status';
  _selectedLocation = 'All Locations';
  _selectedDateRange = 'All Time';
  _selectedRows.clear();
  _selectAll = false;
  });
  }

  List get _filteredPartners {
  final query = _searchController.text.trim().toLowerCase();

  return _partners.where((item) {
  final name = item['name'].toString().toLowerCase();
  final phone = item['phone'].toString().toLowerCase();
  final email = item['email'].toString().toLowerCase();
  final code = item['code'].toString().toLowerCase();
  final loc = item['location'].toString().toLowerCase();

  final matchesSearch = query.isEmpty ||
  name.contains(query) ||
  phone.contains(query) ||
  email.contains(query) ||
  code.contains(query) ||
  loc.contains(query);

  final matchesStatus = _selectedStatus == 'All Status' ||
  item['status'].toString().toLowerCase() == _selectedStatus.toLowerCase();

  final matchesLoc = _selectedLocation == 'All Locations' ||
  loc.contains(_selectedLocation.toLowerCase());

  return matchesSearch && matchesStatus && matchesLoc;
  }).toList();
  }

  // ==========================================
  // ADD NEW PARTNER MODAL (Live POST API Call)
  // ==========================================
  void _openAddPartnerModal() {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final agencyCtrl = TextEditingController();
  final cityCtrl = TextEditingController(text: 'Noida');
  bool isSubmitting = false;

  showDialog(
  context: context,
  builder: (ctx) => StatefulBuilder(
  builder: (context, setModalState) => AlertDialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  title: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  const Text(
  'Add New Partner (DSA)',
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
  ),
  IconButton(
  icon: const Icon(Icons.close_rounded, size: 20),
  onPressed: () => Navigator.pop(ctx),
  ),
  ],
  ),
  content: SizedBox(
  width: 440,
  child: Form(
  key: formKey,
  child: SingleChildScrollView(
  child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  TextFormField(
  controller: nameCtrl,
  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
  decoration: _inputDecoration('Partner Full Name *', 'Rahul Kumar'),
  ),
  const SizedBox(height: 12),
  TextFormField(
  controller: phoneCtrl,
  keyboardType: TextInputType.phone,
  validator: (v) => (v == null || v.trim().length != 10) ? '10 digits required' : null,
  decoration: _inputDecoration('Mobile Number *', '9876543210', prefix: '+91 '),
  ),
  const SizedBox(height: 12),
  TextFormField(
  controller: emailCtrl,
  keyboardType: TextInputType.emailAddress,
  decoration: _inputDecoration('Email Address', 'partner@gmail.com'),
  ),
  const SizedBox(height: 12),
  TextFormField(
  controller: agencyCtrl,
  decoration: _inputDecoration('Agency / Business Name', 'RK Associates'),
  ),
  const SizedBox(height: 12),
  TextFormField(
  controller: cityCtrl,
  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
  decoration: _inputDecoration('City / Location *', 'Noida'),
  ),
  ],
  ),
  ),
  ),
  ),
  actions: [
  TextButton(
  onPressed: () => Navigator.pop(ctx),
  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
  ),
  ElevatedButton(
  onPressed: isSubmitting
  ? null
      : () async {
  if (formKey.currentState!.validate()) {
  setModalState(() => isSubmitting = true);
  try {
  final token = await SharedPrefHelper.getToken();
  final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/partners'));

  final res = await http.post(
  url,
  headers: {
  'Content-Type': 'application/json',
  if (token != null) 'Authorization': 'Bearer $token',
  },
  body: jsonEncode({
  'name': nameCtrl.text.trim(),
  'phone': phoneCtrl.text.trim(),
  'email': emailCtrl.text.trim(),
  'agencyName': agencyCtrl.text.trim(),
  'city': cityCtrl.text.trim(),
  }),
  );

  if (res.statusCode == 200 || res.statusCode == 201) {
  if (ctx.mounted) Navigator.pop(ctx);
  _fetchPartners(); // Refresh list immediately
  if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Partner registered and added to DSA queue!'),
  backgroundColor: Color(0xFF16A36A),
  ),
  );
  }
  } else {
  throw Exception();
  }
  } catch (_) {
  if (ctx.mounted) Navigator.pop(ctx);
  _fetchPartners();
  }
  }
  },
  style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF0F3E38),
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: isSubmitting
  ? const SizedBox(
  width: 18,
  height: 18,
  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
  )
      : const Text('Register Partner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
  ),
  ],
  ),
  ),
  );
  }

  // ==========================================
  // EDIT PARTNER MODAL (Live PUT API Call)
  // ==========================================
  void _openEditPartnerModal(Map<String, dynamic> partner) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController(text: partner['name'] ?? '');

  String initialPhone = (partner['phone'] ?? '').toString();
  initialPhone = initialPhone.replaceAll('+91', '').replaceAll(' ', '').trim();
  final phoneCtrl = TextEditingController(text: initialPhone);

  final emailCtrl = TextEditingController(text: partner['email'] ?? '');
  final cityCtrl = TextEditingController(text: partner['location'] ?? 'Noida');
  final agencyCtrl = TextEditingController(text: partner['agencyName'] ?? '');

  String status = partner['status'] ?? 'Active';
  if (!_statusOptions.contains(status) || status == 'All Status') {
  status = 'Active';
  }

  bool isSubmitting = false;

  showDialog(
  context: context,
  builder: (ctx) => StatefulBuilder(
  builder: (context, setModalState) => AlertDialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  title: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  'Edit Partner (${partner['code']})',
  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
  ),
  IconButton(
  icon: const Icon(Icons.close_rounded, size: 20),
  onPressed: () => Navigator.pop(ctx),
  ),
  ],
  ),
  content: SizedBox(
  width: 440,
  child: Form(
  key: formKey,
  child: SingleChildScrollView(
  child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  TextFormField(
  controller: nameCtrl,
  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
  decoration: _inputDecoration('Partner Full Name *', 'Rahul Kumar'),
  ),
  const SizedBox(height: 12),
  TextFormField(
  controller: phoneCtrl,
  keyboardType: TextInputType.phone,
  validator: (v) => (v == null || v.trim().length != 10) ? '10 digits required' : null,
  decoration: _inputDecoration('Mobile Number *', '9876543210', prefix: '+91 '),
  ),
  const SizedBox(height: 12),
  TextFormField(
  controller: emailCtrl,
  keyboardType: TextInputType.emailAddress,
  decoration: _inputDecoration('Email Address', 'partner@gmail.com'),
  ),
  const SizedBox(height: 12),
  TextFormField(
  controller: agencyCtrl,
  decoration: _inputDecoration('Agency / Business Name', 'RK Associates'),
  ),
  const SizedBox(height: 12),
  Row(
  children: [
  Expanded(
  child: TextFormField(
  controller: cityCtrl,
  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
  decoration: _inputDecoration('City / Location *', 'Noida'),
  ),
  ),
  const SizedBox(width: 10),
  Expanded(
  child: DropdownButtonFormField<String>(
  value: status,
  items: const ['Active', 'Pending', 'Inactive']
      .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
      .toList(),
  onChanged: (val) {
  if (val != null) setModalState(() => status = val);
  },
  decoration: _inputDecoration('Status', ''),
  ),
  ),
  ],
  ),
  ],
  ),
  ),
  ),
  ),
  actions: [
  TextButton(
  onPressed: () => Navigator.pop(ctx),
  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
  ),
  ElevatedButton(
  onPressed: isSubmitting
  ? null
      : () async {
  if (formKey.currentState!.validate()) {
  setModalState(() => isSubmitting = true);
  final partnerId = partner['_id'];

  try {
  final token = await SharedPrefHelper.getToken();
  final url = Uri.parse(MFUrls.mfBaseUrl('api/v1/admin/partners/$partnerId'));

  final res = await http.put(
  url,
  headers: {
  'Content-Type': 'application/json',
  if (token != null) 'Authorization': 'Bearer $token',
  },
  body: jsonEncode({
  'name': nameCtrl.text.trim(),
  'phone': phoneCtrl.text.trim(),
  'email': emailCtrl.text.trim(),
  'city': cityCtrl.text.trim(),
  'agencyName': agencyCtrl.text.trim(),
  'status': status,
  }),
  ).timeout(const Duration(seconds: 10));

  if (res.statusCode == 200 || res.statusCode == 201) {
  if (ctx.mounted) Navigator.pop(ctx);
  _fetchPartners(); // 🔄 Re-fetch partner list to update UI immediately
  if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Partner details updated successfully!'),
  backgroundColor: Color(0xFF16A36A),
  ),
  );
  }
  } else {
  throw Exception();
  }
  } catch (_) {
  if (ctx.mounted) Navigator.pop(ctx);
  setState(() {
  partner['name'] = nameCtrl.text.trim();
  partner['phone'] = '+91 ${phoneCtrl.text.trim()}';
  partner['email'] = emailCtrl.text.trim();
  partner['location'] = cityCtrl.text.trim();
  partner['agencyName'] = agencyCtrl.text.trim();
  partner['status'] = status;
  });
  if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
  content: Text('Partner updated in current view!'),
  backgroundColor: Color(0xFF16A36A),
  ),
  );
  }
  }
  }
  },
  style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF0F3E38),
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: isSubmitting
  ? const SizedBox(
  width: 18,
  height: 18,
  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
  )
      : const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
  ),
  ],
  ),
  ),
  );
  }

  InputDecoration _inputDecoration(String label, String hint, {String? prefix}) {
  return InputDecoration(
  labelText: label,
  labelStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
  hintText: hint,
  prefixText: prefix,
  prefixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
  filled: true,
  fillColor: const Color(0xFFF8FAFC),
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xFF0F3E38), width: 1.4)),
  );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: const Color(0xFFF8FAFC),
  body: SafeArea(
  child: SingleChildScrollView(
  physics: const BouncingScrollPhysics(),
  padding: const EdgeInsets.all(16),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  _buildHeaderSection(),
  const SizedBox(height: 16),
  _buildTopMetricsRow(),
  const SizedBox(height: 16),
  _buildFilterToolbar(),
  const SizedBox(height: 16),
  _isLoading
  ? const Center(
  child: Padding(
  padding: EdgeInsets.all(32),
  child: CircularProgressIndicator(color: AppColors.secondary),
  ),
  )
      : _buildPartnerDataTable(),
  const SizedBox(height: 14),
  _buildPaginationFooter(),
  const SizedBox(height: 20),
  ],
  ),
  ),
  ),
  );
  }

  Widget _buildHeaderSection() {
  return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  'Partner (DSA) Management',
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w900,
  color: AppColors.primary,
  ),
  ),
  SizedBox(height: 2),
  Text(
  'View, search and manage all registered DSA partners.',
  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
  ),
  ],
  ),
  Wrap(
  spacing: 8,
  children: [
  ElevatedButton.icon(
  onPressed: _openAddPartnerModal,
  icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
  label: const Text(
  '+ Add New Partner',
  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
  ),
  style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF0F3E38),
  elevation: 0,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  ),
  IconButton(
  icon: const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 22),
  tooltip: 'Refresh Partners',
  onPressed: _fetchPartners,
  ),
  ],
  ),
  ],
  );
  }

  Widget _buildTopMetricsRow() {
  return Row(
  children: [
  Expanded(
  child: _buildMetricCard(
  title: 'Total Partners',
  value: '$_totalPartners',
  badgeText: '+Live',
  badgeBg: const Color(0xFFDCFCE7),
  badgeColor: const Color(0xFF16A36A),
  subtitle: 'Total Registered',
  icon: Icons.people_outline_rounded,
  iconBg: const Color(0xFFE0F2FE),
  iconColor: const Color(0xFF0284C7),
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: _buildMetricCard(
  title: 'Active Partners',
  value: '$_activePartners',
  badgeText: 'Active',
  badgeBg: const Color(0xFFDCFCE7),
  badgeColor: const Color(0xFF16A36A),
  subtitle: 'Verified agents',
  icon: Icons.check_circle_outline_rounded,
  iconBg: const Color(0xFFDCFCE7),
  iconColor: const Color(0xFF16A36A),
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: _buildMetricCard(
  title: 'Pending Verification',
  value: '$_pendingPartners',
  badgeText: 'Pending',
  badgeBg: const Color(0xFFFEF3C7),
  badgeColor: const Color(0xFFD97706),
  subtitle: 'KYC In review',
  icon: Icons.access_time_rounded,
  iconBg: const Color(0xFFFEF3C7),
  iconColor: const Color(0xFFD97706),
  ),
  ),
  const SizedBox(width: 12),
  Expanded(
  child: _buildMetricCard(
  title: 'Inactive Partners',
  value: '$_inactivePartners',
  badgeText: 'Inactive',
  badgeBg: const Color(0xFFFEE2E2),
  badgeColor: const Color(0xFFDC2626),
  subtitle: 'Dormant agents',
  icon: Icons.cancel_outlined,
  iconBg: const Color(0xFFFEE2E2),
  iconColor: const Color(0xFFDC2626),
  ),
  ),
  ],
  );
  }

  Widget _buildMetricCard({
  required String title,
  required String value,
  required String badgeText,
  required Color badgeBg,
  required Color badgeColor,
  required String subtitle,
  required IconData icon,
  required Color iconBg,
  required Color iconColor,
  }) {
  return Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: AppColors.border),
  ),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(title, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
  Container(
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(4)),
  child: Text(badgeText, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: badgeColor)),
  ),
  ],
  ),
  const SizedBox(height: 8),
  Row(
  children: [
  CircleAvatar(radius: 14, backgroundColor: iconBg, child: Icon(icon, size: 16, color: iconColor)),
  const SizedBox(width: 10),
  Text(
  value,
  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
  ),
  ],
  ),
  const SizedBox(height: 4),
  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textHint)),
  ],
  ),
  );
  }

  Widget _buildFilterToolbar() {
  return Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: AppColors.border),
  ),
  child: Row(
  children: [
  Expanded(
  flex: 3,
  child: Container(
  height: 40,
  decoration: BoxDecoration(
  color: const Color(0xFFF8FAFC),
  borderRadius: BorderRadius.circular(8),
  border: Border.all(color: AppColors.border),
  ),
  child: TextField(
  controller: _searchController,
  onChanged: (_) => setState(() {}),
  style: const TextStyle(fontSize: 12),
  decoration: const InputDecoration(
  hintText: 'Search by name, mobile, email, code...',
  hintStyle: TextStyle(fontSize: 11, color: AppColors.textHint),
  prefixIcon: Icon(Icons.search_rounded, size: 17, color: AppColors.iconSecondary),
  border: InputBorder.none,
  contentPadding: EdgeInsets.symmetric(vertical: 10),
  ),
  ),
  ),
  ),
  const SizedBox(width: 10),
  Expanded(
  flex: 2,
  child: _buildDropdownFilter(
  value: _selectedStatus,
  items: _statusOptions,
  onChanged: (v) => setState(() => _selectedStatus = v!),
  ),
  ),
  const SizedBox(width: 10),
  Expanded(
  flex: 2,
  child: _buildDropdownFilter(
  value: _selectedLocation,
  items: _locationOptions,
  onChanged: (v) => setState(() => _selectedLocation = v!),
  ),
  ),
  const SizedBox(width: 10),
  Expanded(
  flex: 2,
  child: _buildDropdownFilter(
  value: _selectedDateRange,
  items: _dateOptions,
  icon: Icons.calendar_today_outlined,
  onChanged: (v) => setState(() => _selectedDateRange = v!),
  ),
  ),
  const SizedBox(width: 10),
  OutlinedButton(
  onPressed: _resetFilters,
  style: OutlinedButton.styleFrom(
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  side: const BorderSide(color: AppColors.border),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: const Text('Reset', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
  ),
  ],
  ),
  );
  }

  Widget _buildDropdownFilter({
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
  IconData? icon,
  }) {
  return Container(
  height: 40,
  padding: const EdgeInsets.symmetric(horizontal: 10),
  decoration: BoxDecoration(
  color: const Color(0xFFF8FAFC),
  borderRadius: BorderRadius.circular(8),
  border: Border.all(color: AppColors.border),
  ),
  child: DropdownButtonHideUnderline(
  child: DropdownButton<String>(
  value: value,
  icon: Icon(icon ?? Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.iconSecondary),
  isExpanded: true,
  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
  items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
  onChanged: onChanged,
  ),
  ),
  );
  }

  Widget _buildPartnerDataTable() {
  final partners = _filteredPartners;

  if (partners.isEmpty) {
  return Container(
  width: double.infinity,
  padding: const EdgeInsets.all(32),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: AppColors.border),
  ),
  child: const Center(
  child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  Icon(Icons.person_off_outlined, size: 40, color: AppColors.textHint),
  SizedBox(height: 8),
  Text('No matching partner records found', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
  ],
  ),
  ),
  );
  }

  return Container(
  width: double.infinity,
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: AppColors.border),
  ),
  child: ClipRRect(
  borderRadius: BorderRadius.circular(14),
  child: SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  physics: const BouncingScrollPhysics(),
  child: DataTable(
  showCheckboxColumn: false, // Prevents duplicate checkbox column
  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
  headingRowHeight: 44,
  dataRowMinHeight: 52,
  dataRowMaxHeight: 56,
  horizontalMargin: 14,
  columnSpacing: 22,
  columns: [
  DataColumn(
  label: Checkbox(
  value: _selectAll,
  activeColor: const Color(0xFF0F3E38),
  onChanged: (val) {
  setState(() {
  _selectAll = val ?? false;
  if (_selectAll) {
  _selectedRows.addAll(List.generate(partners.length, (i) => i));
  } else {
  _selectedRows.clear();
  }
  });
  },
  ),
  ),
  const DataColumn(label: Text('#', style: _headerStyle)),
  const DataColumn(label: Text('Partner Details', style: _headerStyle)),
  const DataColumn(label: Text('Contact Information', style: _headerStyle)),
  const DataColumn(label: Text('Location', style: _headerStyle)),
  const DataColumn(label: Text('Total Leads', style: _headerStyle)),
  const DataColumn(label: Text('Approved', style: _headerStyle)),
  const DataColumn(label: Text('Commission', style: _headerStyle)),
  const DataColumn(label: Text('Status', style: _headerStyle)),
  const DataColumn(label: Text('Join Date', style: _headerStyle)),
  const DataColumn(label: Text('Actions', style: _headerStyle)),
  ],
  rows: List.generate(partners.length, (index) {
  final item = partners[index];
  final isSelected = _selectedRows.contains(index);

  Color statusBg = const Color(0xFFDCFCE7);
  Color statusCol = const Color(0xFF16A36A);
  if (item['status'] == 'Pending') {
  statusBg = const Color(0xFFFEF3C7);
  statusCol = const Color(0xFFD97706);
  } else if (item['status'] == 'Inactive') {
  statusBg = const Color(0xFFFEE2E2);
  statusCol = const Color(0xFFDC2626);
  }

  return DataRow(
  selected: isSelected,
  cells: [
  DataCell(
  Checkbox(
  value: isSelected,
  activeColor: const Color(0xFF0F3E38),
  onChanged: (val) {
  setState(() {
  if (val == true) {
  _selectedRows.add(index);
  } else {
  _selectedRows.remove(index);
  }
  _selectAll = _selectedRows.length == partners.length;
  });
  },
  ),
  ),
  DataCell(Text('${item['id']}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
  DataCell(
  Row(
  children: [
  CircleAvatar(
  radius: 14,
  backgroundColor: const Color(0xFF0F3E38).withValues(alpha: 0.1),
  child: Text(
  (item['name'] as String).isNotEmpty ? (item['name'] as String)[0].toUpperCase() : 'P',
  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F3E38)),
  ),
  ),
  const SizedBox(width: 8),
  Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(
  item['name'] as String,
  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
  ),
  Text(
  item['code'] as String,
  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0F3E38)),
  ),
  ],
  ),
  ],
  ),
  ),
  DataCell(
  Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  Text(item['phone'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
  Text(item['email'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
  ],
  ),
  ),
  DataCell(Text(item['location'] as String, style: const TextStyle(fontSize: 11.5, color: AppColors.textPrimary))),
  DataCell(Text('${item['totalLeads']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
  DataCell(Text('${item['approved']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF16A36A)))),
  DataCell(Text(item['commission'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary))),
  DataCell(
  Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
  child: Text(
  item['status'] as String,
  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusCol),
  ),
  ),
  ),
  DataCell(
  Text(
  item['joinDate'] as String,
  style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.2),
  ),
  ),
  DataCell(
  Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  // View Action -> Navigates to Partner Details Screen
  IconButton(
  icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF0284C7)),
  tooltip: 'View Partner Details',
  onPressed: () {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (_) => PartnerDetailsAdminScreen(partnerData: item),
  ),
  );
  },
  ),
  // Edit Action -> Opens Edit Modal and Updates Backend
  IconButton(
  icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF0F3E38)),
  tooltip: 'Edit Partner',
  onPressed: () => _openEditPartnerModal(item),
  ),
  ],
  ),
  ),
  ],
  );
  }),
  ),
  ),
  ),
  );
  }

  static const TextStyle _headerStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w800,
  color: AppColors.primary,
  );

  Widget _buildPaginationFooter() {
  final filtered = _filteredPartners;

  return Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  'Showing ${filtered.isEmpty ? 0 : 1} to ${filtered.length > _rowsPerPage ? _rowsPerPage : filtered.length} of ${filtered.length} partners',
  style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
  ),
  Row(
  children: [
  Container(
  height: 32,
  padding: const EdgeInsets.symmetric(horizontal: 8),
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(6),
  border: Border.all(color: AppColors.border),
  ),
  child: DropdownButtonHideUnderline(
  child: DropdownButton<int>(
  value: _rowsPerPage,
  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
  items: [10, 25, 50]
      .map((n) => DropdownMenuItem(value: n, child: Text('$n per page')))
      .toList(),
  onChanged: (val) {
  if (val != null) setState(() => _rowsPerPage = val);
  },
  ),
  ),
  ),
  ],
  ),
  ],
  );
  }
}
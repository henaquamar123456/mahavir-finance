import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../constants/api_urls.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/theme/app_text_styles.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/date_formatter.dart';
import '../../../../widgets/inquiry_stepper.dart';
import '../../../c_models/inquiry_model.dart';
import '../../../core/servicess/shared_pref_helper.dart';

class InquiryDetailsScreen extends StatefulWidget {
  final InquiryModel inquiry;

  const InquiryDetailsScreen({
    super.key,
    required this.inquiry,
  });

  @override
  State<InquiryDetailsScreen> createState() => _InquiryDetailsScreenState();
}

class _InquiryDetailsScreenState extends State<InquiryDetailsScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _liveLoanData;
  late InquiryStatus _currentStatus;
  List<dynamic> _repaymentSchedule = [];
  List<dynamic> _uploadedDocuments = [];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.inquiry.status;
    _fetchLiveLoanSummary();
  }

  Future<void> _fetchLiveLoanSummary() async {
    setState(() => _isLoading = true);

    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null) return;

      final url = Uri.parse(MFUrls.loanSummary(widget.inquiry.id));
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 12));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final loan = data['data'] ?? {};
        if (mounted) {
          setState(() {
            _liveLoanData = loan;
            _currentStatus = InquiryStatus.fromString(
                loan['status'] ?? widget.inquiry.status.label);
            _repaymentSchedule = loan['repaymentSchedule'] ?? [];
            _uploadedDocuments = loan['documents'] ?? [];
          });
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _payEmiInstallment() async {
    final token = await SharedPrefHelper.getToken();
    if (token == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: AppColors.secondary),
      ),
    );

    try {
      final url = Uri.parse(MFUrls.payEmi(widget.inquiry.id));
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;
      Navigator.pop(context);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'EMI installment paid successfully!'),
            backgroundColor: AppColors.secondary,
          ),
        );
        _fetchLiveLoanSummary();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Unable to process EMI payment.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server connection timeout. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inquiry = widget.inquiry;
    final double displayAmount = (_liveLoanData != null && _liveLoanData!['loanAmount'] != null)
        ? (_liveLoanData!['loanAmount'] as num).toDouble()
        : inquiry.amount;

    final String adminRemarks = _liveLoanData?['remarks'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Inquiry Details',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: _fetchLiveLoanSummary,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inquiry Details',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Here are the details and status of your loan inquiry.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Header Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: inquiry.iconColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(inquiry.icon, color: inquiry.iconColor, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  inquiry.loanType,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  inquiry.id,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Submitted on ${DateFormatter.formatDate(inquiry.date)}, ${inquiry.formattedTime}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _currentStatus.backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _currentStatus.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _currentStatus.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Stepper Progress
                    InquiryStepper(
                      currentStep: _getStepFromStatus(_currentStatus),
                      dateText: DateFormatter.formatShortDate(inquiry.date),
                    ),
                    const SizedBox(height: 14),

                    // Admin Remarks
                    if (adminRemarks.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.feedback_outlined, color: Color(0xFFD97706), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Admin Remarks',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF92400E),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    adminRemarks,
                                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF78350F)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Loan Details
                    _buildInfoSection(
                      title: 'Loan Details',
                      icon: Icons.account_balance_wallet_outlined,
                      children: [
                        _buildDetailRow('Loan Type', inquiry.loanType),
                        _buildDetailRow('Loan Amount', CurrencyFormatter.formatWhole(displayAmount)),
                        _buildDetailRow('Purpose of Loan', inquiry.purpose),
                        _buildDetailRow('Preferred Tenure', inquiry.tenure),
                        _buildDetailRow('Expected Disbursal', inquiry.expectedDisbursal, isLast: true),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Uploaded Documents List
                    if (_uploadedDocuments.isNotEmpty) ...[
                      _buildInfoSection(
                        title: 'Uploaded Documents',
                        icon: Icons.folder_shared_outlined,
                        children: [
                          ..._uploadedDocuments.map((doc) {
                            final docType = doc['documentType'] ?? 'Document';
                            final fileName = (doc['filePath'] ?? 'file.pdf').toString().split('/').last;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(docType, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                        Text(fileName, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Uploaded',
                                      style: TextStyle(fontSize: 10, color: Color(0xFF16A36A), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Repayment Schedule
                    if (_repaymentSchedule.isNotEmpty) ...[
                      _buildInfoSection(
                        title: 'Repayment Schedule',
                        icon: Icons.calendar_month_outlined,
                        children: [
                          ..._repaymentSchedule.take(6).map((item) {
                            final bool isPaid = item['status'] == 'Paid';
                            final dueDate = item['dueDate'] != null
                                ? DateFormat('dd MMM yyyy').format(DateTime.parse(item['dueDate']))
                                : 'Pending';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Installment #${item['installmentNo'] ?? 1}',
                                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Due: $dueDate',
                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '₹${item['emiAmount'] ?? 0}',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          isPaid ? 'Paid' : 'Pending',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: isPaid ? const Color(0xFF16A36A) : const Color(0xFFD97706),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Applicant Details
                    _buildInfoSection(
                      title: 'Your Details',
                      icon: Icons.person_outline_rounded,
                      children: [
                        _buildDetailRow('Full Name', inquiry.applicantName),
                        _buildDetailRow('Mobile Number', inquiry.mobileNumber),
                        _buildDetailRow('Email Address', inquiry.email),
                        _buildDetailRow('Employment Type', inquiry.employmentType),
                        _buildDetailRow('Monthly Income', CurrencyFormatter.formatWhole(inquiry.monthlyIncome)),
                        _buildDetailRow('Company Name', inquiry.companyName),
                        _buildDetailRow('City', inquiry.city, isLast: true),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.info_rounded, color: Color(0xFF2563EB), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Our loan officers will verify all provided documents. You can upload additional proofs directly from this screen.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1E40AF),
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final bool isApproved = _currentStatus == InquiryStatus.approved;
    final bool hasPendingEmis = _repaymentSchedule.any((item) => item['status'] == 'Pending');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: isApproved && hasPendingEmis
          ? SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: _payEmiInstallment,
          icon: const Icon(Icons.payment_rounded, color: Colors.white, size: 20),
          label: const Text(
            'Pay Next EMI Installment',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      )
          : SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: _showDocumentUploadSheet,
          icon: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 20),
          label: const Text(
            'Upload Required Documents',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 1.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  /// Real File Picker + Bottom Sheet
  void _showDocumentUploadSheet() {
    String selectedType = 'PAN Card';
    final docTypes = [
      'PAN Card',
      'Identity Proof',
      'Salary Slip',
      'Bank Statement',
      'Address Proof',
      'Other Document'
    ];

    PlatformFile? pickedFile;
    bool isUploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.fromLTRB(
              20, 16, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upload Document',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Select document category and attach file from device.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),

              // Category Selector
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType,
                    isExpanded: true,
                    items: docTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedType = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Real File Picker Box
              InkWell(
                onTap: isUploading
                    ? null
                    : () async {
                  try {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                      withData: true, // Web support ke liye zaroori
                    );

                    if (result != null && result.files.isNotEmpty) {
                      setSheetState(() {
                        pickedFile = result.files.first;
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('File pick error: $e')),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: pickedFile != null ? AppColors.secondary : AppColors.border,
                      width: pickedFile != null ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        pickedFile != null
                            ? Icons.check_circle_rounded
                            : Icons.cloud_upload_outlined,
                        size: 38,
                        color: pickedFile != null ? AppColors.secondary : AppColors.iconSecondary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pickedFile != null
                            ? pickedFile!.name
                            : 'Tap to browse ($selectedType)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: pickedFile != null ? AppColors.secondary : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pickedFile != null
                            ? '${(pickedFile!.size / 1024).toStringAsFixed(1)} KB'
                            : 'Supported formats: JPG, PNG, PDF (Max 10MB)',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Upload Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: (pickedFile == null || isUploading)
                      ? null
                      : () async {
                    setSheetState(() => isUploading = true);
                    final ok = await _uploadDocumentMultipart(selectedType, pickedFile!);
                    setSheetState(() => isUploading = false);

                    if (!context.mounted) return;
                    Navigator.pop(ctx);

                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$selectedType uploaded successfully!'),
                          backgroundColor: AppColors.secondary,
                        ),
                      );
                      _fetchLiveLoanSummary();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload failed. Please check server.'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    disabledBackgroundColor: AppColors.buttonDisabled,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isUploading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text(
                    'Upload & Submit Document',
                    style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Real Multipart Upload Method (Web + Android compatible)
// File ke sabse upar yeh import zaroor add karein:

  /// Real Multipart Upload Method (Web + Android compatible)
  Future<bool> _uploadDocumentMultipart(String docType, PlatformFile file) async {
    final token = await SharedPrefHelper.getToken();
    if (token == null) return false;

    try {
      final uri = Uri.parse(MFUrls.uploadDocuments(widget.inquiry.id));
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['documentType'] = docType;

      // File extension ke basis par MediaType detect karna
      final String ext = (file.extension ?? file.name.split('.').last).toLowerCase();
      http.MediaType mediaType;
      if (ext == 'pdf') {
        mediaType = http.MediaType('application', 'pdf');
      } else if (ext == 'jpg' || ext == 'jpeg') {
        mediaType = http.MediaType('image', 'jpeg');
      } else {
        mediaType = http.MediaType('image', 'png');
      }

      // Web par file.bytes aur Mobile par file.path safely handle karein
      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
            contentType: mediaType,
          ),
        );
      } else if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path!,
            contentType: mediaType,
          ),
        );
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);
      return (response.statusCode == 200 || response.statusCode == 201) && data['success'] == true;
    } catch (e) {
      return false;
    }
  }
  int _getStepFromStatus(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.pending:
        return 0;
      case InquiryStatus.underReview:
        return 1;
      case InquiryStatus.approved:
        return 3;
      case InquiryStatus.rejected:
        return 0;
    }
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
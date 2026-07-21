import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/bucket_providers.dart';
import '../widgets/bucket_qr_scanner.dart';

class JoinBucketScreen extends ConsumerStatefulWidget {
  const JoinBucketScreen({super.key});

  @override
  ConsumerState<JoinBucketScreen> createState() => _JoinBucketScreenState();
}

class _JoinBucketScreenState extends ConsumerState<JoinBucketScreen> {
  final _code = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _join(String code) async {
    final bucket = await ref
        .read(bucketControllerProvider.notifier)
        .joinViaCode(code);
    if (!mounted) return;
    if (bucket != null) {
      context.go(RouteNames.home);
    } else {
      final error = ref.read(bucketControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Could not join bucket.',
          ),
        ),
      );
    }
  }

  void _submitCode() {
    if (!_formKey.currentState!.validate()) return;
    _join(_code.text.trim().toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(bucketControllerProvider).isLoading;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Join a bucket'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Enter code', icon: Icon(Icons.keyboard_alt_outlined)),
              Tab(text: 'Scan QR', icon: Icon(Icons.qr_code_scanner_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _code,
                      label: 'Join code',
                      hint: 'A7K9QX',
                      prefixIcon: Icons.tag_rounded,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9]'),
                        ),
                        UpperCaseTextFormatter(),
                      ],
                      validator: Validators.joinCode,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Join bucket',
                      isLoading: busy,
                      onPressed: busy ? null : _submitCode,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Text(
                    'Point your camera at the bucket QR code',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: BucketQrScanner(
                      onDetected: (code) {
                        if (!busy) _join(code);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

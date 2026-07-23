import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/join_request_providers.dart';
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

  void _snack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _request(String code) async {
    if (!(ref.read(isOnlineProvider).value ?? true)) {
      _snack('Connect to the internet to request to join a bucket.');
      return;
    }
    final outcome = await ref
        .read(joinRequestControllerProvider.notifier)
        .requestJoin(code);
    if (!mounted) return;
    switch (outcome) {
      case JoinRequestOutcome.pending:
        _snack('Request sent. You will get in once the owner approves.');
        context.go(RouteNames.home);
      case JoinRequestOutcome.alreadyMember:
        _snack("You're already a member of this bucket.");
        context.go(RouteNames.home);
      case JoinRequestOutcome.notFound:
        _snack('No bucket found for that code.');
      case JoinRequestOutcome.failed:
        final error = ref.read(joinRequestControllerProvider).error;
        final raw = (error is AppException ? error.message : '').toLowerCase();
        if (raw.contains('owner_not_shareable')) {
          _snack("This bucket can't be joined yet.");
        } else if (raw.contains('auth_required')) {
          _snack('Sign in to join a bucket.');
        } else {
          _snack(
            error is AppException
                ? error.message
                : 'Could not send the request.',
          );
        }
    }
  }

  void _submitCode() {
    if (!_formKey.currentState!.validate()) return;
    _request(_code.text.trim().toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(joinRequestControllerProvider).isLoading;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Join a bucket'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Enter code', icon: AppIcon(AppAssets.keyboardAlt)),
              Tab(text: 'Scan QR', icon: AppIcon(AppAssets.qrCodeScanner)),
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
                      prefixIcon: AppAssets.tag,
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
                      label: 'Request to join',
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
                        if (!busy) _request(code);
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

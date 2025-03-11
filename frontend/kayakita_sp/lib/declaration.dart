import 'package:flutter/material.dart';
import 'dart:convert';
import 'home.dart'; 
import 'api_service.dart';
import 'widgets/customappbar.dart';
import 'widgets/labeledcheckbox.dart';

class DeclarationScreen extends StatefulWidget {
  final String username;
  final String email;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String contactNumber;
  final String address;

  const DeclarationScreen({
    super.key,
    required this.username,
    required this.email,
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.contactNumber,
    required this.address,
  });

  @override
  _DeclarationScreenState createState() => _DeclarationScreenState();
}

class _DeclarationScreenState extends State<DeclarationScreen> {
  bool _privacyNotice = false;
  bool _tosTransport = false;
  bool _tosPayments = false;
  bool _tosFamily = false;
  bool _riderGuidelines = false;

  bool _sms = false;
  bool _call = false;
  bool _email = false;
  bool _pushNotifs = false;
  bool _chatApps = false;

  bool _noLicenseSuspension = false;
  bool _noCourtConviction = false;
  bool _noPendingTrial = false;
  bool _medicallyFit = false;
  bool _walletAgreement = false;
  bool _dataSharingConsent = false;
  bool _walletUpgradeConsent = false;

  bool isLoading = false; // ✅ Show loading indicator

  /// ✅ **Handles form submission (Final API call)**
  Future<void> onSubmit() async {
    // 🔴 **Ensure all required checkboxes are checked**
    if (!_privacyNotice ||
        !_tosTransport ||
        !_tosPayments ||
        !_tosFamily ||
        !_riderGuidelines ||
        !_noLicenseSuspension ||
        !_noCourtConviction ||
        !_noPendingTrial ||
        !_medicallyFit ||
        !_walletAgreement ||
        !_dataSharingConsent ||
        !_walletUpgradeConsent) {
      _showErrorMessage("⚠️ Please agree to all required declarations.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ✅ **Prepare data for submission**
      final response = await ApiService.updateWorker({
        "email": widget.email, // ✅ Ensure email is included
        "username": widget.username,
        "first_name": widget.firstName,
        "middle_initial": widget.middleInitial,
        "last_name": widget.lastName,
        "contact_number": widget.contactNumber,
        "address": widget.address,
        "consents": {
          "privacy_notice": _privacyNotice,
          "tos_transport": _tosTransport,
          "tos_payments": _tosPayments,
          "tos_family": _tosFamily,
          "rider_guidelines": _riderGuidelines,
        },
        "marketing_preferences": {
          "sms": _sms,
          "call": _call,
          "email": _email,
          "push_notifications": _pushNotifs,
          "chat_apps": _chatApps,
        },
        "declarations": {
          "no_license_suspension": _noLicenseSuspension,
          "no_court_conviction": _noCourtConviction,
          "no_pending_trial": _noPendingTrial,
          "medically_fit": _medicallyFit,
          "wallet_agreement": _walletAgreement,
          "data_sharing_consent": _dataSharingConsent,
          "wallet_upgrade_consent": _walletUpgradeConsent,
        }
      });

      if (response.statusCode == 200) {
        // ✅ **Navigate to HomeScreen upon successful registration**
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        _showErrorMessage("Registration failed: ${response.body}");
      }
    } catch (error) {
      _showErrorMessage("An error occurred: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// ✅ **Show snackbar for error messages**
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(titleText: 'Declaration'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Consents
              Text(
                'Consents',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              LabeledCheckbox(
                label: 'Privacy Notice',
                value: _privacyNotice,
                onChanged: (value) => setState(() => _privacyNotice = value),
              ),
              LabeledCheckbox(
                label: 'Terms of Service: Transport, Delivery, and Logistics',
                value: _tosTransport,
                onChanged: (value) => setState(() => _tosTransport = value),
              ),
              LabeledCheckbox(
                label: 'Terms of Service: Payments and Rewards',
                value: _tosPayments,
                onChanged: (value) => setState(() => _tosPayments = value),
              ),
              LabeledCheckbox(
                label: 'Terms of Service: Family Account',
                value: _tosFamily,
                onChanged: (value) => setState(() => _tosFamily = value),
              ),
              LabeledCheckbox(
                label: 'Rider Guidelines',
                value: _riderGuidelines,
                onChanged: (value) => setState(() => _riderGuidelines = value),
              ),

              const SizedBox(height: 30),
              Text(
                'Marketing Preferences',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              LabeledCheckbox(label: 'SMS', value: _sms, onChanged: (value) => setState(() => _sms = value)),
              LabeledCheckbox(label: 'Call', value: _call, onChanged: (value) => setState(() => _call = value)),
              LabeledCheckbox(label: 'E-mail', value: _email, onChanged: (value) => setState(() => _email = value)),
              LabeledCheckbox(label: 'Push Notifications', value: _pushNotifs, onChanged: (value) => setState(() => _pushNotifs = value)),
              LabeledCheckbox(label: 'Chat Apps (e.g. Viber, WhatsApp)', value: _chatApps, onChanged: (value) => setState(() => _chatApps = value)),

              const SizedBox(height: 30),
              Text(
                'Declarations',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              LabeledCheckbox(label: 'My driving license has not been disqualified or suspended.', value: _noLicenseSuspension, onChanged: (value) => setState(() => _noLicenseSuspension = value)),
              LabeledCheckbox(label: 'I have not been convicted in court.', value: _noCourtConviction, onChanged: (value) => setState(() => _noCourtConviction = value)),
              LabeledCheckbox(label: 'I am not awaiting any type of court trial against me.', value: _noPendingTrial, onChanged: (value) => setState(() => _noPendingTrial = value)),
              LabeledCheckbox(label: 'I have no medical condition that would make me unfit to do my work safely.', value: _medicallyFit, onChanged: (value) => setState(() => _medicallyFit = value)),
              LabeledCheckbox(label: 'I agree that kayakita may top up (or add to) and claw back (or deduct from) my cash wallet and credit wallet for any kayakita-related transactions.', value: _walletAgreement, onChanged: (value) => setState(() => _walletAgreement = value)),
              LabeledCheckbox(label: 'I consent to kayakita using my personal data (including my government-issued ID, profile information, and status) to: offer financial products and services, conduct background checks, link my personal data between my kayakita SP app and kayakita Customer app (if I have one), and carry out reasonable actions in line with the Kayakita privacy policy.', value: _dataSharingConsent, onChanged: (value) => setState(() => _dataSharingConsent = value)),
              LabeledCheckbox(label: 'I understand that in upgrading my rider cash wallet, it will be linked to the Kayakita Wallet of my Kayakita SP app. If I do not have a Kayakita Wallet, I may need to sign up to obtain one.', value: _walletUpgradeConsent, onChanged: (value) => setState(() => _walletUpgradeConsent = value)),

              const SizedBox(height: 60),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

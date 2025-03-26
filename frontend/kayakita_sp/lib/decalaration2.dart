import 'package:flutter/material.dart';
import 'package:kayakita_sp/api_service.dart';
import 'package:kayakita_sp/entrance.dart';
import 'package:kayakita_sp/providers/profile_provider.dart';
import 'package:kayakita_sp/widgets/customappbar.dart';
import 'package:kayakita_sp/widgets/labeledcheckbox.dart';
import 'package:provider/provider.dart';

class SecondDeclarationScreen extends StatefulWidget {
  final Map<String, dynamic> workerData;
  // these are the ff workerdata:
  //   workerData['firstName'] = firstNameController.text;
  //   workerData['middleInitial'] = middleInitialController.text;
  //   workerData['lastName'] = lastNameController.text;
  //   workerData['contactNumber'] = mobileNumberController.text;
  //   workerData['address'] = addressController.text;
  //   workerData['service'] = selectedService!;
  final Map<String, dynamic> certificationData;

  const SecondDeclarationScreen({
    super.key,
    required this.workerData,
    required this.certificationData
  });

  @override
  State<SecondDeclarationScreen> createState() => _SecondDeclarationScreenState();
}

class _SecondDeclarationScreenState extends State<SecondDeclarationScreen> {
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

  bool isLoading = false;

  late String workerUsername;

  Future<void> onSubmit() async {
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

    workerUsername = Provider.of<UserProvider>(context, listen: false).username;

    Map<String, dynamic> newJobData = {
      "username": workerUsername,
      "service_preference": widget.workerData['service'],
      "is_suspended": false, 
      "is_certified": widget.workerData['isCertified'],
    };

    try {
      final response = await ApiService.createSecondJob(newJobData);

      if (response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EntranceScreen(email: widget.workerData['email']),
          ),
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
              Text('Consents',
                  style: Theme.of(context).textTheme.headlineMedium),
              LabeledCheckbox(
                  label: 'Privacy Notice',
                  value: _privacyNotice,
                  onChanged: (value) => setState(() => _privacyNotice = value)),
              LabeledCheckbox(
                  label: 'Terms of Service: Transport, Delivery, and Logistics',
                  value: _tosTransport,
                  onChanged: (value) => setState(() => _tosTransport = value)),
              LabeledCheckbox(
                  label: 'Terms of Service: Payments and Rewards',
                  value: _tosPayments,
                  onChanged: (value) => setState(() => _tosPayments = value)),
              LabeledCheckbox(
                  label: 'Terms of Service: Family Account',
                  value: _tosFamily,
                  onChanged: (value) => setState(() => _tosFamily = value)),
              LabeledCheckbox(
                  label: 'Rider Guidelines',
                  value: _riderGuidelines,
                  onChanged: (value) =>
                      setState(() => _riderGuidelines = value)),
              const SizedBox(height: 30),
              Text('Marketing Preferences',
                  style: Theme.of(context).textTheme.headlineMedium),
              LabeledCheckbox(
                  label: 'SMS',
                  value: _sms,
                  onChanged: (value) => setState(() => _sms = value)),
              LabeledCheckbox(
                  label: 'Call',
                  value: _call,
                  onChanged: (value) => setState(() => _call = value)),
              LabeledCheckbox(
                  label: 'E-mail',
                  value: _email,
                  onChanged: (value) => setState(() => _email = value)),
              LabeledCheckbox(
                  label: 'Push Notifications',
                  value: _pushNotifs,
                  onChanged: (value) => setState(() => _pushNotifs = value)),
              LabeledCheckbox(
                  label: 'Chat Apps (e.g. Viber, WhatsApp)',
                  value: _chatApps,
                  onChanged: (value) => setState(() => _chatApps = value)),
              const SizedBox(height: 30),
              Text('Declarations',
                  style: Theme.of(context).textTheme.headlineMedium),
              LabeledCheckbox(
                  label:
                      'My driving license has not been disqualified or suspended.',
                  value: _noLicenseSuspension,
                  onChanged: (value) =>
                      setState(() => _noLicenseSuspension = value)),
              LabeledCheckbox(
                  label: 'I have not been convicted in court.',
                  value: _noCourtConviction,
                  onChanged: (value) =>
                      setState(() => _noCourtConviction = value)),
              LabeledCheckbox(
                  label:
                      'I am not awaiting any type of court trial against me.',
                  value: _noPendingTrial,
                  onChanged: (value) =>
                      setState(() => _noPendingTrial = value)),
              LabeledCheckbox(
                  label:
                      'I have no medical condition that would make me unfit to do my work safely.',
                  value: _medicallyFit,
                  onChanged: (value) => setState(() => _medicallyFit = value)),
              LabeledCheckbox(
                  label:
                      'I agree that kayakita may top up (or add to) and claw back (or deduct from) my cash wallet and credit wallet for any kayakita-related transactions.',
                  value: _walletAgreement,
                  onChanged: (value) =>
                      setState(() => _walletAgreement = value)),
              LabeledCheckbox(
                  label:
                      'I consent to kayakita using my personal data (including my government-issued ID, profile information, and status) to: offer financial products and services, conduct background checks, link my personal data between my kayakita SP app and kayakita Customer app (if I have one), and carry out reasonable actions in line with the Kayakita privacy policy.',
                  value: _dataSharingConsent,
                  onChanged: (value) =>
                      setState(() => _dataSharingConsent = value)),
              LabeledCheckbox(
                  label:
                      'I understand that in upgrading my rider cash wallet, it will be linked to the Kayakita Wallet of my Kayakita SP app. If I do not have a Kayakita Wallet, I may need to sign up to obtain one.',
                  value: _walletUpgradeConsent,
                  onChanged: (value) =>
                      setState(() => _walletUpgradeConsent = value)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                    ),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: isLoading ? null : onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF87027B),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

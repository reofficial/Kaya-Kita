import 'package:flutter/material.dart';

import '../widgets/customappbar.dart';
import '../widgets/labeledcheckbox.dart';

class DeclarationScreen extends StatefulWidget {
  const DeclarationScreen({
    super.key,
  });

  @override
  State<DeclarationScreen> createState() => _DeclarationScreenState();
}

class _DeclarationScreenState extends State<DeclarationScreen> {
  bool _privacyNotice = false;
  bool _tos_1 = false;
  bool _tos_2 = false;
  bool _tos_3 = false;
  bool _guidelines = false;

  bool _sms = false;
  bool _call = false;
  bool _email = false;
  bool _pushnotifs = false;
  bool _chatapps = false;

  bool _decl_1 = false;
  bool _decl_2 = false;
  bool _decl_3 = false;
  bool _decl_4 = false;
  bool _decl_5 = false;
  bool _decl_6 = false;
  bool _decl_7 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(titleText: 'Application'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Consents
              Text(
                'Consents',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10),
              Text(
                  '''By proceeding, I acknowledge that my personal data will be processed for my application (including to conduct background checks, to link my accounts held with kayakita, to apply for and manage my wallets with kayakita, and for any other related purposes). I further acknowledge that by submitting my application, I have read, understood and agree to kayakita’s:'''),
              SizedBox(height: 10),
              LabeledCheckbox(
                label: 'Privacy Notice',
                value: _privacyNotice,
                onChanged: (value) {
                  setState(() {
                    _privacyNotice = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Terms of Service: Transport, Delivery, and Logistics',
                value: _tos_1,
                onChanged: (value) {
                  setState(() {
                    _tos_1 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Terms of Service: Payments and Rewards',
                value: _tos_2,
                onChanged: (value) {
                  setState(() {
                    _tos_2 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Terms of Service: Family Account',
                value: _tos_3,
                onChanged: (value) {
                  setState(() {
                    _tos_3 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Rider Guidelines',
                value: _guidelines,
                onChanged: (value) {
                  setState(() {
                    _guidelines = value;
                  });
                },
              ),

              SizedBox(height: 30),
              Text(
                'Offers from KayaKita',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10),
              Text(
                  '''I would like to be contacted for promotions, events, and other marketing purposes via:'''),
              SizedBox(height: 10),

              LabeledCheckbox(
                label: 'SMS',
                value: _sms,
                onChanged: (value) {
                  setState(() {
                    _sms = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Call',
                value: _call,
                onChanged: (value) {
                  setState(() {
                    _call = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'E-mail',
                value: _email,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Push Notifications',
                value: _pushnotifs,
                onChanged: (value) {
                  setState(() {
                    _pushnotifs = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'Chat Apps (e.g. Viber, Zalo, Telegram, WhatsApp)',
                value: _chatapps,
                onChanged: (value) {
                  setState(() {
                    _chatapps = value;
                  });
                },
              ),

              SizedBox(height: 30),
              Text(
                'Declarations',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              LabeledCheckbox(
                label:
                    'My driving license has not been disqualified or suspended.',
                value: _decl_1,
                onChanged: (value) {
                  setState(() {
                    _decl_1 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'I have not been convicted in court.',
                value: _decl_2,
                onChanged: (value) {
                  setState(() {
                    _decl_2 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label: 'I am not awaiting any type of court trial against me.',
                value: _decl_3,
                onChanged: (value) {
                  setState(() {
                    _decl_3 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label:
                    'I have no medical condition that would make me unfit to do my work safely.',
                value: _decl_4,
                onChanged: (value) {
                  setState(() {
                    _decl_4 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label:
                    'I agree that kayakita may top up (or add to) and claw back (or deduct from) my cash wallet and credit wallet for any kayakita-related transactions.',
                value: _decl_5,
                onChanged: (value) {
                  setState(() {
                    _decl_5 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label:
                    'I consent to kayakita using my personal data (including my government-issued ID, profile information, and status) to: offer financial products and services, conduct background checks, link my personal data between my kayakita SP app and kayakita Customer app (if I have one), and carry out reasonable actions in line with the Kayakita privacy policy.',
                value: _decl_6,
                onChanged: (value) {
                  setState(() {
                    _decl_6 = value;
                  });
                },
              ),
              LabeledCheckbox(
                label:
                    'I understand that in upgrading my rider cash wallet, it will be linked to the Kayakita Wallet of my Kayakita SP app. If I do not have a Kayakita Wallet, I may need to sign up to obtain one.',
                value: _decl_7,
                onChanged: (value) {
                  setState(() {
                    _decl_7 = value;
                  });
                },
              ),

              // Continue button
              SizedBox(height: 60),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // You can add navigation logic here if needed
                  },
                  child: Text(
                    'Continue',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

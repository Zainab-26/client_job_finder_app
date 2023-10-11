import 'package:client_cp_final/components/button.dart';
import 'package:client_cp_final/components/textfield.dart';
import 'package:client_cp_final/pages/nav.dart';
import 'package:client_cp_final/pages/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_model.dart';

class editBillingInfo extends StatefulWidget {
  const editBillingInfo({super.key});

  @override
  State<editBillingInfo> createState() => _editBillingInfoState();
}

class _editBillingInfoState extends State<editBillingInfo> {
  final cardController = TextEditingController();
  final nameController = TextEditingController();
  final expiryController = TextEditingController();
  final securityController = TextEditingController();

  String errorMessage = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> loadBillingInfo() async {
    String? currentUser = FirebaseAuth.instance.currentUser!.uid;
    print(currentUser);

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Billing_Information')
        .doc(currentUser)
        .get();
    print('User snapshot: ${snapshot.data()}');

    if (snapshot.exists && snapshot.data() != null) {
      String name = snapshot.get('Name');
      String cardNumber = snapshot.get('Card_number');
      String expiryDate = snapshot.get('Expiry_date');
      String cvv = snapshot.get('Security_code');

      setState(() {
        nameController.text = name;
        cardController.text = cardNumber;
        expiryController.text = expiryDate;
        securityController.text = cvv;
      });

      print(name);
    } else {
      print('ERROR MATE!');
    }
  }

  @override
  void initState() {
    super.initState();
    loadBillingInfo();
  }

  @override
  void dispose() {
    nameController.dispose();
    cardController.dispose();
    expiryController.dispose();
    securityController.dispose();
    super.dispose();
  }

  String? currentUser = FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveBillingInfo() async {
    final CollectionReference billingCollection =
        FirebaseFirestore.instance.collection('Billing_Information');

    String cardNumber = cardController.text.trim();
    String name = nameController.text.trim();
    String expiry = expiryController.text.trim();
    String cvv = securityController.text.trim();

    billingCollection
        .doc(currentUser)
        .set({
          'Card_number': cardNumber,
          'Name': name,
          'Expiry_date': expiry,
          'Security_code': cvv,
        })
        .then((value) => print('Billing information saved'))
        .catchError(
            (error) => print('Failed to save billing information: $error'));
  }

  @override
  Widget build(BuildContext context) {
    cardController.text = cardController.text;
    nameController.text = nameController.text;
    expiryController.text = expiryController.text;
    securityController.text = securityController.text;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.portrait_sharp),
        title: const Text('Billing Information'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            CreditCardWidget(
              cardNumber: cardController.text,
              expiryDate: expiryController.text,
              cardHolderName: nameController.text,
              cvvCode: securityController.text,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            CreditCardForm(
              formKey: _formKey,
              obscureCvv: true,
              obscureNumber: true,
              cardHolderName: nameController.text,
              cardNumber: cardController.text,
              cvvCode: securityController.text,
              expiryDate: expiryController.text,
              themeColor: Colors.deepPurple,
              onCreditCardModelChange: (CreditCardModel? creditCardModel) {
                setState(() {
                  cardController.text = creditCardModel!.cardNumber;
                  nameController.text = creditCardModel.cardHolderName;
                  expiryController.text = creditCardModel.expiryDate;
                  securityController.text = creditCardModel.cvvCode;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            button(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final String cardNumber =
                        cardController.text.trim().replaceAll(' ', '');
                    final String name = nameController.text.trim();
                    final String expiry =
                        expiryController.text.trim().replaceAll(' ', '');
                    final String cvv = securityController.text.trim();

                    final List<String> expirySplit = expiry.split('/');
                    final int month = int.parse(expirySplit[0]);
                    final int year = int.parse('20${expirySplit[1]}');

                    print('valid');
                    saveBillingInfo();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const profile()),
                    );
                  }
                },
                text: 'Save')
          ],
        ),
      )),
    );
  }
}

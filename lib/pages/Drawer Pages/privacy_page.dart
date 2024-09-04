import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color.fromRGBO(67, 67, 67, 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "D4media Privacy Policy Statement",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildSection(
              "Introduction",
              "The D4media (Dharmadhara Division for Digital Media), Kerala, India (referred to as \"D4media\", \"we\", \"us\" and \"our\") takes individuals' privacy seriously. This Statement explains our policies and practices and applies to information collection and use including but not limited to while you are visiting and using www.d4media.in (the \"Site\") and our Apps.\n\n"
                  "For the purposes of the relevant data protection laws in force in places including but not limited to India, D4media, is controller and/or data user which control the collection, holding, processing or use of your personal data on our behalf. This Statement is privacy policy for the Site and our Apps.",
              textColor,
            ),
            _buildSection(
              "1. Collection of Data",
              "We may collect and process the following information about you:\n\n"
                  "• information (such as your name, email address, mailing address, phone number, date of birth, photograph, identification document number, credit card information) that you provide by completing forms on the Site, including if you register as a user of the Site, subscribe to our newsletter, upload or submit any material through the Site, request any information, or enter into any transaction on or through the Site;\n"
                  "• in connection with an account sign-in facility, your log-in and password details;\n"
                  "• details of any transactions made by you through the Site;\n"
                  "• communications you send to us, for example to report a problem or to submit queries, concerns or comments regarding the Site or its content; and\n"
                  "• information from surveys that we may, from time to time, run on the Site for research purposes, if you choose to respond to, or participate in, them.\n\n"
                  "You are under no obligation to provide any such information. However, if you should choose to withhold requested information, we may not be able to provide you with certain services.",
              textColor,
            ),
            _buildSection(
              "2. Uses of Data",
              "We use information held about you in the following ways:\n\n"
                  "• to ensure that content from our site is presented in the most effective manner for you and for your computer;\n"
                  "• to provide you with information, products or services that you request from us or which we feel may interest you, where you have consented to be contacted for such purposes;\n"
                  "• to carry out our obligations arising from any contracts entered into between you and us;\n"
                  "• to allow you to participate in interactive features of our service, when you choose to do so;\n"
                  "• to notify you about changes to our service;\n"
                  "• to improve our products and services and to ensure that they are relevant to you;\n"
                  "• for system administration purposes and for internal operations, including troubleshooting, data analysis, testing, research, statistical and survey purposes;\n"
                  "• for the purpose of processing transactions, including processing credit card transactions;\n"
                  "• to deliver our newsletters to you;\n"
                  "• to send you information we think you may find useful or which you have requested from us, including information about our products and services or those of carefully selected third parties, provided you have indicated that you do not object to being contacted for these purposes;\n"
                  "• for the purpose of providing information to third parties who provide specific services to us; and\n"
                  "• subject to your consent, to notify you of products or special offers that may be of interest to you.",
              textColor,
            ),
            _buildSection(
              "3. Disclosure of Data",
              "We will keep your personal data we hold confidential but you agree we may provide information to:\n\n"
                  "• any member of our group, which means our subsidiaries, our ultimate holding company and its subsidiaries, as defined in section 15 of the Companies Act, 1956\n"
                  "• personnel, agents, advisers, auditors, contractors, financial institutions, and service providers in connection with our operations or services (for example staff engaged in the fulfillment of your order, the processing of your payment and the provision of support services)\n"
                  "• our overseas offices, affiliates, business partners and counterparts (on a need-to-know basis only)\n"
                  "• persons under a duty of confidentiality to us\n"
                  "• persons to whom we are required to make disclosure under applicable laws in or outside India\n"
                  "• actual or proposed transferees or participants of our services\n"
                  "• parties or entities from whom we receive subsidies or special funding support for audit purpose\n\n"
                  "We may provide your personal data as required or permitted by law to comply with a summons, subpoena or similar legal process or government request, or when we believe in good faith that disclosure is legally required or otherwise necessary to protect our rights and property, or the rights, property or safety of others, including but not limited to advisers, law enforcement, judicial and regulatory authorities in or outside India. We may also transfer your personal data to a third party that acquires all or part of our assets or shares, or that succeeds us in carrying on all or a part of our business, whether by merger, acquisition, reorganisation or otherwise.\n\n"
                  "To prevent and detect crimes and to protect the security and safety of our events and trade fairs, we may provide your personal identification data such as your full passport/identity card no., date of birth and nationality to the law enforcement authorities in India including the India Police Force, Immigration Department, Customs and Excise Department and other similar authorities upon their lawful request (but not to any other third party save as expressly specified below).\n\n"
                  "We may also provide your passport or identity card number to personnel, agents, auditors, contractors and service providers in connection with the organisation of our events, persons under a duty of confidentiality to us and /or persons to whom we are required to make disclosure under applicable laws in or outside India.",
              textColor,
            ),
            _buildSection(
              "4. Cookies",
              "Cookies are small, sometimes encrypted text files that are stored on computer hard drives by websites that you visit. They are used to help you to navigate on websites efficiently as well as to provide information to the owner of the website. Cookies do not contain any software programs. There are two general types of cookies, session cookies and persistent cookies. Session cookies are only used during a session online and will be deleted once you leave a website. Persistent cookies have a longer life and will be retained by the website and used each time you visit a website. Both session and persistent cookies can be deleted by you at anytime through your browser settings and in any event, will not be kept longer than necessary.\n\n"
                  "We use cookies to find out more about the use of our Site and user preferences to improve our services. We may provide summarised traffic data to advertisers solely for the purpose of customising the advertising to you. We note traffic, pages visited and time spent. We store your shopping cart and wish list for your later use. We may link the information to you, so that you may receive information more suited to your interests.\n\n"
                  "Web browsers often allow you to erase existing cookies from your hard drive, block the use of cookies and/or be notified when cookies are encountered. If you elect to block cookies, please note that you may not be able to take full advantage of the features and functions of the Site. Cookies are necessary for some features of the website to work, e.g., to maintain continuity during a browser session.\n\n"
                  "We use an email delivery and marketing company to send emails that you have agreed to receive. Pixels tags and cookies are used in those emails and at our Site to help us measure the effectiveness of our advertising and how visitors use our web site.\n\n"
                  "We use a third-party advertising company to serve ads when you visit our Site. This company may use information (not including your name, address, email address or telephone number) about your visit to this Site in order to provide advertisements about goods and services that may be of interest to you. In the course of serving advertisements to this site, our third-party advertiser may place or recognise a unique \"cookie\" on your browser. If you would like more information about this practice and to know your choices about not having this information used by this company, please refer to the cookie policy of respective company directly.",
              textColor,
            ),
            _buildSection(
              "5. Security",
              "Personal data stored electronically are password-protected. Encryption technology is used on our secured web areas. Our computer systems are placed in restricted areas. We only permit authorised employees to access personal data. These employees are trained on our privacy policies.",
              textColor,
            ),
            _buildSection(
              "6. Hyperlinks",
              "The Site may, from time to time, contain links to external sites operated by third parties for your convenience. We have no control of and are not responsible for these third party sites or the content thereof. Once you leave the Site, we cannot be responsible for the protection and privacy of any information which you provide to these third party sites. You should exercise caution and look at the privacy statement for the website you visit.",
              textColor,
            ),
            _buildSection(
              "7. Changes",
              "We may update this Statement. When we do, the changes will be posted on www.d4media.in/privacy-policy/.",
              textColor,
            ),
            _buildSection(
              "8. Data transfers",
              "We will generally hold your data on our servers hosted in India. However, we may transfer it to elsewhere in the world for the purpose of processing into our database or to any of the people listed at paragraph 3 above, who may be located elsewhere. If you are located in the European Economic Area (\"EEA\") /\"UK\" your personal data may be transferred to countries located outside the EEA /\"UK\" which do not provide a similar or adequate level of protection to that provided by countries in the EEA /\"UK\". Such transfers will only be made in accordance with applicable laws including where necessary for us to comply with our contractual obligations with you. We will take all steps reasonably necessary to ensure that any personal data are treated securely and in accordance with this Statement.",
              textColor,
            ),
            _buildSection(
              "9. Your data privacy rights",
              "By using our service, making an application or visiting our Site, you acknowledge the collection and use of your personal data by us as outlined in this Statement. If you do not agree with the use of your personal data as set out in this Statement, please do not use this Site or our Apps.\n\n"
                  "If you wish to exercise one of the above mentioned rights, cease marketing communications, and/or raise questions or complaints please contact us at:\n\n"
                  "Data Privacy Officer\n"
                  "D4media\n"
                  "Hira Centre, Mavoor Road, Kozhikode, Kerala, India\n",
              textColor,
            ),
            _buildContactInfo(context, textColor),
            const SizedBox(height: 24),
            Text(
              "Last updated on 10-02-2024",
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "© 2022 D4Media",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(color: textColor),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _launchPhone('4952724881'),
          child: const Text(
            "Tel: (495) 2724881",
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _launchEmail('contact@D4media.in'),
          child: const Text(
            "E-mail: contact@D4media.in",
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch $phoneUri');
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint('Could not launch $emailUri');
    }
  }
}

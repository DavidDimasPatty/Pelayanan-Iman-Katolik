import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:pelayanan_iman_katolik/view/homePage.dart';

import '../profile/profile.dart';
import '../tiketSaya.dart';

class termsCondition extends StatelessWidget {
  final name;
  final email;
  final idUser;
  termsCondition(this.name, this.email, this.idUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(name, email, idUser)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10),
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
            'Terms and Conditions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
              'These terms and conditions outline the rules and regulations for the use of Company Names Website, located at Website.com.'),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text(
              'By accessing this website we assume you accept these terms and conditions. Do not continue to use Website Name if you do not agree to take all of the terms and conditions stated on this page.'),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text(
              "The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person log on this website and compliant to the Company's terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client's needs in respect of provision of the Company's stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same."),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
            "Cookies",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
              "We employ the use of cookies. By accessing Website Name, you agreed to use cookies in agreement with the Company Name's Privacy Policy."),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text(
              "Most interactive websites use cookies to let us retrieve the user's details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies."),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Text(
              "Most interactive websites use cookies to let us retrieve the user's details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies"),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
            "License",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text("Unless otherwise stated, Company Name and/or its licensors own the intellectual property rights for all material on Website Name. All intellectual property rights are reserved. You may access this from Website Name for your own personal use subjected to restrictions set in these terms and conditions." +
              "\nYou must not: \n\n-Republish material from Website Name \n\n-Sell, rent or sub-license material from Website Name \n\n -Reproduce, duplicate or copy material from Website Name Redistribute content from Website Name \n\nThis Agreement shall begin on the date hereof." +
              "Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Company Name does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Company Name,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Company Name shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website." +
              "Company Name reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions." +
              "You warrant and represent that: \n\n"
                  "-You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;" +
              "\n\nThe Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;" +
              "\n\n-The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy" +
              "\n\n-The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity."),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
            "Hyperlinking to our Content",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text("The following organizations may link to our Website without prior written approval: \n\n-Government agencies;"
                  "\n\n-Search engines;" +
              "\n\n-News organizations;" +
              "\n\n-Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and" +
              "\n\n-System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site." +
              "\n\nThese organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party's site." +
              "\n\nWe may consider and approve other link requests from the following types of organizations:" +
              "\n\n-commonly-known consumer and/or business information sources;" +
              "\n\n-dot.com community sites;" +
              "\n\n-associations or other groups representing charities;" +
              "\n\n-online directory distributors;" +
              "\n\n-internet portals;" +
              "\n\n-accounting, law and consulting firms; and"
                  "\n\n-educational institutions and trade associations."
                  "\n\nWe will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Company Name; and (d) the link is in the context of general resource information."
                  "\n\nThese organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party's site."
                  "\n\nIf you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Company Name. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response."
                  "\n\nApproved organizations may hyperlink to our Website as follows:"
                  "\n\n-By use of our corporate name; or"
                  "\n\n-By use of the uniform resource locator being linked to; or"
                  "\n\n-By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party's site."
                  "\n\n-No use of Company Name's logo or other artwork will be allowed for linking absent a trademark license agreement."),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
            "iFrames",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
              "Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website."),
          Text("Content Liability"),
          Text(
              "We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights."),
          Text("Reservation of Rights"),
          Text(
              "We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it's linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions."),
          Text("Removal of links from our website"),
          Text(
              "If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly."
              "\n\nWe do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date."),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
            "Disclaimer",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Text(
              "To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:"
              "\n\n-limit or exclude our or your liability for death or personal injury;"
              "\n\n-limit or exclude our or your liability for fraud or fraudulent misrepresentation;"
              "\n\n-limit any of our or your liabilities in any way that is not permitted under applicable law; or"
              "\n\n-exclude any of our or your liabilities that may not be excluded under applicable law."
              "\n\nThe limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty."
              "\n\nAs long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature."),
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        ],
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.blue,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Jadwalku",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => tiketSaya(name, email, idUser)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(name, email, idUser)),
                  );
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          openCamera();
        },
        tooltip: 'Increment',
        child: new Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}

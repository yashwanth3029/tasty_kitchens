import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(0xFF333333),
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ccbp-logo-img.png',
                height: 30,
                color: Colors.white,
                semanticLabel: 'website-footer-logo',
              ),
              SizedBox(width: 8),
              Text(
                'Tasty Kitchens',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'The only thing we are serious about is food.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            'Contact us on',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.pinterest, color: Colors.white, size: 24),
              SizedBox(width: 24),
              FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 24),
              SizedBox(width: 24),
              FaIcon(FontAwesomeIcons.twitter, color: Colors.white, size: 24),
              SizedBox(width: 24),
              FaIcon(FontAwesomeIcons.facebook, color: Colors.white, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}

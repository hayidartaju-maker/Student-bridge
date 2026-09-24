import 'package:flutter/material.dart';

class BrowserMockupScreen extends StatelessWidget {
  const BrowserMockupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 420,
              child: Column(
                children: const [
                  _BrowserTopBar(),
                  SizedBox(height: 18),
                  _PageCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrowserTopBar extends StatelessWidget {
  const _BrowserTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF202327),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          const Icon(Icons.home_outlined, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 36,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: const [
                  Icon(Icons.lock_outline, color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'school.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(Icons.add, color: Colors.white, size: 28),
          const SizedBox(width: 14),
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 28),
              Positioned(
                right: 0,
                top: 2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Center(
                    child: Text(
                      '38',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Icon(Icons.more_vert, color: Colors.white, size: 26),
        ],
      ),
    );
  }
}

class _PageCard extends StatelessWidget {
  const _PageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2FA6E3), Color(0xFF2A9FE4)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'School.com',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 8, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Text(
                              'Home',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF454A4E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '>',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8C8F91),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Welcome to School.com (alpha version). We are redesigning this site. Please check back with us soon.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3338),
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'We appreciate your input. Please contact us if you have any suggestions as we build out this site, or if you would like to be dismissed with us.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3338),
                            height: 1.5,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '© 2025 School.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF858B8F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14, top: 12),
                  child: SizedBox(
                    width: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2A2E31),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Jobs',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2A2E31),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2A2E31),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Privacy',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2A2E31),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

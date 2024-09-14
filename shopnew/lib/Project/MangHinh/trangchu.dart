import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'itemlikeScreen.dart'; // Đổi từ ProductDetailScreen thành itemlikeScreen
import 'login.dart';
import 'nensanpham.dart';
import 'profile.dart';

class Trangchu extends StatefulWidget {
  final bool isAuthenticated;

  Trangchu({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  State<Trangchu> createState() => _TrangchuState();
}

class _TrangchuState extends State<Trangchu> {
  int _selectedIndex = 0;

  // Danh sách các màn hình
  static final List<Widget> _widgetOptions = <Widget>[
    Nensanpham(),
    Container(), // Đặt hàng
    ItemLikeScreen(), // Thay thế ProductDetailScreen bằng itemlikeScreen
    Profile(), // Người dùng
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Mew mew shop')),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // Nếu đã đăng nhập, hiển thị trang Profile
              if (widget.isAuthenticated) {
                setState(() {
                  _selectedIndex = 3; // Index của tab "Người dùng"
                });
              } else {
                // Nếu chưa đăng nhập, chuyển đến trang đăng nhập
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => LoginPage()),
                  ),
                );
              }
            },
            tooltip: 'Login',
            icon: const Icon(Icons.boy_outlined),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 25,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(microseconds: 400),
              tabBackgroundColor: Colors.redAccent,
              tabs: [
                GButton(icon: LineIcons.home, text: 'Trang chủ'),
                GButton(icon: LineIcons.shoppingBag, text: 'Đặt hàng'),
                GButton(icon: LineIcons.heart, text: 'Giỏ hàng'),
                GButton(
                  icon: LineIcons.user,
                  text: 'Người dùng',
                  onPressed: () {
                    // Đảm bảo rằng người dùng đã đăng nhập trước khi chuyển đến trang Profile
                    if (widget.isAuthenticated) {
                      setState(() {
                        _selectedIndex = 3; // Index của tab "Người dùng"
                      });
                    }
                  },
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
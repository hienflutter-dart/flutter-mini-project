import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavoriteProvider.dart';
import 'Trangsanpham.dart';
import '../Checkdata/data.dart';

class ItemLikeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy danh sách các sản phẩm yêu thích từ Provider
    List<String> favoriteItems = Provider.of<FavoriteProvider>(context).favorites;
    // Tạo một danh sách chứa thông tin về tất cả các sản phẩm
    List<List<String>> allProducts = [Munchkin, Ragdoll, Bengal, Persian];
    // Khởi tạo một instance của Helper class
    final helper = Helper();

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sản phẩm yêu thích'),
      ),
      body: ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          // Tìm thông tin về sản phẩm yêu thích
          var product = helper.a(favoriteItems[index], allProducts);
          if (product != null) {
            return InkWell(
              onTap: () {
                // Chuyển đến trang chi tiết sản phẩm khi người dùng nhấn vào
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Trangsanpham(
                      mew: product, // Truyền thông tin về sản phẩm
                      isFavorite: true, // Đánh dấu sản phẩm là yêu thích
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'images/${favoriteItems[index]}.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Mèo " + favoriteItems[index], // Hiển thị tên sản phẩm
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Trả về một widget trống nếu sản phẩm không tồn tại
            return Container();
          }
        },
      ),
    );
  }
}

// Helper class để thực hiện các tác vụ hỗ trợ
class Helper {
  // Phương thức để tìm kiếm thông tin về sản phẩm
  List<String>? a(String b, List<List<String>> allProducts) {
    for (var item in allProducts) {
      if (item[2] == b) { // So sánh tên sản phẩm với tên truyền vào
        return item; // Trả về thông tin về sản phẩm nếu tìm thấy
      }
    }
    return null; // Trả về null nếu không tìm thấy sản phẩm
  }
}
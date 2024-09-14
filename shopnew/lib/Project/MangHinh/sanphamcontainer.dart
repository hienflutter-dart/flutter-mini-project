import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavoriteProvider.dart';
import 'Trangsanpham.dart';

class MewShop extends StatelessWidget {
  final List<String> hint; // Danh sách thông tin gợi ý về sản phẩm

  MewShop({required this.hint}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>( // Sử dụng Consumer để lắng nghe thay đổi trong FavoriteProvider
      builder: (context, favoriteProvider, _) {
        bool isFavorite = favoriteProvider.favorites.contains(hint[2]); // Kiểm tra xem sản phẩm này có trong danh sách yêu thích không

        return InkWell( // InkWell để thêm hiệu ứng nhấp nháy khi nhấn
          onTap: () {
            // Chuyển đến trang chi tiết sản phẩm khi nhấn vào
            Navigator.push(context, MaterialPageRoute(builder: (context) => Trangsanpham(mew: hint, isFavorite: isFavorite)));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black26,
              border: Border.all(width: 3.0, color: Colors.black45),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sản phẩm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: isFavorite ? Colors.redAccent : Colors.white), // Biểu tượng yêu thích
                        onPressed: () {
                          favoriteProvider.toggleFavorite(hint[2]); // Chuyển đổi trạng thái yêu thích khi nhấn
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "images/${hint[2]}.jpg",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hint[0], // Tên sản phẩm
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              hint[1], // Giá sản phẩm
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
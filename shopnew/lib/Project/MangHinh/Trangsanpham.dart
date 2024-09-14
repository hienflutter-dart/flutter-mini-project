import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'CartProvider.dart';
import 'Item.dart';

class Trangsanpham extends StatelessWidget {
  final List<String> mew;
  final bool isFavorite; // Nhận giá trị yêu thích từ MewShop

  Trangsanpham({Key? key, required this.mew, required this.isFavorite}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Color(0xFFD4ECF7),
            ),
            child: Stack(
              children: [
                Center(
                  child: Item(sp: mew),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mew[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          RatingBar.builder(
                            initialRating: 3.6,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25,
                            itemBuilder: (context, _) =>
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Text(
                      mew[1],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      mew[3],
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                // Thêm sản phẩm vào giỏ hàng ở đây
                // Để đơn giản, hãy giả sử rằng mew[0] là ID của sản phẩm
                Provider.of<CartProvider>(context, listen: false).addToCart(mew[0]);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.redAccent
                ),
                child: const Center(
                  child: Text(
                    "Thêm vào giỏ hàng",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
                 InkWell(
                  onTap: () {
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFD4ECF7),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite_outline,
                        color: isFavorite ? Colors.redAccent : Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )
          ]
        ),
      ),
    );
  }
}
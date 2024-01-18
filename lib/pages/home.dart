import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('Search button pressed');
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Implement actions for each menu item
              if (value == 'settings') {
                // Handle settings action
                print('Settings selected');
              } else if (value == 'about') {
                // Handle about action
                print('About selected');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('contact'),
                ),
                PopupMenuItem<String>(
                  value: 'about',
                  child: Text('sign-out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(children: [
          _buildImageRow([
            ImageData('assets/images/1.webp', 'Price: \$ 241', 'Quantity: 74'),
            ImageData('assets/images/4.webp', 'Price: \$ 250', 'Quantity: 10'),
          ]),
          _buildImageRow([
            ImageData('assets/images/6.webp', 'Price: \$ 110', 'Quantity: 6'),
            ImageData('assets/images/7.webp', 'Price: \$ 360', 'Quantity: 15'),
          ]),
          _buildImageRow([
            ImageData('assets/images/8.webp', 'Price: \$ 420', 'Quantity: 9'),
            ImageData('assets/images/1.webp', 'Price: \$ 180', 'Quantity: 4'),
          ]),
        ]),
      ),
    );
  }

  Widget _buildImageRow(List<ImageData> images) {
    return Row(
      children: images.map((imageData) {
        return Expanded(
          child: Column(
            children: [
              Image.asset(
                imageData.imagePath,
                fit: BoxFit.cover,
                height: 150, // Adjust the height here
              ),
              Text(imageData.price),
              Text(imageData.quantity),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ImageData {
  final String imagePath;
  final String price;
  final String quantity;

  ImageData(this.imagePath, this.price, this.quantity);
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

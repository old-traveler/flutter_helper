import 'package:flutter/cupertino.dart';
import 'package:flutter_helper/res/strings.dart';

class MultiplePictureWidget extends StatelessWidget {
  final List<String> _imageUrls;
  final Size _imageSize;

  MultiplePictureWidget(this._imageUrls, this._imageSize);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: _imageUrls == null || _imageUrls.isEmpty,
      child: _getStatementImage(_imageUrls),
    );
  }

  Widget _getStatementImage(List<String> images) {
    if (images.length == 1) {
      return Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: Image.network(
            YStrings.baseImageUrl + images[0],
            alignment: Alignment.topLeft,
          ));
    }
    List<Widget> imageWidgets = new List();
    for (var value in images) {
      imageWidgets.add(
        _getStatementItemImage(value),
      );
    }
    return Padding(
      padding: EdgeInsets.all(10),
      child: Wrap(
        spacing: 3.0,
        runSpacing: 3.0,
        children: imageWidgets,
      ),
    );
  }

  Widget _getStatementItemImage(String value) {
    return Image.network(
      YStrings.baseImageUrl + value,
      fit: BoxFit.cover,
      width: _imageSize.width,
      height: _imageSize.height,
      alignment: Alignment.topLeft,
    );
  }
}

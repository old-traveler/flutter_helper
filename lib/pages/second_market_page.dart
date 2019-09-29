import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/api/net_api.dart';
import 'package:flutter_helper/base/base_page_state.dart';
import 'package:flutter_helper/base/base_result_model.dart';
import 'package:flutter_helper/entity/second_goods_entity.dart';
import 'package:flutter_helper/http/http_manager.dart';
import 'package:flutter_helper/res/strings.dart';

class SecondMarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecondMarketPageState();
  }
}

class _SecondMarketPageState
    extends BaseRefreshState<SecondMarketPage, SecondGoodsGood> {
  Widget _getItemWidget(BuildContext context, int index) {
    double width = (MediaQuery.of(context).size.width - 5) / 2;
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1))),
      child: Column(
        children: <Widget>[
          Image.network(
            YStrings.baseImageUrl + getItemData(index).image,
            fit: BoxFit.cover,
            height: width,
            width: width,
          ),
          _getGoodsInfo(index),
        ],
      ),
    );
  }

  Widget _getGoodsInfo(int index) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white.withOpacity(0.1),
          height: 50,
        ),
        Positioned(
          left: 5,
          top: 5,
          child: Text(
            getItemData(index).tit,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontFamily: 'mononoki'),
            maxLines: 2,
            textAlign: TextAlign.left,
          ),
        ),
        Positioned(
          left: 5,
          top: 30,
          child: Text(
            "¥ " + getItemData(index).prize,
            style: TextStyle(fontSize: 15, color: Colors.redAccent),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
        ),
        Positioned(
          right: 5,
          top: 30,
          child: Text(
            getItemData(index).createdOn,
            style: TextStyle(fontSize: 10, color: Colors.grey),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  getResponse(int _page) {
    return HttpManager.getInstance().get(NetApi.SECOND_GOODS_URL + "$_page/0");
  }

  @override
  List<Widget> getSlivers() {
    return <Widget>[
      SliverGrid(
        delegate:
            // ignore: missing_return
            SliverChildBuilderDelegate((BuildContext context, int index) {
          return _getItemWidget(context, index);
        }, childCount: getItemCount()),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.77,
        ),
      )
    ];
  }

  @override
  BasePageResult<SecondGoodsGood> jsonToResult(json) {
    SecondGoodsEntity entity = SecondGoodsEntity.fromJson(json);
    return entity == null
        ? null
        : BasePageResult(entity.code, null, entity.goods,
            entity.currentPage >= entity.pageination);
  }
}

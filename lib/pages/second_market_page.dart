import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_helper/api/net_api.dart';
import 'package:flutter_helper/entity/second_goods_entity.dart';
import 'package:flutter_helper/http/http_manager.dart';
import 'package:flutter_helper/res/strings.dart';
import 'package:flutter_helper/utils/toast_util.dart';

class SecondMarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecondMarketPageState();
  }
}

class _SecondMarketPageState extends State<SecondMarketPage> with AutomaticKeepAliveClientMixin{
  EasyRefreshController _controller;
  List<SecondGoodsGood> _secondGoods;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _onRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      controller: _controller,
      header: PhoenixHeader(),
      footer: ClassicalFooter(),
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      onRefresh: _onRefresh,
      onLoad: _fetchSecondGoods,
      slivers: <Widget>[
        SliverGrid(
          delegate:
              // ignore: missing_return
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return _getItemWidget(context, index);
          }, childCount: _secondGoods == null ? 0 : _secondGoods.length),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.77,
          ),
        )
      ],
    );
  }

  Future _onRefresh() async {
    _page = 1;
    _fetchSecondGoods();
  }

  Future _fetchSecondGoods() async {
    var response = await HttpManager.getInstance()
        .get(NetApi.SECOND_GOODS_URL + "$_page/0");
    if (response == null) {
      ToastUtil.show(context: context, msg: "网络不给力");
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false);
      return;
    }
    SecondGoodsEntity entity =
        SecondGoodsEntity.fromJson(json.decode(response.toString()));
    if (entity.code == HttpStatus.ok) {
      setState(() {
        if (_page == 1) {
          _secondGoods = List();
          _controller.finishRefresh(
              success: true, noMore: entity.currentPage >= entity.pageination);
        } else {
          _controller.finishLoad(
              success: true, noMore: entity.currentPage >= entity.pageination);
        }
        _secondGoods.addAll(entity.goods);
        _page++;
      });
    }
  }

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
            YStrings.baseImageUrl + _secondGoods[index].image,
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
            _secondGoods[index].tit,
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
            "¥ " + _secondGoods[index].prize,
            style: TextStyle(fontSize: 15, color: Colors.redAccent),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
        ),
        Positioned(
          right: 5,
          top: 30,
          child: Text(
            _secondGoods[index].createdOn,
            style: TextStyle(fontSize: 10, color: Colors.grey),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

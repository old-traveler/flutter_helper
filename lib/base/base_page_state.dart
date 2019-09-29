import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_helper/utils/toast_util.dart';

import 'base_result_model.dart';

abstract class BaseRefreshState<P extends StatefulWidget, D> extends State<P>
    with AutomaticKeepAliveClientMixin {
  EasyRefreshController _controller;
  List<D> _dataList;
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

  Future _onRefresh() async {
    _page = 1;
    _getDataFromHttp();
  }

  Future _getDataFromHttp() async {
    var response = await getResponse(_page);
    if (response == null) {
      ToastUtil.show(context: context, msg: "网络不给力");
      finishLoad(false);
      return;
    }
    BasePageResult<D> result = jsonToResult(json.decode(response.toString()));
    if (result == null) {
      ToastUtil.show(context: context, msg: "json解析失败");
      finishLoad(false);
    } else if (result.code == HttpStatus.ok) {
      setState(() {
        finishLoad(true, noMore: result.noMore);
        if (_page == 1) {
          _dataList = List();
        }
        _dataList.addAll(result.data);
        _page++;
      });
    } else if (result.msg.isNotEmpty) {
      ToastUtil.show(context: context, msg: result.msg);
      finishLoad(false);
    } else {
      int code = result.code;
      ToastUtil.show(context: context, msg: "服务器异常-$code");
      finishLoad(false);
    }
  }

  finishLoad(bool success, {bool noMore}) {
    if (_page == 1) {
      _controller.finishRefresh(success: success, noMore: noMore);
    } else {
      _controller.finishLoad(success: success, noMore: noMore);
    }
  }

  getResponse(int _page);

  BasePageResult<D> jsonToResult(dynamic json);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.custom(
      controller: _controller,
      header: PhoenixHeader(),
      footer: ClassicalFooter(),
      enableControlFinishLoad: true,
      enableControlFinishRefresh: true,
      onRefresh: _onRefresh,
      onLoad: _getDataFromHttp,
      slivers: getSlivers(),
    );
  }

  List<Widget> getSlivers();

  int getItemCount() {
    return _dataList == null ? 0 : _dataList.length;
  }

  D getItemData(int index) {
    if (index >= 0 && index < getItemCount()) {
      return _dataList[index];
    } else {
      return null;
    }
  }
}

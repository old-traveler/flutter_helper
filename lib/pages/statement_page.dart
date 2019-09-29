import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_helper/api/net_api.dart';
import 'package:flutter_helper/entity/statement_entity.dart';
import 'package:flutter_helper/http/http_manager.dart';
import 'package:flutter_helper/res/strings.dart';
import 'package:flutter_helper/utils/toast_util.dart';

class StatementPage extends StatefulWidget {
  final String number;

  StatementPage(this.number);

  @override
  State<StatefulWidget> createState() {
    return _StatementPageState(number);
  }
}

class _StatementPageState extends State<StatementPage> with AutomaticKeepAliveClientMixin{
  final String number;
  EasyRefreshController _controller;

  _StatementPageState(this.number);

  List<StatemantStatemant> _statements = List();
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
    return Scaffold(
      body: EasyRefresh.custom(
          controller: _controller,
          enableControlFinishLoad: true,
          enableControlFinishRefresh: true,
          header: PhoenixHeader(),
          footer: ClassicalFooter(),
          onRefresh: _onRefresh,
          onLoad: _getStatementData,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _getItemWidget(_statements[index]);
              }, childCount: _statements.length),
            )
          ]),
    );
  }

  Future _onRefresh() async {
    _page = 1;
    _getStatementData();
  }

  Future _getStatementData() async {
    var response = await HttpManager.getInstance()
        .get(NetApi.STATEMENT_URL + '$number/$_page');
    if (response == null) {
      ToastUtil.show(context: context, msg: "网络不给力");
      _controller.finishRefresh(success: false);
      _controller.finishLoad(success: false);
      return;
    }
    StatementEntity statementEntity =
        StatementEntity.fromJson(json.decode(response.toString()));
    if (statementEntity.code == HttpStatus.ok) {
      setState(() {
        if (_page == 1) {
          _statements = List();
          _controller.finishRefresh(
              success: true,
              noMore: int.parse(statementEntity.currentPage) >=
                  statementEntity.pageination);
        } else {
          _controller.finishLoad(
              success: true,
              noMore: int.parse(statementEntity.currentPage) >=
                  statementEntity.pageination);
        }
        _statements.addAll(statementEntity.statement);
        _page++;
      });
    }
  }

  Widget _getItemWidget(StatemantStatemant statement) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(children: _getColumnWidget(statement)),
    );
  }

  List<Widget> _getColumnWidget(StatemantStatemant statement) {
    List<Widget> widget = List();
    widget.add(_getPublisherInfo(statement));
    widget.add(_getStatementContent(statement.content));
    if (statement.pics != null && statement.pics.isNotEmpty) {
      widget.add(_getStatementImage(statement.pics));
    }
    widget.add(_getOtherInfo(statement));
    if (statement.comments != null && statement.comments.isNotEmpty) {
      widget.add(_getCommentInfo(statement.comments));
    }
    return widget;
  }

  Widget _getPublisherInfo(StatemantStatemant statement) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(
          height: 55,
        ),
        Positioned(
          left: 10,
          top: 10,
          width: 45,
          height: 45,
          child: ClipOval(
            child:
                Image.network(YStrings.baseImageUrl + statement.headPicThumb),
          ),
        ),
        Positioned(
          left: 63,
          top: 13,
          child: Text(
            statement.username,
            style: TextStyle(color: Theme.of(context).primaryColor),
            textScaleFactor: 1.1,
          ),
        ),
        Positioned(
          left: 63,
          top: 35,
          child: Text(
            statement.bio != null && statement.bio.isNotEmpty
                ? statement.bio
                : "暂无签名",
            style: TextStyle(color: Colors.grey),
            textScaleFactor: 0.9,
          ),
        ),
        Positioned(
          right: 10,
          top: 13,
          child: Text(statement.createdOn,
              style: TextStyle(color: Colors.grey), textScaleFactor: 0.8),
        )
      ],
    );
  }

  Widget _getStatementContent(String content) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 10, right: 10, top: 8,bottom: 5),
      child: Text(
        content.trim(),
        style: TextStyle(letterSpacing: 1.5,fontFamily: 'mononoki'),
        textAlign: TextAlign.left,
        textScaleFactor: 1.1,
      ),
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
    if (images.length < 4) {
      List<Widget> imageWidgets = new List();
      int index = 0;
      for (var value in images) {
        imageWidgets.add(Padding(
          padding: EdgeInsets.only(left: index++ == 0 ? 10 : 2),
          child: _getStatementItemImage(value),
        ));
      }
      return Row(children: imageWidgets);
    }
    return Stack(
      children: <Widget>[
        Container(
          width: 200,
        ),
        Positioned(
          left: 10,
          top: 5,
          child: _getStatementItemImage(images[0]),
        ),
        Positioned(
          right: 10,
          top: 5,
          child: _getStatementItemImage(images[1]),
        ),
        Positioned(
          left: 10,
          top: 108,
          child: _getStatementItemImage(images[2]),
        ),
        Positioned(
          right: 10,
          top: 108,
          child: _getStatementItemImage(images[3]),
        ),
      ],
    );
  }

  Widget _getStatementItemImage(String value) {
    return Image.network(
      YStrings.baseImageUrl + value,
      fit: BoxFit.cover,
      height: 150,
      width: 150,
      alignment: Alignment.topLeft,
    );
  }

  Widget _getOtherInfo(StatemantStatemant statement) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5),
          height: 40,
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Text(
            statement.depName,
            style: TextStyle(
              color: Colors.grey,
            ),
            textScaleFactor: 0.9,
          ),
        ),
        Positioned(
          right: 10,
          top: 5,
          child: Icon(Icons.favorite_border),
        ),
        Positioned(
          right: 45,
          top: 5,
          child: Icon(Icons.insert_comment),
        ),
      ],
    );
  }

  Widget _getCommentInfo(List<StatemantStatemantCommants> comments) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 12),
        child: Align(
          alignment: Alignment.topLeft,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(text: "", children: _getCommentItemInfo(comments)),
          ),
        ));
  }

  List<TextSpan> _getCommentItemInfo(
      List<StatemantStatemantCommants> comments) {
    List<TextSpan> textSpans = List();
    int index = 0;
    for (var value in comments) {
      index++;
      textSpans.add(TextSpan(
          text: value.username.trim() + '：',
          style: TextStyle(color: Theme.of(context).primaryColor),
          recognizer: TapGestureRecognizer()..onTap = () async {}));
      textSpans.add(TextSpan(
        text: value.comment.trim() + (index < comments.length ? '\n' : ''),
        style: TextStyle(color: Colors.black),
      ));
    }
    return textSpans;
  }

  @override
  bool get wantKeepAlive => true;
}

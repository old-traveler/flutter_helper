import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/api/net_api.dart';
import 'package:flutter_helper/base/base_page_state.dart';
import 'package:flutter_helper/base/base_result_model.dart';
import 'package:flutter_helper/entity/statement_entity.dart';
import 'package:flutter_helper/http/http_manager.dart';
import 'package:flutter_helper/widget/list_personal_info_widget.dart';
import 'package:flutter_helper/widget/multiple_pictures_widget.dart';

class StatementPage extends StatefulWidget {
  final String number;

  StatementPage(this.number);

  @override
  State<StatefulWidget> createState() {
    return _StatementPageState(number);
  }
}

class _StatementPageState
    extends BaseRefreshState<StatementPage, StatemantStatemant> {
  final String number;

  _StatementPageState(this.number);

  @override
  bool get wantKeepAlive => true;

  @override
  getResponse(int _page) {
    return HttpManager.getInstance()
        .get(NetApi.STATEMENT_URL + '$number/$_page');
  }

  @override
  List<Widget> getSlivers() {
    return <Widget>[
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return _getItemWidget(getItemData(index));
        }, childCount: getItemCount()),
      )
    ];
  }

  @override
  BasePageResult<StatemantStatemant> jsonToResult(json) {
    StatementEntity statementEntity = StatementEntity.fromJson(json);
    return statementEntity == null
        ? null
        : BasePageResult(
            statementEntity.statement,
            int.parse(statementEntity.currentPage) >=
                statementEntity.pageination);
  }

  Widget _getItemWidget(StatemantStatemant statement) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getColumnWidget(statement)),
    );
  }

  List<Widget> _getColumnWidget(StatemantStatemant statement) {
    List<Widget> widget = List();
    widget.add(ListPersonalInfoWidget(
      headPic: statement.headPicThumb,
      username: statement.username,
      desc: statement.bio.isEmpty ? "暂无签名" : statement.bio,
      time: statement.createdOn,
    ));
    widget.add(_getStatementContent(statement.content));
    widget.add(MultiplePictureWidget(statement.pics, Size(170, 170)));
    widget.add(_getOtherInfo(statement));
    if (statement.comments != null && statement.comments.isNotEmpty) {
      widget.add(_getCommentInfo(statement.comments));
    }
    return widget;
  }

  Widget _getStatementContent(String content) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
      child: Text(
        content.trim(),
        style: TextStyle(letterSpacing: 1.5, fontFamily: 'mononoki'),
        textAlign: TextAlign.left,
        textScaleFactor: 1.1,
      ),
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
            text: TextSpan(
                text: "",
                children: _getCommentItemInfo(comments),
                style: TextStyle(height: 1.5)),
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
        style: TextStyle(color: Colors.black87),
      ));
    }
    return textSpans;
  }
}

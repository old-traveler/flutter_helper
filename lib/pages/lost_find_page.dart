import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/api/net_api.dart';
import 'package:flutter_helper/base/base_page_state.dart';
import 'package:flutter_helper/base/base_result_model.dart';
import 'package:flutter_helper/entity/lost_find_entity.dart';
import 'package:flutter_helper/http/http_manager.dart';
import 'package:flutter_helper/res/strings.dart';
import 'package:flutter_helper/widget/list_personal_info_widget.dart';
import 'package:flutter_helper/widget/multiple_pictures_widget.dart';

class LostFindPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LostFindPageState();
  }
}

class _LostFindPageState extends BaseRefreshState<LostFindPage, LostFindGood> {
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  List<Widget> getSlivers() {
    return <Widget>[
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Card(
              elevation: 5,
              margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: _getItemContent(context, getItemData(index)));
        }, childCount: getItemCount()),
      )
    ];
  }

  @override
  BasePageResult<LostFindGood> jsonToResult(dynamic json) {
    LostFindEntity lostFindEntity = LostFindEntity.fromJson(json);
    return lostFindEntity == null
        ? null
        : BasePageResult(lostFindEntity.code, null, lostFindEntity.goods,
            lostFindEntity.currentPage >= lostFindEntity.pageination);
  }

  @override
  getResponse(int _page) {
    return HttpManager.getInstance().get(NetApi.LOST_AND_FIND + "$_page/0");
  }

  Widget _getItemContent(BuildContext context, LostFindGood lostFindGood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListPersonalInfoWidget(
          headPic: lostFindGood.headPicThumb,
          username: lostFindGood.username,
          desc: lostFindGood.type == null || lostFindGood.type == "2"
              ? "丢失物品"
              : "拾到物品",
          time: lostFindGood.createdOn,
        ),
        _getLostFindContent(lostFindGood.content),
        _getImageWidget(lostFindGood.pics),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.my_location,
                size: 20,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                lostFindGood.locate,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getLostFindContent(String content) {
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

  Widget _getImageWidget(List<String> imageUrls) {
    if (imageUrls != null && imageUrls.length == 1) {
      return Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5),
          alignment: Alignment.topLeft,
          child: Image.network(
            YStrings.baseImageUrl + imageUrls[0],
            alignment: Alignment.topLeft,
            height: 200,
            fit: BoxFit.fitHeight,
          ));
    } else {
      return MultiplePictureWidget(imageUrls, Size(150, 150));
    }
  }

  @override
  bool get wantKeepAlive => true;
}

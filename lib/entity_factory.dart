import 'package:flutter_helper/entity/statement_entity.dart';
import 'package:flutter_helper/entity/user_entity.dart';
import 'package:flutter_helper/entity/lost_find_entity.dart';
import 'package:flutter_helper/entity/second_goods_entity.dart';
import 'package:flutter_helper/entity/course_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "StatementEntity") {
      return StatementEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else if (T.toString() == "LostFindEntity") {
      return LostFindEntity.fromJson(json) as T;
    } else if (T.toString() == "SecondGoodsEntity") {
      return SecondGoodsEntity.fromJson(json) as T;
    } else if (T.toString() == "CourseEntity") {
      return CourseEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
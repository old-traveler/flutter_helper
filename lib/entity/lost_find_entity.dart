class LostFindEntity {
	int code;
	int pageination;
	List<LostFindGood> goods;
	int currentPage;

	LostFindEntity({this.code, this.pageination, this.goods, this.currentPage});

	LostFindEntity.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		pageination = json['pageination'];
		if (json['goods'] != null) {
			goods = new List<LostFindGood>();(json['goods'] as List).forEach((v) { goods.add(new LostFindGood.fromJson(v)); });
		}
		currentPage = json['current_page'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		data['pageination'] = this.pageination;
		if (this.goods != null) {
      data['goods'] =  this.goods.map((v) => v.toJson()).toList();
    }
		data['current_page'] = this.currentPage;
		return data;
	}
}

class LostFindGood {
	String locate;
	String headPic;
	String type;
	String content;
	String headPicThumb;
	String userId;
	String createdOn;
	String phone;
	String id;
	String time;
	List<String> pics;
	String tit;
	String username;

	LostFindGood({this.locate, this.headPic, this.type, this.content, this.headPicThumb, this.userId, this.createdOn, this.phone, this.id, this.time, this.pics, this.tit, this.username});

	LostFindGood.fromJson(Map<String, dynamic> json) {
		locate = json['locate'];
		headPic = json['head_pic'];
		type = json['type'];
		content = json['content'];
		headPicThumb = json['head_pic_thumb'];
		userId = json['user_id'];
		createdOn = json['created_on'];
		phone = json['phone'];
		id = json['id'];
		time = json['time'];
		pics = json['pics']?.cast<String>();
		tit = json['tit'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['locate'] = this.locate;
		data['head_pic'] = this.headPic;
		data['type'] = this.type;
		data['content'] = this.content;
		data['head_pic_thumb'] = this.headPicThumb;
		data['user_id'] = this.userId;
		data['created_on'] = this.createdOn;
		data['phone'] = this.phone;
		data['id'] = this.id;
		data['time'] = this.time;
		data['pics'] = this.pics;
		data['tit'] = this.tit;
		data['username'] = this.username;
		return data;
	}
}

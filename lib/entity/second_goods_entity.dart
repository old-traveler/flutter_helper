class SecondGoodsEntity {
	int code;
	int pageination;
	List<SecondGoodsGood> goods;
	int currentPage;

	SecondGoodsEntity({this.code, this.pageination, this.goods, this.currentPage});

	SecondGoodsEntity.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		pageination = json['pageination'];
		if (json['goods'] != null) {
			goods = new List<SecondGoodsGood>();(json['goods'] as List).forEach((v) { goods.add(new SecondGoodsGood.fromJson(v)); });
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

class SecondGoodsGood {
	String image;
	String userId;
	String createdOn;
	String id;
	String prize;
	String tit;

	SecondGoodsGood({this.image, this.userId, this.createdOn, this.id, this.prize, this.tit});

	SecondGoodsGood.fromJson(Map<String, dynamic> json) {
		image = json['image'];
		userId = json['user_id'];
		createdOn = json['created_on'];
		id = json['id'];
		prize = json['prize'];
		tit = json['tit'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['image'] = this.image;
		data['user_id'] = this.userId;
		data['created_on'] = this.createdOn;
		data['id'] = this.id;
		data['prize'] = this.prize;
		data['tit'] = this.tit;
		return data;
	}
}

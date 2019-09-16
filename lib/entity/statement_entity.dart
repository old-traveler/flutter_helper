class StatementEntity {
	int code;
	int pageination;
	List<StatemantStatemant> statement;
	String currentPage;

	StatementEntity({this.code, this.pageination, this.statement, this.currentPage});

	StatementEntity.fromJson(Map<String, dynamic> json) {
		code = json['code'];
		pageination = json['pageination'];
		if (json['statement'] != null) {
			statement = new List<StatemantStatemant>();(json['statement'] as List).forEach((v) { statement.add(new StatemantStatemant.fromJson(v)); });
		}
		currentPage = json['current_page'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['code'] = this.code;
		data['pageination'] = this.pageination;
		if (this.statement != null) {
      data['statement'] =  this.statement.map((v) => v.toJson()).toList();
    }
		data['current_page'] = this.currentPage;
		return data;
	}
}

class StatemantStatemant {
	String viewCnt;
	List<StatemantStatemantCommants> comments;
	String headPic;
	String bio;
	String depName;
	String content;
	String isTop;
	String headPicThumb;
	String userId;
	String createdOn;
	bool isLike;
	String id;
	List<String> pics;
	String likes;
	String username;

	StatemantStatemant({this.viewCnt, this.comments, this.headPic, this.bio, this.depName, this.content, this.isTop, this.headPicThumb, this.userId, this.createdOn, this.isLike, this.id, this.pics, this.likes, this.username});

	StatemantStatemant.fromJson(Map<String, dynamic> json) {
		viewCnt = json['view_cnt'];
		if (json['comments'] != null) {
			comments = new List<StatemantStatemantCommants>();(json['comments'] as List).forEach((v) { comments.add(new StatemantStatemantCommants.fromJson(v)); });
		}
		headPic = json['head_pic'];
		bio = json['bio'];
		depName = json['dep_name'];
		content = json['content'];
		isTop = json['is_top'];
		headPicThumb = json['head_pic_thumb'];
		userId = json['user_id'];
		createdOn = json['created_on'];
		isLike = json['is_like'];
		id = json['id'];
		pics = json['pics']?.cast<String>();
		likes = json['likes'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['view_cnt'] = this.viewCnt;
		if (this.comments != null) {
      data['comments'] =  this.comments.map((v) => v.toJson()).toList();
    }
		data['head_pic'] = this.headPic;
		data['bio'] = this.bio;
		data['dep_name'] = this.depName;
		data['content'] = this.content;
		data['is_top'] = this.isTop;
		data['head_pic_thumb'] = this.headPicThumb;
		data['user_id'] = this.userId;
		data['created_on'] = this.createdOn;
		data['is_like'] = this.isLike;
		data['id'] = this.id;
		data['pics'] = this.pics;
		data['likes'] = this.likes;
		data['username'] = this.username;
		return data;
	}
}

class StatemantStatemantCommants {
	String momentId;
	String userId;
	String createdOn;
	String comment;
	String id;
	String username;

	StatemantStatemantCommants({this.momentId, this.userId, this.createdOn, this.comment, this.id, this.username});

	StatemantStatemantCommants.fromJson(Map<String, dynamic> json) {
		momentId = json['moment_id'];
		userId = json['user_id'];
		createdOn = json['created_on'];
		comment = json['comment'];
		id = json['id'];
		username = json['username'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['moment_id'] = this.momentId;
		data['user_id'] = this.userId;
		data['created_on'] = this.createdOn;
		data['comment'] = this.comment;
		data['id'] = this.id;
		data['username'] = this.username;
		return data;
	}
}

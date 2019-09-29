class BasePageResult<D> {
  final int code;

  final String msg;

  final List<D> data;

  final bool noMore;

  BasePageResult(this.code, this.msg, this.data, this.noMore);
}

class BasePageResult<D> {

  final List<D> data;

  final bool noMore;

  BasePageResult(this.data, this.noMore);
}

enum PostCategory{
  POSTS,
  LIKED,
  MEDIA

}

class PostCategoryModel{
  final String offSetId;
  final PostCategory postCategory;
  final userId;
  PostCategoryModel(this.offSetId, this.postCategory, this.userId);

  @override
  String toString() {
    return super.toString().toLowerCase();
  }
}
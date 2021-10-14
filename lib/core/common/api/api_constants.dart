import '../static_data/all_countries.dart';

class ApiConstants {
  static const String baseUrl = "https://ipfamba.com//mobile_api/";
  static const String baseMediaUrl = "https://ipfamba.com/";
  static const String loginEndPoint = "login";
  static const String signUpEndPoint = "signup";
  static const String resetPassword = "resetpassword";
  static const String feeds = "feeds";
  static const String profile = "profile";
  static const String oauth = "oauth";
  static const String reportPost = 'publication_report';
  static const String reportProfile = 'profile_report';
  static const String votePolls = 'vote_polls';
  // post
  static const String profilePosts = "profile_posts";
  static const String uploadPostMedia = "upload_post_media";
  static const String publishPost = "publish_post";
  static const String likePost = "like_post";
  static const String deletePost = "delete_post";
  static const String deletePostMedia = "delete_post_media";
  static const String publicationRepost = "publication_repost";
  static const String addBookmark = "add_bookmark";
  static const String getBookmarks = "get_bookmarks";
  static const String threadData = "thread_data";
  static const String fetchLikes = "fetch_likes";
  static const String searchMessage = "search_messages";

  static const String changePassword = "change_password";

  static const String follow = "follow";

  // searching
  static const String searchHashtags = "search_hashtags";
  static const String searchPeople = "search_people";

  // user profile
  static const String fetchFollowers = "fetch_followers";
  static const String fetchFollowing = "fetch_following";
  static const String searchPosts = "search_posts";
  static const String privacySettings = "get_priv_settings";
  static const String updateUserSettings = "gen_settings";
  static const String updatePrivacySettings = "set_priv_settings";
  static const String logOut = "logout";
  static const String deleteAccount = "delete_account";
  static const String saveNotificationToken = "save_pnotif_token";
  static const String verifyUser = "verify_user";
  static const String changeLanguage = "language";
  static const String updateCover = "cover";
  static const String updateAvatar = "avatar";

  //messages
  // dont know why they've used
  static const String getMessages = "get_chats";

  static String getNotifications = "get_notifications";
  static String deleteNotification = "delete_notifs";
  static const String deleteAllMessages = "clear_chat";
  static const String getChatMessages = "get_messages";
  static const String sendMessage = "send_message";
  static const String deleteMessage = "delete_message";

  // pagination
  static const int pageSize = 20;

  static final allCountries = countryMap.keys.toList();
  static final allLanguages = allLanguagesMap.keys.toList();
}

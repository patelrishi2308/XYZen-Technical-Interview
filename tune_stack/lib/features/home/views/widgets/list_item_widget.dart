import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/widgets/common_container_widget.dart';

class TuneStackListItem extends StatelessWidget {
  const TuneStackListItem({
    required this.posterName,
    required this.category,
    required this.imageUrl,
    required this.likeCount,
    required this.commentCount,
    required this.description,
    required this.timeAgo,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onProfileTap,
    required this.onShareTap,
    super.key,
  });
  final String posterName;
  final String category;
  final String imageUrl;
  final int likeCount;
  final int commentCount;
  final String description;
  final String timeAgo;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onProfileTap;
  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    return CommonContainerWidget(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile info
          _buildHeader(),

          // Image content
          _buildImageContent(),

          // Action buttons
          _buildActionButtons(),

          // Like count
          _buildLikeCount(),

          // Caption and comments
          _buildCaptionAndComments(),

          // Timestamp
          _buildTimestamp(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Profile avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            backgroundImage: NetworkImage(imageUrl),
          ),
          AppConst.gap12,
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posterName,
                  style: AppStyles.getMediumStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  category,
                  style: AppStyles.getRegularStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // More options button
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Like button
          InkWell(
            onTap: onLikeTap,
            child: const Icon(Icons.favorite_border, size: 24),
          ),
          AppConst.gap16,
          // Comment button
          InkWell(
            onTap: onCommentTap,
            child: const Icon(Icons.chat_bubble_outline, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        '$likeCount likes',
        style: AppStyles.getMediumStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCaptionAndComments() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Caption with username and text
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: posterName,
                  style: AppStyles.getMediumStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: ' $description',
                  style: AppStyles.getRegularStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          AppConst.gap4,
          // View all comments button
          InkWell(
            onTap: onCommentTap,
            child: Text(
              'View all $commentCount comments',
              style: AppStyles.getRegularStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        timeAgo,
        style: AppStyles.getRegularStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}

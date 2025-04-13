import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master_utility/master_utility.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/config/custom_exception.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_strings.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/features/create_post/controllers/create_post_state_notifier.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/helpers/app_utils.dart';
import 'package:tune_stack/helpers/preference_helper.dart';
import 'package:tune_stack/helpers/toast_helper.dart';
import 'package:tune_stack/widgets/app_button.dart';
import 'package:tune_stack/widgets/app_text_field.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  File? _selectedImage;
  File? _selectedMusic;
  String? _musicFileName;
  String? _musicFileSize;
  final List<String> _categories = [
    'Pop',
    'Rock',
    'Hip Hop',
    'Jazz',
    'Classical',
    'Electronic',
    'R&B',
    'Country',
  ];

  @override
  void initState() {
    super.initState();
    getAllImages();
  }

  Future<void> getAllImages() async {
    await Supabase.instance.client.storage.from('spotifyclone').list();
    debugPrint('Images');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Request media permission first
    await AppUtils.mediaPermission(
      onGrantedCallback: () async {
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          setState(() {
            _selectedImage = File(image.path);
          });
        }
      },
    );
  }

  Future<void> _pickMusicFile() async {
    // Request audio permission first
    await AppUtils.audioPermission(
      onGrantedCallback: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
        );

        if (result != null) {
          setState(() {
            _selectedMusic = File(result.files.single.path!);
            _musicFileName = result.files.single.name;

            // Calculate file size in MB
            final bytes = _selectedMusic!.lengthSync();
            final kb = bytes / 1024;
            final mb = kb / 1024;
            _musicFileSize = '${mb.toStringAsFixed(2)} MB';
          });
        }
      },
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConst.k16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(AppConst.k16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Category',
                style: AppStyles.getMediumStyle(
                  fontSize: AppConst.k16,
                  color: AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              AppConst.gap16,
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_categories[index]),
                      onTap: () {
                        setState(() {
                          _categoryController.text = _categories[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitPost(
    CreatePostStateNotifier? createPostStateNotifier,
  ) async {
    if (_formKey.currentState!.validate() && _validateFiles()) {
      if (_selectedImage == null) {
        AppToastHelper.showError('Please select cover image');
      } else if (_selectedMusic == null) {
        AppToastHelper.showError('Please select music');
      } else if (_selectedImage != null && _selectedMusic != null) {
        try {
          final coverImageURL = await createPostStateNotifier?.uploadCoverImage(_selectedImage!);
          final audioFileURL = await createPostStateNotifier?.uploadMusicFiles(_selectedMusic!);
          final userId = SharedPreferenceHelper.getString(AppStrings.userID);

          if (coverImageURL != null && audioFileURL != null && userId != null) {
            final createPost = await createPostStateNotifier?.createPost(
              coverImageURL,
              _titleController.text,
              _categoryController.text,
              _descriptionController.text,
              audioFileURL,
              userId,
            );
            if (createPost == 'success') {
              AppToastHelper.showSuccess('Post created successfully!');
              NavigationHelper.navigatePop();
            } else {
              AppToastHelper.showError(
                'Something went wrong please try again later',
              );
            }
          } else {
            AppToastHelper.showError(
              'Something went wrong please try again later',
            );
          }
        } catch (e) {
          if (e is CustomException) {
            AppToastHelper.showError(e.message);
          }
        } finally {
          createPostStateNotifier?.setLoading(false);
        }
      }
    }
  }

  bool _validateFiles() {
    if (_selectedImage == null) {
      AppToastHelper.showError('Please select a image file for your post');
      return false;
    }

    if (_selectedMusic == null) {
      AppToastHelper.showError('Please select a music file for your post');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final createPostState = ref.watch(createPostStateNotifierProvider);
    final createPostStateNotifier = ref.read(createPostStateNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const BackArrowAppBar(
        title: 'Create Post',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConst.k16),
            child: Consumer(
              builder: (context, ref, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Image Selection
                      _buildImageSelector(),
                      AppConst.gap20,

                      // Title Field
                      Text(
                        'Post Title',
                        style: AppStyles.getMediumStyle(
                          fontSize: AppConst.k14,
                          color: AppColors.primaryText,
                        ),
                      ),
                      AppConst.gap8,
                      AppTextField(
                        controller: _titleController,
                        hintText: 'Enter post title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      AppConst.gap20,

                      // Category Selection
                      Text(
                        'Category',
                        style: AppStyles.getMediumStyle(
                          fontSize: AppConst.k14,
                          color: AppColors.primaryText,
                        ),
                      ),
                      AppConst.gap8,
                      AppTextField(
                        controller: _categoryController,
                        hintText: 'Select category',
                        readOnly: true,
                        onTap: _showCategoryPicker,
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primary,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      AppConst.gap20,

                      // Description Field
                      Text(
                        'Description',
                        style: AppStyles.getMediumStyle(
                          fontSize: AppConst.k14,
                          color: AppColors.primaryText,
                        ),
                      ),
                      AppConst.gap8,
                      AppTextField(
                        controller: _descriptionController,
                        hintText: 'Describe your post',
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        textFieldHeight: AppConst.k100,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      AppConst.gap20,

                      // Music File Selection
                      _buildMusicFileSelector(),
                      AppConst.gap32,

                      // Submit Button
                      AppButton(
                        title: 'Create Post',
                        onPressed: () async {
                          await _submitPost(createPostStateNotifier).then((_) {
                            ref.read(homeStateNotifierProvider.notifier).getAllPosts();
                          });
                        },
                        isLoading: createPostState.isLoading,
                      ),
                      AppConst.gap32,
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cover Image',
          style: AppStyles.getMediumStyle(
            fontSize: AppConst.k14,
            color: AppColors.primaryText,
          ),
        ),
        AppConst.gap8,
        InkWell(
          onTap: _pickImage,
          child: Container(
            height: AppConst.width * 0.6,
            decoration: BoxDecoration(
              color: AppColors.divider.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppConst.k8),
              border: Border.all(
                color: AppColors.divider,
              ),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppConst.k8),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: AppConst.k48,
                          color: AppColors.primary,
                        ),
                        AppConst.gap8,
                        Text(
                          'Tap to select cover image',
                          style: AppStyles.getRegularStyle(
                            fontSize: AppConst.k14,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMusicFileSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Music File',
          style: AppStyles.getMediumStyle(
            fontSize: AppConst.k14,
            color: AppColors.primaryText,
          ),
        ),
        AppConst.gap8,
        InkWell(
          onTap: _pickMusicFile,
          child: Container(
            padding: const EdgeInsets.all(AppConst.k16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConst.k8),
              border: Border.all(
                color: AppColors.divider,
              ),
            ),
            child: Row(
              children: [
                Container(
                  height: AppConst.k48,
                  width: AppConst.k48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConst.k8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: AppColors.primary,
                  ),
                ),
                AppConst.gap16,
                Expanded(
                  child: _selectedMusic != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _musicFileName ?? 'Selected Music File',
                              style: AppStyles.getMediumStyle(
                                fontSize: AppConst.k14,
                                color: AppColors.primaryText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppConst.gap4,
                            Text(
                              _musicFileSize ?? '',
                              style: AppStyles.getRegularStyle(
                                fontSize: AppConst.k12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Tap to select music file',
                          style: AppStyles.getRegularStyle(
                            fontSize: AppConst.k14,
                            color: AppColors.secondaryText,
                          ),
                        ),
                ),
                const Icon(
                  Icons.upload_file,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

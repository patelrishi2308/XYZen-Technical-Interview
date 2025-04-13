import 'package:danger_core/danger_core.dart';

void main() {
  //! ---------  Danger Dart Error Message ----------------
  const envContain = 'You pushed .env file.';
  const prWip = 'PR is considered WIP.';
  const descriptionShort = "This PR's description is too short. It should be contain at least 30 characters.";
  const titleShort = "This PR's title is too short. It should be contain at least 15 characters.";
  const noAssignee = 'There are no assignees to this pull request.';
  const prShort =
      'This PR size is too large Over 15 files. Please split into separate PRs to enable faster & easier review.';
  const removeBranch = 'Should have deleted the source branch. Please fill the checkbox.';
  const pubLockContain =
      'If there are any changes to the pubspec.yaml file, the pubspec.lock file should also be present.';
  const minimumLengthDescription = 30;
  const minimumLengthTitle = 15;
  const maximumPRFiles = 15;

  checkEnv(envContain);
  prWorkInProgress(prWip);
  checkTitle(minimumLengthTitle, titleShort);
  checkDescription(minimumLengthDescription, descriptionShort);
  checkAssignees(noAssignee);
  checkPRFiles(maximumPRFiles, prShort);
  checkRemoveBranch(removeBranch);
  checkPubLock(pubLockContain);
}

//!---- Env file check
void checkEnv(String envContain) {
  final dangerGitFiles = [...danger.git.createdFiles, ...danger.git.modifiedFiles];

  final envFile = dangerGitFiles.any((file) => file == '.env');
  if (envFile) {
    fail(envContain);
  }
}

//! Pub.lock file check
void checkPubLock(String pubLockContain) {
  final isContainPubYml = danger.git.modifiedFiles.any((file) => file == 'pubspec.yml');
  final isContainPubLock = danger.git.modifiedFiles.any((file) => file == 'pubspec.lock');

  if (isContainPubYml && isContainPubLock) {
    fail(pubLockContain);
  }
}

//! --- PR WIP
void prWorkInProgress(String prWip) {
  if (danger.gitLab.mergeRequest.title.contains('wip')) {
    fail(prWip);
  }
}

//! --- title length
void checkTitle(int minimumLength, String titleShort) {
  final titleIsValid = danger.gitLab.mergeRequest.title.length >= minimumLength;

  if (!titleIsValid) {
    fail(titleShort);
  }
}

//! ---- description length
void checkDescription(int minimumLength, String descriptionShort) {
  final descriptionIsLongEnough = danger.gitLab.mergeRequest.description.length >= minimumLength;

  if (!descriptionIsLongEnough) {
    fail(descriptionShort);
  }
}

//! --- check assignees
void checkAssignees(String noAssignee) {
  final hasAssignees = danger.gitLab.mergeRequest.assignee?.name.isNotEmpty ?? false;

  if (!hasAssignees) {
    fail(noAssignee);
  }
}

//! --- checking PR size
void checkPRFiles(int maximumPRFiles, String prShort) {
  final mergeRequest = danger.gitLab.mergeRequest;
  final changeCount = mergeRequest.changesCount.length;
  final devBranch = mergeRequest.sourceBranch == 'development';

  if (!devBranch) {
    if (changeCount > maximumPRFiles) {
      fail(prShort);
    }
  }
}

//! --- check Remove Branch
void checkRemoveBranch(String removeBranch) {
  final isRemoveBranch = danger.gitLab.mergeRequest.forceRemoveSourceBranch ?? false;

  if (!isRemoveBranch) {
    warn(removeBranch);
  }
}

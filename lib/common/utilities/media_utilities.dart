import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:whatsapp_clone/common/utilities/utilities.dart';

class MediaUtilities {

/// Function to request media permission
Future<Result<bool>> requestMediaPermission() async {
  try {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      // Permission granted
      return Result.success(true);
    } else {
      // Permission denied or limited
      PhotoManager.openSetting(); // Optionally direct user to settings
      return Result.error("Permission denied or limited.");
    }
  } catch (e) {
    return Result.error("Failed to request permission: $e");
  }
}


/// Fetch folders/albums containing media (images/videos).
Future<Result<List<AssetPathEntity>>> fetchMediaFolders({SortOption? sortOption}) async {
  try {
    // Ensure permission is granted
    final PermissionState permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      final Result<bool> grantedResult = await requestMediaPermission();
      if (grantedResult.isError) return Result.error(grantedResult.error ?? "Permission not granted to access media.");
    }

    // Fetch folders/albums
    List<AssetPathEntity> folders = await PhotoManager.getAssetPathList(
      type: RequestType.image | RequestType.video,
      hasAll: true,
    );

    // Sort folders based on the provided option
    if (sortOption != null) {
      folders.sort((a, b) {
        switch (sortOption) {
          case SortOption.ascendingName:
            return a.name.compareTo(b.name);
          case SortOption.descendingName:
            return b.name.compareTo(a.name);
          case SortOption.ascendingDateModified:
            return a.lastModified?.compareTo(b.lastModified ?? DateTime.now()) ?? 0;
          case SortOption.descendingDateModified:
            return b.lastModified?.compareTo(a.lastModified ?? DateTime.now()) ?? 0;
        }
      });
    }

    return Result.success(folders);
  } catch (e) {
    return Result.error("Failed to fetch media folders: $e");
  }
}


/// Stream assets from a specific folder/album incrementally.
Stream<Result<AssetEntity>> streamAssetsFromFolder(AssetPathEntity folder, {int pageSize = 50}) async* {
  try {
    int page = 0;
    bool hasMore = true;

    while (hasMore) {
      // Fetch assets in chunks
      List<AssetEntity> assets = await folder.getAssetListPaged(page: page, size: pageSize);
      if (assets.isEmpty) { hasMore = false; } 
      else {
        for (var asset in assets) { yield Result.success(asset);}
        page++;
      }
    }
  } catch (e) {
    yield Result.error("Failed to stream assets from folder: $e");
  }
}



/// Save media to the application's media directory.
///
/// [sourceFile] is the file to be copied.
/// [relativePath] specifies the folder structure under the app's media directory (e.g., "Images/MyFolder").
/// Returns a [Result<File>] indicating success or failure.
Future<Result<File>> saveMediaToAppDirectory(File sourceFile, String relativePath) async {
  try {
    // Get the base directory for Android media
    Directory? mediaDir = await getExternalStorageDirectory();
    if (mediaDir == null) return Result.error("Media directory is not accessible.");

    // Construct the app-specific media path
    String appMediaPath = '${mediaDir.parent.parent.parent.path}/Android/media/com.whatsapp_clone/$relativePath';

    // Ensure the directory exists
    final Directory targetDir = Directory(appMediaPath);

    if (!(await targetDir.exists())) await targetDir.create(recursive: true);
    // Create the target file path
    final String fileName = sourceFile.path.split('/').last;
    final File targetFile = File('${targetDir.path}/$fileName');

    // Copy the source file to the target location
    await sourceFile.copy(targetFile.path);

    // Return success with the target file
    return Result.success(targetFile);
  } catch (e) {
    // Return an error result
    return Result.error("Failed to save media: $e");
  }
}


/// Function to get all files in a specified directory in the app's media directory.
Future<Result<List<File>>> getAllFilesInDir(String dirPath) async {
  try {
    final Directory directory = Directory(dirPath);
    if (!await directory.exists()) return Result.error("Directory does not exist.");

    // Get all files in the directory
    final List<File> files = directory.listSync().whereType<File>().toList();
    return Result.success(files);
  } catch (e) {
    return Result.error("Failed to get files from directory: $e");
  }
}


/// Function to get a specific file in a directory in the app's media directory.
Future<Result<File?>> getSpecificFileFromDir(String dirPath, String fileName) async {
  try {
    final directory = Directory(dirPath);
    if (!(await directory.exists())) return Result.error("Directory does not exist.");
    // Get the specific file from the directory
    File file = File('${directory.path}/$fileName');
    return (await file.exists()) ? Result.success(file) : Result.error("File does not exist in the directory.");
  } catch (e) {
    return Result.error("Failed to get the file: $e");
  }
}




Future<Result<File>> compressImage(File imageFile, {double? targetMB, int? percentQuality}) async {
  try {
    // Validate the input file
    if (!imageFile.existsSync()) {
      return Result.error("Input file does not exist.");
    }

    // Generate the current date string
    String currentDate = '${DateTime.now().year}'
        '${DateTime.now().month.toString().padLeft(2, '0')}'
        '${DateTime.now().day.toString().padLeft(2, '0')}';

    // Get the application's documents directory
    Directory documentsDir = await getApplicationDocumentsDirectory();

    // List all files in the directory
    List<FileSystemEntity> files = await documentsDir.list().toList();

    // Filter files matching the pattern IMG-YYYYMMDD-WA####.jpg
    String pattern = 'IMG-$currentDate-WA';
    List<FileSystemEntity> matchingFiles = files.where((file) {
      String name = file.path.split('/').last;
      return name.startsWith(pattern) && name.endsWith('.jpg');
    }).toList();

    // Extract sequence numbers from the filenames
    List<int> sequenceNumbers = matchingFiles.map((file) {
      String name = file.path.split('/').last;
      String seqStr = name.split('-')[2].replaceAll('.jpg', '');
      return int.tryParse(seqStr) ?? 0; // Safely parse numbers
    }).toList();

    // Determine the next sequence number
    int nextSeq = sequenceNumbers.isEmpty ? 1 : sequenceNumbers.reduce((a, b) => a > b ? a : b) + 1;

    // Pad the sequence number to four digits
    String seqString = nextSeq.toString().padLeft(4, '0');

    // Construct the new filename
    String finalFilename = 'IMG-$currentDate-WA$seqString.jpg';
    String compressedImagePath = '${documentsDir.path}/$finalFilename';

    // Perform initial compression
    XFile? compressedImageFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      compressedImagePath,
      quality: percentQuality ?? 90, // Default to high quality if none provided
    );

    // Check if compression succeeded
    if (compressedImageFile == null) {
      return Result.error("Image compression failed.");
    }

    // If targetMB is specified, check and compress if necessary
    if (targetMB != null) {
      double fileSizeMB = (await compressedImageFile.length()) / (1024 * 1024);

      // If the file size is still above the targetMB after compression
      if (fileSizeMB > targetMB) {
        int adjustedQuality = ((percentQuality ?? 90) * (targetMB / fileSizeMB)).toInt().clamp(10, 90);
        compressedImageFile = await FlutterImageCompress.compressAndGetFile(
          imageFile.path,
          compressedImagePath,
          quality: adjustedQuality,
          format: CompressFormat.jpeg,
        );

        // If compression still doesn't meet target, force compression to 150KB
        if (compressedImageFile == null || (await compressedImageFile.length()) / (1024 * 1024) > targetMB) {
          compressedImageFile = await FlutterImageCompress.compressAndGetFile(
            imageFile.path,
            compressedImagePath,
            quality: 10, // Lower quality for a much smaller file
            minWidth: 1, // Minimize the width
            minHeight: 1, // Minimize the height
            format: CompressFormat.jpeg,
          );
          
          if (compressedImageFile == null) {
            return Result.error("Final compression to default size failed.");
          }
        }
      }
    }

    return Result.success(File(compressedImageFile.path));
  } catch (e) {
    // Return any caught error
    return Result.error("An error occurred during compression: $e");
  }
}

}


enum SortOption {
  ascendingName,
  descendingName,
  ascendingDateModified,
  descendingDateModified,
}

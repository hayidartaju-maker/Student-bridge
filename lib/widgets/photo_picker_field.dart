import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Circular photo picker used for both student and parent photos.
/// Shows a red-bordered placeholder + "required" text until a photo
/// is chosen, so it's visually obvious the form can't be submitted yet.
class PhotoPickerField extends StatelessWidget {
  final String label;
  final File? file;
  final ValueChanged<File> onChanged;

  const PhotoPickerField({
    super.key,
    required this.label,
    required this.file,
    required this.onChanged,
  });

  Future<void> _pick(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () async => Navigator.pop(
                ctx,
                await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () async => Navigator.pop(
                ctx,
                await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (picked != null) onChanged(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = file != null;
    return Column(
      children: [
        InkWell(
          onTap: () => _pick(context),
          borderRadius: BorderRadius.circular(60),
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: hasPhoto
                    ? Theme.of(context).colorScheme.primary
                    : Colors.redAccent,
                width: 2,
              ),
              image: hasPhoto
                  ? DecorationImage(image: FileImage(file!), fit: BoxFit.cover)
                  : null,
              color: Colors.black.withOpacity(0.04),
            ),
            child: hasPhoto
                ? null
                : const Icon(Icons.add_a_photo_outlined, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (!hasPhoto)
          const Text(
            'Required',
            style: TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
      ],
    );
  }
}

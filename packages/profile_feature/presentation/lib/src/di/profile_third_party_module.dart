import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

/// Registers third-party classes that the profile feature consumes but does
/// not own. [ImagePicker] can't be annotated directly because it lives in an
/// external package, so we expose it via a `@module` getter instead.
@module
abstract class ProfileThirdPartyModule {
  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();
}

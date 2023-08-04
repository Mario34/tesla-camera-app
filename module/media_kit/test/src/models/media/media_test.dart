/// This file is a part of media_kit (https://github.com/alexmercerind/media_kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'package:test/test.dart';
import 'package:collection/collection.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:media_kit/src/models/media/media.dart';

import '../../../common/sources.dart';

void main() {
  setUp(sources.prepare);
  test(
    'media-uri-normalization-network',
    () {
      for (final source in sources.network) {
        final test = source;
        print(test);
        expect(
          Media.normalizeURI(source),
          equals(source),
        );
        expect(
          Media(source).uri,
          equals(source),
        );
      }
    },
  );
  test(
    'media-uri-normalization-file',
    () async {
      // Path
      for (final source in sources.file) {
        final test = source;
        print(test);
        expect(
          Media.normalizeURI(test),
          equals(source),
        );
        expect(
          Media(test).uri,
          equals(source),
        );
      }
      // file:// URI
      for (final source in sources.file) {
        final test = Uri.file(source).toString();
        print(test);
        expect(
          Media.normalizeURI(test),
          equals(source),
        );
        expect(
          Media(test).uri,
          equals(source),
        );
      }
    },
    skip: UniversalPlatform.isWeb || UniversalPlatform.isWindows,
  );
  test(
    'media-uri-normalization-file',
    () async {
      // Path: forward slash separators
      for (final source in sources.file) {
        final test = source;
        print(test);
        expect(
          Media.normalizeURI(test),
          equals(source),
        );
        expect(
          Media(test).uri,
          equals(source),
        );
      }
      // Path: backwards slash separators
      for (final source in sources.file) {
        final test = source.replaceAll('/', r'\');
        print(test);
        expect(
          Media.normalizeURI(test),
          equals(source),
        );
        expect(
          Media(test).uri,
          equals(source),
        );
      }
      // file:/// URI
      for (final source in sources.file) {
        final test = Uri.file(source).toString();
        print(test);
        expect(
          Media.normalizeURI(test),
          equals(source),
        );
        expect(
          Media(test).uri,
          equals(source),
        );
      }
      // file:// URI
      for (final source in sources.file) {
        final test =
            Uri.file(source).toString().replaceAll('file:///', 'file://');
        print(test);
        expect(
          Media.normalizeURI(test),
          equals(source),
        );
        expect(
          Media(test).uri,
          equals(source),
        );
      }
    },
    skip: UniversalPlatform.isWeb || !UniversalPlatform.isWindows,
  );
  test(
    'media-uri-normalization-encode-asset-key',
    () {
      expect(
        Media.encodeAssetKey('asset://videos/video_0.mp4'),
        equals('videos/video_0.mp4'),
      );
      expect(
        Media.encodeAssetKey('asset:///videos/video_0.mp4'),
        equals('videos/video_0.mp4'),
      );
      // Non ASCII characters.
      expect(
        Media.encodeAssetKey('asset://audios/う.wav'),
        equals('audios/%E3%81%86.wav'),
      );
      expect(
        Media.encodeAssetKey('asset:///audios/う.wav'),
        equals('audios/%E3%81%86.wav'),
      );
    },
  );
  test(
    'media-extras-propagate',
    () {
      Media.cache.clear();

      final extras = {
        'foo': 'bar',
        'baz': 'qux',
      };

      final a = Media(sources.platform.first, extras: extras);

      // Must have previously defined pre-defined extras.
      final b = Media(sources.platform.first);

      // Must have newly defined extras.
      final c = Media(
        sources.platform.first,
        extras: {
          'x': 'y',
        },
      );

      print(a.extras);
      print(b.extras);
      print(c.extras);

      expect(
        MapEquality().equals(
          a.extras,
          b.extras,
        ),
        equals(true),
      );
      expect(
        MapEquality().equals(
          c.extras,
          {
            'x': 'y',
          },
        ),
        equals(true),
      );
    },
  );
  test(
    'media-http-headers-propagate',
    () {
      Media.cache.clear();

      final headers = {
        for (int i = 0; i < 10; i++) 'key_$i': 'value_$i',
      };

      final a = Media(sources.platform.first, httpHeaders: headers);

      // Must have previously defined pre-defined headers.
      final b = Media(sources.platform.first);
      // Must have newly defined headers.
      final c = Media(
        sources.platform.first,
        httpHeaders: {
          'x': 'y',
        },
      );

      print(a.httpHeaders);
      print(b.httpHeaders);
      print(c.httpHeaders);

      expect(
        MapEquality().equals(
          a.httpHeaders,
          b.httpHeaders,
        ),
        equals(true),
      );
      expect(
        MapEquality().equals(
          c.httpHeaders,
          {
            'x': 'y',
          },
        ),
        equals(true),
      );
    },
    skip: UniversalPlatform.isWeb,
  );
  test(
    'media-http-headers-propagate',
    () {
      Media.cache.clear();

      expect(
        () => Media(
          sources.platform.first,
          httpHeaders: {
            'x': 'y',
          },
        ),
        throwsUnsupportedError,
      );
    },
    skip: !UniversalPlatform.isWeb,
  );
}

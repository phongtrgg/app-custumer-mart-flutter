# Hướng dẫn cài đặt và build ứng dụng Flutter

## Bước 1: Cài đặt Flutter

1. Tải và cài đặt Flutter phiên bản 3.19.6 từ trang chủ [Flutter](https://flutter.dev/docs/get-started/install).
2. Thiết lập biến môi trường cho Flutter:
   - Thêm đường dẫn `flutter/bin` vào biến PATH của hệ thống.

## Bước 2: Cài đặt Dart SDK

1. Tải và cài đặt Dart SDK phiên bản 3.3.6 từ trang chủ [Dart](https://dart.dev/get-dart).

## Bước 3: Cài đặt các package cần thiết

1. Mở Terminal hoặc Command Prompt.
2. Chạy lệnh sau để cài đặt các package:
   ```sh
   flutter pub get
   ```

## Bước 4: Chỉnh sửa baseURL

1. Mở file `lib/util/app_constants.dart` trong thư mục dự án.
2. Chỉnh sửa giá trị của `baseURL` thành link API mà bạn muốn sử dụng.

## Bước 5: Build file APK

1. Chạy lệnh sau để build file APK:
   ```sh
   flutter build apk --release
   ```
2. File APK sẽ được xuất ra tại thư mục `build/app/outputs/flutter-apk/app-release.apk`.

Chúc bạn thành công!

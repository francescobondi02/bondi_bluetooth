# Polar Heart Rate Application - Flutter

An app which plots the heart rate datas received by a Polar device.

## A few notes

Remember to change the identifier and write down the one of the device you are using:
```ruby
class _MyAppState extends State<MyApp> {
  static const identifier = '20341925';
```
This way the application will scan for this particular device only.

## How it's done
The application is mainly based by Polar Flutter Package (https://pub.dev/packages/polar) & Flutter Plot Package (https://pub.dev/packages/flutter_plot) <br><br>
The device used for testing the development was a Polar OH1.

F.Bondi

<!--This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.-->

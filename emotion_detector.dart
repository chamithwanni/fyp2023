// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// class EmotionRecognition {
//   Interpreter _interpreter;
//   List<String> _labels;
//   int _imageSize = 48;
  
//   EmotionRecognition() {
//     _loadModel();
//   }
  
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('model.tflite');
//       _labels = await File('labels.txt').readAsLines();
//       var inputShape = _interpreter.getInputTensor(0).shape;
//       _imageSize = inputShape[1];
//     } catch (e) {
//       print('Failed to load model and labels: $e');
//     }
//   }
  
//   Future<String?> recognizeEmotion(File imageFile) async {
//     try {
//       var imageBytes = await imageFile.readAsBytes();
//       var image = img.decodeImage(imageBytes);
//       image = img.copyResize(image!, width: _imageSize, height: _imageSize);
//       var input = _preprocessImage(image as File);
//       var output = List<double>.filled(_labels.length, 0);
//       _interpreter.run(input, output);
//       var maxIndex = output.indexOf(output.reduce((curr, next) => curr > next ? curr : next));
//       return _labels[maxIndex];
//     } catch (e) {
//       print('Failed to recognize emotion: $e');
//       return null;
//     }
//   }
  
//   Future<List> _preprocessImage(File imageFile) async {
//     // Read image file as bytes
//     List<int> imageBytes = await imageFile.readAsBytes();

//     // Decode image from bytes
//     img.Image? image = img.decodeImage(imageBytes);

//     // Resize the image to _imageSize x _imageSize
//     img.Image resizedImage = img.copyResize(image!, width: _imageSize, height: _imageSize);

//     // Convert the image to grayscale
//     img.Image grayscaleImage = img.grayscale(resizedImage);

//     // Normalize the image pixel values to be between 0 and 1
//     List<double> input = grayscaleImage.data.map((e) => e / 255.0).toList();

//     return [input];
//   }
  
// }

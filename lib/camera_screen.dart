import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreenPage extends StatefulWidget {
  const CameraScreenPage({super.key});

  @override
  State<CameraScreenPage> createState() => _CameraScreenPageState();
}

class _CameraScreenPageState extends State<CameraScreenPage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  @override
  void initState() {
    startCamera(1);
    super.initState();
  }

  void startCamera(int index) async {
    cameras = await availableCameras();
    cameraController =
        CameraController(cameras[index], ResolutionPreset.high, enableAudio: false);
    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print("error ketdi $e");
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  int cameraIndex=0;
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    print("image $imageFile");
    if (cameraController.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            imageFile ==null? CameraPreview(cameraController) : Image.file(imageFile!),
            Center(
              child: Image.asset("assets/face_frame.png"),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                width: 100,
                decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                margin: EdgeInsets.only(bottom: 50),
                child: IconButton(onPressed: (){
                  cameraController.takePicture().then((value){
                    imageFile = File(value.path);
                    setState(() {});
                  });
                },icon: Icon(Icons.camera, size: 50,),),
              ),
            ),
            Positioned(right: 20, top: 80,child: IconButton(onPressed: (){},icon: Icon(Icons.send, size: 40,),),),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 100,
                width: 100,
                decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                margin: EdgeInsets.only(bottom: 50, left: 20),
                child: IconButton(onPressed: (){
                  if(cameraIndex == 0){
                    cameraIndex = 1;
                  }else{
                    cameraIndex = 0;
                  }
                  startCamera(cameraIndex);
                  setState(() {});
                },icon: Icon(Icons.cameraswitch, size: 50,),),

              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 100,
                width: 100,
                decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                margin: EdgeInsets.only(bottom: 50, right: 20),
                child: IconButton(onPressed: (){
                  imageFile = null;
                  setState(() {});
                },icon: Icon(Icons.cancel_outlined, size: 50,),),

              ),
            ),
          ],
        ),
      );
    }
    return Scaffold();
  }
}

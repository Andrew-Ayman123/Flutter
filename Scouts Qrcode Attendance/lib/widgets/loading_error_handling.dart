import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoadingErrorHandling extends StatelessWidget {
  const LoadingErrorHandling({
    super.key,
    
    required this.builder, required this.isLoading, required this.isError,
  });

  final bool isLoading;
  final bool isError;
  final Widget Function()builder;
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Center(child: CircularProgressIndicator(),);
    }
    else if(isError){
      return Center(child:Text("Error"));
    }
    else{
      return builder();
    }
  }
}

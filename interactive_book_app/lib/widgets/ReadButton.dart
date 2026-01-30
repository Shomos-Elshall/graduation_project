import 'package:flutter/material.dart';

class ReadButton extends StatelessWidget {
  const ReadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
         width: 160,
         margin: EdgeInsets.symmetric(vertical: 18),
        child: ElevatedButton(onPressed:(){},
         style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1D4A85), 
        padding: EdgeInsets.symmetric(vertical: 15),  
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),  
        ),
        
      
         ), child:Center(
           child: Text("Read",style: TextStyle(color: Colors.white,fontSize: 18,
                   fontWeight: FontWeight.w600
                   
                   ),),
         ),
        ),
      
      ),
    );
  }
}

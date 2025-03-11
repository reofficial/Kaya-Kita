import 'package:flutter/material.dart';

class IncomingWorkerScreen extends StatefulWidget {
  const IncomingWorkerScreen({
    super.key,
    required this.worker,
  });

  final Map<String, dynamic>? worker;

  @override
  State<IncomingWorkerScreen> createState() => _IncomingWorkerScreenState();
}

class _IncomingWorkerScreenState extends State<IncomingWorkerScreen> {

  @override
  Widget build(BuildContext context) {
    final worker = widget.worker;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Incoming Worker',
          style:
              TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        
        children: [
          Container(
            color: Colors.white,
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top - 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/map.png',
                //fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height * 0.68,
              ),
            ),
          ),

          Container(
            height: 180,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 35),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      worker != null ? worker['name'] : '',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text('On the way'),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 14,),
                        Text('1.2 km away from you')
                      ],
                    ),

                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 2, right: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            children: [ 
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              SizedBox(width: 2),
                              Text('5.0')
                            ]
                          )
                        ),
                        SizedBox(width: 5,),
                        Text('20 reviews')
                      ],
                    )

                  ],
                ),

                Text('Php 100/hr', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ]
            )
          )
          
        ]
      )
    );
  }
}
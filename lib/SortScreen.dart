import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sorting_visulization/ColorConstants.dart';

import 'VisulizerProvider.dart';

class SortScreen extends StatelessWidget {
  const SortScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SortingBody(),
    );
  }
}

class SortingBody extends StatefulWidget {
  const SortingBody({Key key}) : super(key: key);

  @override
  _SortingBodyState createState() => _SortingBodyState();
}

class _SortingBodyState extends State<SortingBody> {
  Size size;
  double topStatus = 0;
  double bottomStatus = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    topStatus = MediaQuery.of(context).padding.top;
    bottomStatus = MediaQuery.of(context).padding.bottom;

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ChangeNotifierProvider<VisulizerProvider>(
        create: (context) => VisulizerProvider(
            (size.width).toInt(), (400 - (topStatus + 16)).toInt()),
        child: Column(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: mPrimaryLight,
                // borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(22),
                //     bottomRight: Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 4.0), //(x,y)
                    blurRadius: 16.0,
                  ),
                ],

              ),
              padding: EdgeInsets.only(
                  left: 0, top: topStatus + 8, right: 0, bottom: 0),
              child: Consumer<VisulizerProvider>(
                builder: (context, mVisulizer, child) {
                  return ClipRRect(
                    // borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(16),
                    //     bottomRight: Radius.circular(16)),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Wrap(
                            children: [
                              Container(
                                width: 1,
                                height:
                                    mVisulizer.arrayOfBars[index].toDouble(),
                                color: mPrimary,
                              ),
                            ],
                          ),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: mVisulizer.arrayOfBars.length,
                    ),
                  );
                },
              ),
            ),

            Consumer<VisulizerProvider>(
              builder: (context, mVisulizer, child){

                return Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22,horizontal: 6),
                  child: SingleChildScrollView(child: Wrap(
                    children: [
                      getAlgoBadgeWidget("Quick sort", mVisulizer.algorithmType == 0, (){ mVisulizer.setAlgorithmType(0); }),
                      getAlgoBadgeWidget("Selection sort", mVisulizer.algorithmType == 1, (){ mVisulizer.setAlgorithmType(1); }),
                      getAlgoBadgeWidget("Insertion Sort", mVisulizer.algorithmType == 2, (){ mVisulizer.setAlgorithmType(2); }),
                      getAlgoBadgeWidget("Merge Sort", mVisulizer.algorithmType == 3, (){ mVisulizer.setAlgorithmType(3); }),
                      getAlgoBadgeWidget("Heap Sort", mVisulizer.algorithmType == 4, (){ mVisulizer.setAlgorithmType(4); }),
                      getAlgoBadgeWidget("Gnome Sort", mVisulizer.algorithmType == 5, (){ mVisulizer.setAlgorithmType(5); }),
                      getAlgoBadgeWidget("Bubble Sort", mVisulizer.algorithmType == 6, (){ mVisulizer.setAlgorithmType(6); })
                    ],
                  )),
                ));
              },

            ),

            Consumer<VisulizerProvider>(builder: (context, mVisulizer, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: mVisulizer.isRunning ? mRed : mPrimary,
                          child: TextButton(
                            child: Text(
                              mVisulizer.isRunning ? "Stop" : "Start",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (mVisulizer.isRunning)
                                mVisulizer.isRunning = false;
                              else
                                await mVisulizer.start();
                            },
                          )),
                    ),
                    Container(
                      width: 8,
                    ),
                    Card(
                      color: mPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: IconButton(
                        icon: Icon(
                          Icons.autorenew_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () => mVisulizer.resetBars(),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: bottomStatus,
            )
          ],
        ),
      ),
    );
  }


  Widget getAlgoBadgeWidget(String text, bool isSelected, VoidCallback onHit) {

    return InkWell(
      onTap: onHit,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14.0),
        decoration: BoxDecoration(
          color: isSelected ? mPrimary : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          border: isSelected ? null : Border.all(color: mPrimary, width: 1)
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : mPrimary,
          ),
        ),
      ),
    );

  }



}

import 'package:flutter/material.dart';

// class ECMProgressIndicator extends StatelessWidget {
//   final double currentECM;
//   final double maxECM;
//
//   const ECMProgressIndicator({
//     super.key,
//     required this.currentECM,
//     required this.maxECM,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final progress = currentECM / maxECM;
//     final percentage = (progress * 100).toStringAsFixed(1);
//
//     // Screen dimensions for responsiveness
//     final size = MediaQuery.of(context).size;
//     final isPortrait = size.height > size.width;
//     final textScale = isPortrait ? size.width / 400 : size.height / 400;
//     final containerHeight = isPortrait ? size.height * 0.03 : size.height * 0.06;
//
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Labels row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 'Stage 2: ${currentECM.toStringAsFixed(4)} ECM',
//                 style: TextStyle(
//                   fontSize: 14 * textScale,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Montserrat',
//                 ),
//               ),
//
//               const SizedBox(width: 10),
//
//               Text(
//                 'Max: ${maxECM.toStringAsFixed(1)} ECM',
//                 style: TextStyle(
//                   fontSize: 14 * textScale,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'Montserrat',
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: size.height * 0.01),
//           // Progress bar
//           Stack(
//             children: [
//               Container(
//                 height: containerHeight,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white12,
//                   borderRadius: BorderRadius.circular(containerHeight / 2),
//                 ),
//               ),
//               FractionallySizedBox(
//                 widthFactor: progress.clamp(0.0, 1.0),
//                 child: Container(
//                   height: containerHeight,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF0A1C2F), Color(0xFF060D13)],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                     borderRadius: BorderRadius.circular(containerHeight / 2),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '$percentage%',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12 * textScale,
//                         fontFamily: 'Montserrat',
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   //
//   // @override
//   // Widget build(BuildContext context) {
//   //   final progress = currentECM / maxECM;
//   //   final percentage = (progress * 100).toStringAsFixed(1);
//   //
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Row(
//   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //         children: [
//   //           Text('Stage 2: ${currentECM.toStringAsFixed(4)} ECM',
//   //               style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300,fontFamily: 'Montserrat' )),
//   //           Text('Max: ${maxECM.toStringAsFixed(1)} ECM',
//   //               style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300, fontFamily: 'Montserrat')),
//   //         ],
//   //       ),
//   //       const SizedBox(height: 8),
//   //       Stack(
//   //         children: [
//   //           Container(
//   //             height: 20,
//   //             width: double.infinity,
//   //             decoration: BoxDecoration(
//   //               color: Colors.white12,
//   //               borderRadius: BorderRadius.circular(10),
//   //             ),
//   //           ),
//   //           FractionallySizedBox(
//   //             widthFactor: progress.clamp(0.0, 1.0),
//   //             child: Container(
//   //               height: 20,
//   //               decoration: BoxDecoration(
//   //                 gradient: const LinearGradient(
//   //                   colors: [Colors.blue, Colors.tealAccent],
//   //                 ),
//   //                 borderRadius: BorderRadius.circular(10),
//   //               ),
//   //               child: Center(
//   //                 child: Text(
//   //                   '$percentage%',
//   //                   style: const TextStyle(
//   //                     color: Colors.white,
//   //                     fontWeight: FontWeight.bold,
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ],
//   //   );
//   // }
// }


class ECMProgressIndicator extends StatelessWidget {
  final double currentECM;
  final double maxECM;

  const ECMProgressIndicator({
    super.key,
    required this.currentECM,
    required this.maxECM,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentECM / maxECM;
    final percentage = (progress * 100).toStringAsFixed(1);

     final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

     final width = size.width;
    final height = size.height;
    final textScale = isPortrait ? width / 400 : height / 400;
    final containerHeight = isPortrait ? height * 0.03 : height * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top labels row
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stage 2: ${currentECM.toStringAsFixed(4)} ECM',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14 * textScale,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  'Max: ${maxECM.toStringAsFixed(1)} ECM',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14 * textScale,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          // Progress bar
          Stack(
            children: [
              Container(
                height: containerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(containerHeight / 2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 0.3),
                child: Container(
                  height: containerHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2D8EFF), Color(0xFF2EE4A4)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(containerHeight / 2),
                  ),
                  child: Center(
                    child: Text(
                      '$percentage%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * textScale,
                        fontFamily: 'Montserrat',
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

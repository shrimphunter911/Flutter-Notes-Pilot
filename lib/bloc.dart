// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pnotes/services/auth/auth_service.dart';
// import 'package:pnotes/views/login_view.dart';
// import 'package:pnotes/views/notes/create_update_note_view.dart';
// import 'package:pnotes/views/notes/notes_view.dart';
// import 'package:pnotes/views/register_view.dart';
// import 'package:pnotes/views/verify_email_view.dart';
// import 'dart:developer' as devtools show log;
// import 'constants/routes.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;
//
//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Bloc"),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state) {
//             final invalidValue = (state is CounterStateInvalidNumber) ? state.invalidValue : '';
//             return Column(
//               children: [
//                 Text('Current value => ${state.value}'),
//                 Visibility(
//                   child: Text('Invalid input: $invalidValue'),
//                   visible: state is CounterStateInvalidNumber,
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                       hintText: 'Enter a number here'
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     Card(
//                       child: TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(DecrementEvent(_controller.text));
//                           },
//                           child: const Text('-')
//                       ),
//                     ),
//                     Card(
//                       child: TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(IncrementEvent(_controller.text));
//                           },
//                           child: const Text('+')
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }
//
// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }
//
// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue
//   }) : super(previousValue);
// }
//
// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this. value);
// }
//
// class IncrementEvent extends CounterEvent{
//   const IncrementEvent(String value) : super(value);
// }
//
// class DecrementEvent extends CounterEvent{
//   const DecrementEvent(String value) : super(value);
// }
//
// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//             CounterStateInvalidNumber(
//                 invalidValue: event.value,
//                 previousValue: state.value
//             )
//         );
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//             CounterStateInvalidNumber(
//                 invalidValue: event.value,
//                 previousValue: state.value
//             )
//         );
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     });
//   }
// }
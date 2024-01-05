import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes_app/constants/routes.dart';
import 'package:my_notes_app/helper/loading/loading_screen.dart';
import 'package:my_notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes_app/services/auth/bloc/auth_event.dart';
import 'package:my_notes_app/services/auth/bloc/auth_state.dart';
import 'package:my_notes_app/services/auth/firebase_auth_provider.dart';
import 'package:my_notes_app/views/forgot_password_view.dart';
import 'package:my_notes_app/views/loading_view.dart';
import 'package:my_notes_app/views/login_view.dart';
import 'package:my_notes_app/views/notes/create_update_note_view.dart';
import 'package:my_notes_app/views/notes/notes_view.dart';
import 'package:my_notes_app/views/register_view.dart';
import 'package:my_notes_app/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateOrUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateNeedVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordView();
      } else {
        return const LoadingView();
      }
    }, listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText,
        );
      } else {
        LoadingScreen().hide();
      }
    });
  }
}






// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing Bloc'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalid) ? state.invalidValue : ' ';
//             return Column(
//               children: [
//                 Text("Current Value => ${state.value}"),
//                 Visibility(
//                   visible: state is CounterStateInvalid,
//                   child: Text(
//                     "Invalid Input => $invalidValue",
//                   ),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration:
//                       const InputDecoration(hintText: "Enter an Integer"),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(IncrementEvent(_controller.text));
//                       },
//                       icon: const Icon(Icons.add_circle),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(DecrementEvent(_controller.text));
//                       },
//                       icon: const Icon(Icons.exposure_minus_1),
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

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalid extends CounterState {
//   final String invalidValue;

//   const CounterStateInvalid(
//       {required this.invalidValue, required int previousValue})
//       : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer != null) {
//         emit(CounterStateValid(state.value + integer));
//       } else {
//         emit(CounterStateInvalid(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       }
//     });
//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer != null) {
//         emit(CounterStateValid(state.value - integer));
//       } else {
//         emit(CounterStateInvalid(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       }
//     });
//   }
// }

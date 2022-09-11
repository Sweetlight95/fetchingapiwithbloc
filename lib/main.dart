import 'package:fetchingapi_bloc/blocks/app_bloc.dart';
import 'package:fetchingapi_bloc/blocks/app_event.dart';
import 'package:fetchingapi_bloc/blocks/app_state.dart';
import 'package:fetchingapi_bloc/repo/repository.dart';
import 'package:fetchingapi_bloc/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocks/digital_screen.dart';
import 'model/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
        create: (context) => UserRepository(),
        child: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(
            RepositoryProvider.of<UserRepository>(context),
        )..add(LoadUserEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("The BLoC App"),
        ),
        body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state){
              if (state is UserLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is UserLoadedState) {
                List<UserModel> userList =  state.users;
                return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (_, index){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen (
                                    e: userList[index],
                                  ))
                            );
                          },
                          child: Card(
                            color: Colors.pink,
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: ListTile (
                              title: Text(userList[index].firstname, style: TextStyle(
                                color: Colors.black
                              ),),
                              subtitle: Text(userList[index].lastname, style: TextStyle(
                              color: Colors.black
                              ),
                            ),
                              trailing: CircleAvatar(
                                backgroundImage: NetworkImage(userList[index].avatar),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
              if (state is UserErrorState) {
                return Center(child: Text('Error'),);
              }
              return Container();
            }

        ),
      ),
    );
  }
}
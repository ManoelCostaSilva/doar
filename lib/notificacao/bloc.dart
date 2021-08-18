import 'package:doaruser/dados/dados.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class BlocHome{
  void initOneSignal()async{
    await OneSignal.shared.setAppId("5dcbe03c-701d-44c7-a5dd-d6f1b03b4537");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

  }

  setOnsignalId(String ID){
    OneSignal.shared.setExternalUserId(ID);
  }

  gravaOnsignalId(String idUser) async{
    final status = await OneSignal.shared.getDeviceState();
    final String? userId = status?.userId;
    //ATUALIZA O ID DO ONGINAL
    await Dados.databaseReference.collection('user').doc(idUser).update({'onsignalID':userId,});
  }

  sendNotification()async{
    await OneSignal.shared.postNotification(OSCreateNotification(
      additionalData: {
        'data': 'this is our data',
      },
      subtitle: 'Flutter in depth',
      playerIds: ['ab6ff36c-0294-46eb-bf0e-08e6f890a10e'],
      content: 'New series lessons from Code With Ammar',
    ));
  }

  notificacaoRecebida()async{
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');
      /// Display Notification, send null to not display
      event.complete(null);
      //envia a notificação
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    });

    OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) {
      print("In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

  }

}
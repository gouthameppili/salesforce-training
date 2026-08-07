public with sharing class NotificationService {

    @future
    public static void sendApplicationEmail(Id applicationId){

        System.debug('Future Method Started');
        System.debug('Application Id : ' + applicationId);

    }

}
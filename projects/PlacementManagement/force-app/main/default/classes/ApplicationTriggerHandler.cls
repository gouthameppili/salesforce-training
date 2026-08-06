public class ApplicationTriggerHandler {

    public static void beforeInsert(List<Application__c> applications){

        ApplicationService.validateApplications(applications);

    }

    public static void beforeUpdate(List<Application__c> newApplications, Map<Id, Application__c> oldMap){
        for(Application__c a : newApplications){
            Application__c old = oldMap.get(a.Id);
            if(old.Status__c != 'Shortlisted' && a.Status__c == 'Shortlisted'){
                System.debug('STATUS CHANGED TO SHORTLISTED');
            }
        }

    }

    public static void afterUpdate(List<Application__c> newApplications, Map<Id, Application__c> oldMap){
        ApplicationService.processShortlistedApplications(newApplications, oldMap);
    }
}
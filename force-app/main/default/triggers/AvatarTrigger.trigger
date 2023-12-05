trigger AvatarTrigger on Avatar__c (before insert, before delete, after insert, after update, before update) {
	AvatarTriggerHandler.getHandler(Trigger.new, Trigger.old, Trigger.oldMap); 
}
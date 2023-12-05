trigger AccountTrigger on Account (after insert, before insert, before update) {
	AccountTriggerHandler.getHandler(Trigger.new, Trigger.oldMap);
}
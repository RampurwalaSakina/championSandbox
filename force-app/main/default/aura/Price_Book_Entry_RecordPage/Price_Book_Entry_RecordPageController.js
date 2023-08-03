({
    doInit : function(component, event, helper) {
       helper.doInithelper(component, event, helper)
    },

    editRecord : function(component, event, helper){
        console.log('Edit Record');
        console.log(event.getSource().get('v.name'));
        console.log(event.getSource().get('v.value'));

        console.log(event.target);

        helper.doInithelper(component, event, helper)
        component.set("v.viewMode", false);
    },
    leaveEditForm : function(component, event, helper){
        console.log('Leave Edit Form');
        $A.get('e.force:refreshView').fire();
        component.set("v.viewMode", true);
    },

    saveRecord : function(component, event, helper){
        console.log('Save Record');
        var temp = component.get("v.pbEntry");
        debugger;
        console.log('check your input s ',{temp});

        var action = component.get("c.updateRecord");
        action.setParams({
            pbEntry : component.get("v.pbEntry")
        });
        action.setCallback(this, function (response) {
            component.set("v.viewMode", true);
            var state = response.getState();
            console.log('state ==> '+state);
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
            } else {
                let temp = response.getError();
                console.log('temp error ',temp);
                var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": "Error",
					"title": "Error!",
					"message": "Something Went Wrong."
				});
				toastEvent.fire();
            }
        });
        $A.enqueueAction(action);

    },
})
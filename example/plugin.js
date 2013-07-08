(function($, MITHgrid) {
	MITHgrid.Plugin.namespace("StateMachineEditor");
    MITHgrid.Plugin.StateMachineEditor.initInstance = function(options) {
        var that,
		types = $.extend({
            StateMachine: "StateMachine",
            State: "State",
            Transition: "Transition"
        },
        options.types),
        properties = $.extend({
            state: "state",
            transtion: "transition",
            statemachine: "statemachine"
        },
        options.properties),
		typeOptions = {},
		propOptions = {
			"position-x": {
				valueType: "numeric"
			},
			"position-y": {
				valueType: "numeric"
			},
			"height": {
				valueType: "numeric"
			},
			"width": {
				valueType: "numeric"
			}
		};
		
		typeOptions[types.StateMachine] = {}
		typeOptions[types.State] = {}
		typeOptions[types.Transition] = {}
		
		propOptions[properties.state] = {
			valueType: "item"
		};
		
		propOptions[properties.state + "-from"] = {
			valueType: "item"
		};
		propOptions[properties.state + "-to"] = {
			valueType: "item"
		};

        that = MITHgrid.Plugin.initInstance("StateMachineEditor", {
			types: typeOptions,
			properties: propOptions,
            presentations: {
				sheet: {
	                type: MITHgrid.Presentation.Flow,
	                container: options.container,
	                label: 'sheet',
	                options: {
	                    margins: options.margins
	                }
            	}
			}
        });

        return that;
    };
})(jQuery, MITHgrid);
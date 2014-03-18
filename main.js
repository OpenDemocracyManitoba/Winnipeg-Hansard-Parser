$boot(function(){
    'use strict';
    
    
    // Binds click handlers for a specific event to a
    // collection of nodes. Ensures that handlers are
    // never set twice by removing first and then setting.
    function $on_each(nodes, event, click_handler) {
       $each(nodes, function(node) {
            $off(node, event, click_handler);
            $on(node, event, click_handler);
       });
    }
    
    // Used by the following add_*_event click handlers.
    // When executed by a button within a form
    // this function searches for a form template
    // with an id specified by the type parameter.
    // This template is then dynamically added after
    // the parent form of the button that was clicked.
    function add_new_template(event, type) {
        event.preventDefault();
        var node = event.target,
            template = $id(type),
            parent_form = $parent(node);
        $after(parent_form, $html_of(template));
        // NOTICE: All click handlers are re-binded after this
        // new form is added to the DOM.
        bind_click_events();
    }
    
    // Four event handlers for the add* buttons in our forms.
    var add_speaker_event = function(event) { add_new_template(event, 'speaker-template'); };
    var add_motion_event  = function(event) { add_new_template(event, 'motion-template');  };
    var add_vote_event    = function(event) { add_new_template(event, 'vote-template');    };
    var add_section_event = function(event) { add_new_template(event, 'section-template'); };
    
    // The event handler for the mute button in our forms.
    var mute_event = function(e){
        var node = e.target;
        e.preventDefault();
        var parent_form = $parent(node);
        $toggle(parent_form, 'muted');
        if ($html_of(node) === 'mute') {
            $html(node,'unmute');
        } else {
            $html(node,'mute');
        }
    };
    
    var next_event = function(e) {
        var node = e.target;
        e.preventDefault();
        var next_form = $next($parent(node));
        next_form.scrollIntoView(true);
    }
    
    // Binds all the click handlers to the appropriate buttons.
    function bind_click_events() {
        var mute_buttons = $class('mute'),
            add_speaker_buttons = $class('add_speaker'),
            add_motion_buttons = $class('add_motion'),
            add_vote_buttons = $class('add_vote'),
            add_section_buttons = $class('add_section'),
            next_buttons = $class('next');
            
        $on_each(mute_buttons, 'click', mute_event);
        $on_each(add_speaker_buttons, 'click', add_speaker_event);
        $on_each(add_motion_buttons, 'click', add_motion_event);
        $on_each(add_vote_buttons, 'click', add_vote_event);
        $on_each(add_section_buttons, 'click', add_section_event);
        $on_each(next_buttons, 'click', next_event);
    }
    
    bind_click_events();
    
    var build_json_button = $id('build_json');
    $on(build_json_button, 'click', function(){
        console.log("Asdfa");
        var sections = $all('section'),
            json = {};
        
        // Each section represents the outer keys of the json object we are building.
        $each(sections, function(section_node){
            var section_class = $attribute_of(section_node, 'class'),
                forms = $all("form", section_node);
            
            // Forms within the sections can either represent objects or arrays of objects.
            // The type of a form (array/object) is determined by its data-capture-type attribute.
            $each(forms, function(form_node){
                var form_type = $attribute_of(form_node, 'data-capture-type'),
                    form_class = $attribute_of(form_node, 'class'),
                    captures = $all(".capture", form_node),
                    capture_object;
                    
                // Within each form we have marked certain elements for capture
                $each(captures, function(capture_node){
                    var capture_type = $attribute_of(capture_node, 'type') || 'unspecified';
                    
                    // Captured checkboxes build an array of checked elements.
                    if (capture_type == 'checkbox') {
                        capture_object = capture_object || [];
                        var capture_value = $attribute_of(capture_node, 'value');
                        var checked = $attribute_of(capture_node, 'checked') || 'unchecked';
                        if (checked === 'checked') {
                            capture_object.push(capture_value);
                        }
                    } else { // Captures that are not checkboxes nest within objects.
                        capture_object = capture_object || {};
                        var capture_name = $attribute_of(capture_node, 'name');
                        capture_object[capture_name] = capture_node.value;
                    }
                    
                });
                
                // We deal with form arrays and form objects differently.
                // For arrays we first add a 'type' key to the capture_object
                // and then we push this into an array at position section_class.
                // The type value comes from the form's data-key attribute
                // Currently allowed types for arrays are: speaker, motion, vote, section
                // For objects, we just set the value of the key section_class.
                if (form_class !== 'muted') {
                    if (form_type === 'array') {
                        var form_array_key = $attribute_of(form_node, 'data-key');
                        json[section_class] = json[section_class] || [];
                        capture_object['type'] = form_array_key;
                        json[section_class].push(capture_object);
                    } else {
                        json[section_class] = capture_object;
                    }
                }
            });
        });
        
        var json_output = $id('json_output');
        json_output.value = JSON.stringify(json);
    });
});
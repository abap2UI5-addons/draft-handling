CLASS z2ui5add_cl_cc_bind_upd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_js
      RETURNING
        VALUE(result) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5add_cl_cc_bind_upd IMPLEMENTATION.

  METHOD get_js.

    result = `if (!z2ui5.Timer) {sap.ui.define("z2ui5/BindingUpdate" , [` && |\n| &&
      `   "sap/ui/core/Control"` && |\n| &&
      `], (Control) => {` && |\n| &&
      `   "use strict";` && |\n| &&
      |\n| &&
      `   return Control.extend("z2ui5.BindingUpdate", {` && |\n| &&
      `       metadata : {` && |\n| &&
      `           properties: {` && |\n| &&
*            `          value: {` && |\n| &&
*      `                    type: "string",` && |\n| &&
*      `                    defaultValue: ""` && |\n| &&
*      `                },` && |\n| &&
      `                path: {` && |\n| &&
      `                    type: "string",` && |\n| &&
      `                    defaultValue: "/XX"` && |\n| &&
      `                },` && |\n| &&
*      `                checkActive: {` && |\n| &&
*      `                    type: "boolean",` && |\n| &&
*      `                    defaultValue: true` && |\n| &&
*      `                },` && |\n| &&
*      `                checkRepeat: {` && |\n| &&
*      `                    type: "boolean",` && |\n| &&
*      `                    defaultValue: false` && |\n| &&
*      `                },` && |\n| &&
      `            },` && |\n| &&
      `            events: {` && |\n| &&
      `                 "changed": { ` && |\n| &&
      `                        allowPreventDefault: true,` && |\n| &&
      `                        parameters: {},` && |\n| &&
      `                 }` && |\n| &&
      `            }` && |\n| &&
      `       },` && |\n| &&
      `       onAfterRendering() {` && |\n| &&
      `       },` && |\n| &&
      `       startBindingListening( oControl){` && |\n| &&
      `          if ( oControl?.isActive == true ){ return; }` && |\n| &&
             `   oControl.isActive = true;` && |\n|  &&
      `         var model = sap.z2ui5.oView.getModel();` && |\n|  &&
      `var binding = new sap.ui.model.Binding(model, oControl.getProperty("path") , model.getContext( oControl.getProperty("path") ) );` && |\n|  &&
      `binding.attachChange(function() {` && |\n|  &&
      `       ` && |\n|  &&
     `       if ( sap.z2ui5.modelbackup ) { if (  sap.z2ui5.modelbackup === JSON.stringify( sap.z2ui5.oView.getModel().oData.XX.QUANTITY ) ) { return; } }` && |\n|  &&
      `       if ( sap.z2ui5.isBusy == true ){ return; } oControl.fireChanged();` && |\n|  &&
      `     sap.z2ui5.modelbackup = JSON.stringify( sap.z2ui5.oView.getModel().oData.XX.QUANTITY ); ` && |\n|  &&
      `     } );` && |\n|  &&
*      `});  ` && |\n| &&

      `       },` && |\n| &&
      `       renderer(oRm, oControl) {` && |\n| &&
      `        oControl.startBindingListening( oControl );` && |\n| &&
      `        }` && |\n| &&
      `   });` && |\n| &&
      `}); }`.

  ENDMETHOD.
ENDCLASS.

CLASS z2ui5add_cl_draft_sample_02 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA mv_new_draft_id TYPE string.
    DATA message TYPE string.

  PROTECTED SECTION.

    DATA mo_last_draft TYPE REF TO z2ui5_if_app.
    DATA client        TYPE REF TO z2ui5_if_client.

    METHODS display_view.
    METHODS on_init.
    METHODS on_navigated.
    METHODS on_event.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5add_cl_draft_sample_02 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init(  ).
      RETURN.
    ENDIF.

    IF client->check_on_navigated( ).
      on_navigated( ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_z2ui5( )->websocket(
    received = client->_event( 'WS_MESSAGE_RECEIVED' )
    value = client->_bind_edit( mv_new_draft_id )
     ).

*    view->_z2ui5( )->binding_update(
*    path  = `/XX/QUANTITY`
*    changed = client->_event( 'DATA_CHANGED' )
**    value = client->_bind_edit( mv_new_draft_id )
*     ).

    client->view_display( view->shell(
         )->page(
                 title          = 'abap2UI5 - First Example'
                 navbuttonpress = client->_event( val = 'BACK' )
                 shownavbutton = client->check_app_prev_stack( )
             )->simple_form( title = 'Form Title' editable = abap_true
                 )->content( 'form'
                     )->title( 'Input'
                     )->label( 'quantity'
                     )->input( client->_bind_edit( quantity )
                     )->label( `product`
                     )->input( value = product enabled = abap_false
                     )->button(
                         text  = 'save draft'
                         press = client->_event( val = 'DATA_CHANGED' )
          )->stringify( ) ).

  ENDMETHOD.


  METHOD on_init.

    "check if draft exists, if yes ask for loading
    mo_last_draft = NEW  z2ui5add_cl_draft_srv( )->collaborative_load( 'MY_DRAFT_TEST' ).
    IF mo_last_draft IS BOUND.
      DATA(lo_popup) = z2ui5_cl_pop_to_confirm=>factory( `Draft active, reload?` ).
      client->nav_app_call( lo_popup ).
      RETURN.
    ENDIF.

    "otherwise, just start the app with init values
    display_view(  ).

  ENDMETHOD.


  METHOD on_navigated.

    IF message IS NOT INITIAL.
      client->message_toast_display( message ).
      CLEAR message.
    ENDIF.

    TRY.
        IF mv_new_draft_id IS NOT INITIAL.
          mo_last_draft = NEW  z2ui5add_cl_draft_srv( )->collaborative_load( 'MY_DRAFT_TEST' ).
          client->nav_app_leave( mo_last_draft ).
          CLEAR mv_new_draft_id.
          RETURN.
        ENDIF.
        "check if popup was active, if yes and answer is yes -> go to last draft
        DATA(lo_prev) = CAST z2ui5_cl_pop_to_confirm( client->get_app( client->get(  )-s_draft-id_prev_app ) ).
        DATA(lv_confirm_result) = lo_prev->result( ).
        IF lv_confirm_result = abap_true.
          client->nav_app_leave( mo_last_draft ).
          RETURN.
        ENDIF.
      CATCH cx_root.
    ENDTRY.

    "otherwise, just start the app with init values
    CLEAR mo_last_draft.
    display_view(  ).
    RETURN.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'WS_MESSAGE_RECEIVED'.
        mo_last_draft = NEW  z2ui5add_cl_draft_srv( )->collaborative_load( 'MY_DRAFT_TEST' ).
        CAST z2ui5add_cl_draft_sample_02( mo_last_draft )->message = `Draft updated!`.
        client->nav_app_leave( mo_last_draft ).
        CLEAR mv_new_draft_id.
*        client->message_toast_display( `Draft updated!` ).
        RETURN.
*        DATA(lo_popup) = z2ui5_cl_pop_to_confirm=>factory( `Draft updated, get latest changes?` ).
*        client->nav_app_call( lo_popup ).

      WHEN 'DATA_CHANGED'.
        CLEAR mv_new_draft_id.
        NEW  z2ui5add_cl_draft_srv( )->collaborative_save(
          id   = client->get( )-s_draft-id
          name = 'MY_DRAFT_TEST' ).

        z2ui5add_cl_ws_channel_wrapper=>send_text( client->get( )-s_draft-id ).
        client->message_toast_display( `Message send!` ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.

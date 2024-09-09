CLASS z2ui5add_cl_draft_srv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS personal_save
      IMPORTING
        id   TYPE clike
        name TYPE clike.

    METHODS collaborative_save
      IMPORTING
        id   TYPE clike
        name TYPE clike.

    METHODS collaborative_load
      IMPORTING
        name          TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_IF_APP.

    METHODS personal_load
      IMPORTING
        name          TYPE clike
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_IF_APP.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5add_cl_draft_srv IMPLEMENTATION.

  METHOD personal_load.
    TRY.
        DATA(lv_id) = ``.

        z2ui5_cl_util=>db_load_by_handle(
         EXPORTING
            handle       = 'DRAFT_LOGIC'
            handle2      = name
            handle3      = z2ui5_cl_util=>context_get_user_tech( )
         IMPORTING
             result = lv_id
         ).

        DATA lv_id_next TYPE string.
        SELECT SINGLE id
          FROM z2ui5_t_01
          WHERE id = @lv_id
          INTO @lv_id_next.

*        DATA(lo_result) = NEW z2ui5_cl_core_draft_srv( )->read_draft( lv_id_next ).
        DATA(lo_app) = z2ui5_cl_core_app=>db_load( lv_id_next ).
        result = CAST #( lo_app->mo_app ).

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD collaborative_load.
    TRY.
        DATA(lv_id) = ``.

        z2ui5_cl_util=>db_load_by_handle(
         EXPORTING
            handle       = 'DRAFT_LOGIC'
            handle2      = name
*            handle3      = z2ui5_cl_util=>context_get_user_tech( )
         IMPORTING
             result = lv_id
         ).

        DATA lv_id_next TYPE string.
        SELECT SINGLE id
          FROM z2ui5_t_01
          WHERE id = @lv_id
          INTO @lv_id_next.

*        DATA(lo_result) = NEW z2ui5_cl_core_draft_srv( )->read_draft( lv_id_next ).
        DATA(lo_app) = z2ui5_cl_core_app=>db_load( lv_id_next ).
        result = CAST #( lo_app->mo_app ).

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD personal_save.

    z2ui5_cl_util=>db_save(
         handle       = 'DRAFT_LOGIC'
         handle2      = name
         handle3      = z2ui5_cl_util=>context_get_user_tech( )
         data         = id
         check_commit = abap_true
    ).

  ENDMETHOD.

  METHOD collaborative_save.

    z2ui5_cl_util=>db_save(
         handle       = 'DRAFT_LOGIC'
         handle2      = name
*         handle3      = z2ui5_cl_util=>context_get_user_tech( )
         data         = id
         check_commit = abap_true
    ).

  ENDMETHOD.

ENDCLASS.

class /MBTOOLS/CL_VERSIONS definition
  public
  final
  create public .

public section.

  interfaces ZIF_APACK_MANIFEST .

  constants C_VERSION type STRING value '1.0.0' ##NO_TEXT.

  methods CONSTRUCTOR .
protected section.
private section.

  aliases APACK_MANIFEST
    for ZIF_APACK_MANIFEST~DESCRIPTOR .
ENDCLASS.



CLASS /MBTOOLS/CL_VERSIONS IMPLEMENTATION.


  METHOD constructor.
    DATA:
      name       TYPE string,
      tool       TYPE REF TO object,
      manifest   TYPE REF TO zif_apack_manifest,
      dependency TYPE zif_apack_manifest=>ty_dependency.

*   APACK
    apack_manifest = VALUE #(
      group_id    = 'github.com/mbtools'
      artifact_id = 'mbt-versions'
      version     = c_version
      git_url     = 'https://github.com/mbtools/mbt-versions.git'
    ).

    DO 3 TIMES.
      CASE sy-index.
        WHEN 1.
          name = '/MBTOOLS/CL_TOOLS'.
        WHEN 2.
          name = '/MBTOOLS/CL_COMMAND_FIELD'.
        WHEN 3.
          name = '/MBTOOLS/CL_CTS_REQ_DISPLAY'.
      ENDCASE.

      CREATE OBJECT tool TYPE (name).
      CHECK sy-subrc = 0.

      manifest ?= tool.

      dependency = VALUE #(
        group_id    = manifest->descriptor-group_id
        artifact_id = manifest->descriptor-artifact_id
        version     = manifest->descriptor-version
        git_url     = manifest->descriptor-git_url
      ).

      INSERT dependency INTO TABLE apack_manifest-dependencies.
    ENDDO.

  ENDMETHOD.
ENDCLASS.

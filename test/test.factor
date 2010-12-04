! Copyright (C) 2010 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: calendar classes.struct combinators kernel threads
wiimote.bindings ;
IN: wiimote.test

: <bdaddr-any> ( -- bdaddr ) bdaddr_t <struct> ;
: get-msg ( mote -- )
    { int cwiid_mesg timespec } [ cwiid_get_mesg drop ] with-out-parameters . . . ;
: wiimote-test ( -- )
   <bdaddr-any> CWIID_FLAG_CONTINUOUS CWIID_FLAG_MESG_IFC bitor cwiid_open
   { 
   [ CWIID_FLAG_CONTINUOUS cwiid_enable drop ]
   [ CWIID_CMD_RPT_MODE CWIID_RPT_IR cwiid_command drop ] 
   [ [ get-msg ] curry 50 swap times ]
   [ cwiid_close drop ] 
   } cleave ;

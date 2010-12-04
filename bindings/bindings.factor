! Copyright (C) 2010 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.libraries alien.syntax
classes.struct literals unix.time unix.types ;
IN: wiimote.bindings

<< "cwiid" "libcwiid.so" cdecl add-library >>
LIBRARY: cwiid 
! /* Flags */
CONSTANT:  CWIID_FLAG_MESG_IFC  HEX: 01
CONSTANT:  CWIID_FLAG_CONTINUOUS HEX: 02
CONSTANT:  CWIID_FLAG_REPEAT_BTN HEX: 04
CONSTANT:  CWIID_FLAG_NONBLOCK  HEX: 08
CONSTANT:  CWIID_FLAG_MOTIONPLUS HEX: 10

! /* Report Mode Flags */
CONSTANT:  CWIID_RPT_STATUS  HEX: 01
CONSTANT:  CWIID_RPT_BTN   HEX: 02
CONSTANT:  CWIID_RPT_ACC   HEX: 04
CONSTANT:  CWIID_RPT_IR   HEX: 08
CONSTANT:  CWIID_RPT_NUNCHUK  HEX: 10
CONSTANT:  CWIID_RPT_CLASSIC  HEX: 20
CONSTANT:  CWIID_RPT_BALANCE  HEX: 40
CONSTANT:  CWIID_RPT_MOTIONPLUS HEX: 80
! TODO
CONSTANT:  CWIID_RPT_EXT  HEX: f0
! CONSTANT:  CWIID_RPT_EXT  $[ 0 ${ CWIID_RPT_NUNCHUK CWIID_RPT_CLASSIC
!                                              CWIID_RPT_BALANCE CWIID_RPT_MOTIONPLUS } [ bitor ] reduce ]

! /* LED flags */
CONSTANT:  CWIID_LED1_ON HEX: 01
CONSTANT:  CWIID_LED2_ON HEX: 02
CONSTANT:  CWIID_LED3_ON HEX: 04
CONSTANT:  CWIID_LED4_ON HEX: 08

! /* Button flags */
CONSTANT:  CWIID_BTN_2  HEX: 0001
CONSTANT:  CWIID_BTN_1  HEX: 0002
CONSTANT:  CWIID_BTN_B  HEX: 0004
CONSTANT:  CWIID_BTN_A  HEX: 0008
CONSTANT:  CWIID_BTN_MINUS HEX: 0010
CONSTANT:  CWIID_BTN_HOME HEX: 0080
CONSTANT:  CWIID_BTN_LEFT HEX: 0100
CONSTANT:  CWIID_BTN_RIGHT HEX: 0200
CONSTANT:  CWIID_BTN_DOWN HEX: 0400
CONSTANT:  CWIID_BTN_UP HEX: 0800
CONSTANT:  CWIID_BTN_PLUS HEX: 1000

CONSTANT:  CWIID_NUNCHUK_BTN_Z HEX: 01
CONSTANT:  CWIID_NUNCHUK_BTN_C HEX: 02

CONSTANT:  CWIID_CLASSIC_BTN_UP HEX: 0001
CONSTANT:  CWIID_CLASSIC_BTN_LEFT HEX: 0002
CONSTANT:  CWIID_CLASSIC_BTN_ZR HEX: 0004
CONSTANT:  CWIID_CLASSIC_BTN_X  HEX: 0008
CONSTANT:  CWIID_CLASSIC_BTN_A  HEX: 0010
CONSTANT:  CWIID_CLASSIC_BTN_Y  HEX: 0020
CONSTANT:  CWIID_CLASSIC_BTN_B  HEX: 0040
CONSTANT:  CWIID_CLASSIC_BTN_ZL HEX: 0080
CONSTANT:  CWIID_CLASSIC_BTN_R  HEX: 0200
CONSTANT:  CWIID_CLASSIC_BTN_PLUS HEX: 0400
CONSTANT:  CWIID_CLASSIC_BTN_HOME HEX: 0800
CONSTANT:  CWIID_CLASSIC_BTN_MINUS HEX: 1000
CONSTANT:  CWIID_CLASSIC_BTN_L  HEX: 2000
CONSTANT:  CWIID_CLASSIC_BTN_DOWN HEX: 4000
CONSTANT:  CWIID_CLASSIC_BTN_RIGHT HEX: 8000

! /* Send Report flags */
CONSTANT:  CWIID_SEND_RPT_NO_RUMBLE    HEX: 01

! /* Data Read/Write flags */
CONSTANT:  CWIID_RW_EEPROM HEX: 00
CONSTANT:  CWIID_RW_REG HEX: 04
CONSTANT:  CWIID_RW_DECODE HEX: 00

! /* Maximum Data Read Length */
CONSTANT:  CWIID_MAX_READ_LEN HEX: FFFF

! /* Array Index Defs */
CONSTANT:  CWIID_X  0
CONSTANT:  CWIID_Y  1
CONSTANT:  CWIID_Z  2
CONSTANT:  CWIID_PHI 0
CONSTANT:  CWIID_THETA 1
CONSTANT:  CWIID_PSI 2

! /* Acc Defs */
CONSTANT:  CWIID_ACC_MAX HEX: FF

! /* IR Defs */
CONSTANT:  CWIID_IR_SRC_COUNT 4
CONSTANT:  CWIID_IR_X_MAX  1024
CONSTANT:  CWIID_IR_Y_MAX  768

! /* Battery */
CONSTANT:  CWIID_BATTERY_MAX HEX: D0

! /* Classic Controller Maxes */
CONSTANT:  CWIID_CLASSIC_L_STICK_MAX HEX: 3F
CONSTANT:  CWIID_CLASSIC_R_STICK_MAX HEX: 1F
CONSTANT:  CWIID_CLASSIC_LR_MAX HEX: 1F

! /* Environment Variables */
CONSTANT:  WIIMOTE_BDADDR "WIIMOTE_BDADDR"

! /* Callback Maximum Message Count */
CONSTANT:  CWIID_MAX_MESG_COUNT 5

! /* Enumerations */
ENUM: cwiid_command_enum
 CWIID_CMD_STATUS
 CWIID_CMD_LED
 CWIID_CMD_RUMBLE
 CWIID_CMD_RPT_MODE
;

ENUM: cwiid_mesg_type 
 CWIID_MESG_STATUS
 CWIID_MESG_BTN
 CWIID_MESG_ACC
 CWIID_MESG_IR
 CWIID_MESG_NUNCHUK
 CWIID_MESG_CLASSIC
 CWIID_MESG_BALANCE
 CWIID_MESG_MOTIONPLUS
 CWIID_MESG_ERROR
 CWIID_MESG_UNKNOWN
;

ENUM: cwiid_ext_type 
 CWIID_EXT_NONE
 CWIID_EXT_NUNCHUK
 CWIID_EXT_CLASSIC
 CWIID_EXT_BALANCE
 CWIID_EXT_MOTIONPLUS
 CWIID_EXT_UNKNOWN
;

ENUM: cwiid_error 
 CWIID_ERROR_NONE
 CWIID_ERROR_DISCONNECT
 CWIID_ERROR_COMM
;

STRUCT: acc_cal 
{ zero uint8_t[3] }
{ one uint8_t[3] }
;

STRUCT: balance_cal 
{ right_top uint16_t[3] }
{ right_bottom uint16_t[3] }
{ left_top uint16_t[3] }
{ left_bottom uint16_t[3] }
;

! /* Message Structs */
STRUCT: cwiid_status_mesg 
{ type cwiid_mesg_type }
{ battery uint8_t }
{ ext_type cwiid_ext_type }
; 

STRUCT: cwiid_btn_mesg 
{ type cwiid_mesg_type }
{ buttons uint16_t }
;

STRUCT: cwiid_acc_mesg 
{ type cwiid_mesg_type }
{ acc uint8_t[3] }
;

STRUCT: cwiid_ir_src 
{ valid char }
{ pos uint16_t[2] }
{ size int8_t }
;

STRUCT: cwiid_ir_mesg 
{ type cwiid_mesg_type }
{ src cwiid_ir_src[CWIID_IR_SRC_COUNT] }
;

STRUCT: cwiid_nunchuk_mesg 
{ type cwiid_mesg_type }
{ stick uint8_t[2] }
{ acc uint8_t[3] }
{ buttons uint8_t }
;

STRUCT: cwiid_classic_mesg 
{ type cwiid_mesg_type }
{ l_stick uint8_t[2] }
{ r_stick uint8_t[2] }
{ l uint8_t }
{ r uint8_t }
{ buttons uint16_t }
;

STRUCT: cwiid_balance_mesg 
{ type cwiid_mesg_type }
{ right_top uint16_t }
{ right_bottom uint16_t }
{ left_top uint16_t }
{ left_bottom uint16_t }
;

STRUCT: cwiid_motionplus_mesg 
{ type cwiid_mesg_type }
{ angle_rate uint16_t[3] }
;

STRUCT: cwiid_error_mesg 
{ type cwiid_mesg_type }
{ error cwiid_error }
;

UNION-STRUCT: cwiid_mesg 
{ type cwiid_mesg_type }
{ status_mesg cwiid_status_mesg }
{ btn_mesg cwiid_btn_mesg }
{ acc_mesg cwiid_acc_mesg }
{ ir_mesg cwiid_ir_mesg }
{ nunchuk_mesg cwiid_nunchuk_mesg }
{ classic_mesg cwiid_classic_mesg }
{ balance_mesg cwiid_balance_mesg }
{ motionplus_mesg cwiid_motionplus_mesg }
{ error_mesg cwiid_error_mesg }
;

! /* State Structs */
STRUCT: nunchuk_state 
{ stick uint8_t[2] }
{ acc uint8_t[3] }
{ buttons uint8_t }
;

STRUCT: classic_state 
{ l_stick uint8_t[2] }
{ r_stick uint8_t[2] }
{ l uint8_t }
{ r uint8_t }
{ buttons uint16_t }
;

STRUCT: balance_state 
{ right_top uint16_t }
{ right_bottom uint16_t }
{ left_top uint16_t }
{ left_bottom uint16_t }
;

STRUCT: motionplus_state 
{ angle_rate uint16_t[3] }
;

UNION-STRUCT: ext_state 
{ nunchuk nunchuk_state }
{ classic classic_state }
{ balance balance_state }
{ motionplus motionplus_state }
;

STRUCT: cwiid_state 
{ rpt_mode uint8_t }
{ led uint8_t }
{ rumble uint8_t }
{ battery uint8_t }
{ buttons uint16_t }
{ acc uint8_t[3] }
{ ir_src cwiid_ir_src[CWIID_IR_SRC_COUNT] }
{ ext_type cwiid_ext_type }
{ ext ext_state }
{ error cwiid_error }
;

! /* Typedefs */
TYPEDEF: void cwiid_wiimote_t

! TYPEDEF: void cwiid_mesg_callback_t(cwiid_wiimote_t *, int,
!                                   union cwiid_mesg [], struct timespec *);
! TYPEDEF: void cwiid_err_t(cwiid_wiimote_t *, const char *, va_list ap);

! TODO: cwiid_mesg array is not an array...
CALLBACK: void cwiid_mesg_callback_t ( cwiid_wiimote_t* , int ,
                                   cwiid_mesg [],  timespec*  ) ;
! CALLBACK: void cwiid_err_t( cwiid_wiimote_t* , char* , va_list ap ) ;
! /* get_bdinfo */
CONSTANT:  BT_NO_WIIMOTE_FILTER HEX: 01
CONSTANT:  BT_NAME_LEN 32

! TODO: bluetooth
STRUCT: bdaddr_t 
{ b uint8_t[6] }
;
STRUCT: cwiid_bdinfo
{ bdaddr bdaddr_t }
{ btclass uint8_t[3]  }
{ name char[BT_NAME_LEN] }
;

! /* Error reporting ( library wide ) */
! Uncomment when I know how to deal with va_list
! FUNCTION: int cwiid_set_err( cwiid_err_t* err ) ;
! FUNCTION: void cwiid_err_default(  wiimote* wiimote, const char* str, va_list ap ) ;

! /* Connection */
! TODO function aliases ?
! #define cwiid_connect cwiid_open
! #define cwiid_disconnect cwiid_close
FUNCTION: cwiid_wiimote_t* cwiid_open ( bdaddr_t* bdaddr, int flags ) ;
FUNCTION: cwiid_wiimote_t* cwiid_open_timeout ( bdaddr_t* bdaddr, int flags, int timeout ) ;
FUNCTION: int cwiid_close ( cwiid_wiimote_t* wiimote ) ;

FUNCTION: int cwiid_get_id ( cwiid_wiimote_t* wiimote ) ;
! FUNCTION: int cwiid_set_data( cwiid_wiimote_t* wiimote, const void *data ) ;
FUNCTION: int cwiid_set_data ( cwiid_wiimote_t* wiimote, void *data ) ;
! FUNCTION: const void *cwiid_get_data( cwiid_wiimote_t *wiimote ) ;
FUNCTION: void* cwiid_get_data ( cwiid_wiimote_t* wiimote ) ;
FUNCTION: int cwiid_enable ( cwiid_wiimote_t* wiimote, int flags ) ;
FUNCTION: int cwiid_disable ( cwiid_wiimote_t* wiimote, int flags ) ;

! /* Interfaces */
FUNCTION: int cwiid_set_mesg_callback ( cwiid_wiimote_t* wiimote,
                       cwiid_mesg_callback_t callback ) ;
FUNCTION: int cwiid_get_mesg ( cwiid_wiimote_t* wiimote, int* mesg_count,
                    cwiid_mesg* mesg[],  timespec* timestamp ) ;
FUNCTION: int cwiid_get_state ( cwiid_wiimote_t* wiimote,  cwiid_state* state ) ;
FUNCTION: int cwiid_get_acc_cal (  cwiid_wiimote_t* wiimote, cwiid_ext_type ext_type,
                       acc_cal* acc_cal ) ;
FUNCTION: int cwiid_get_balance_cal ( cwiid_wiimote_t* wiimote,
                           balance_cal* balance_cal ) ;

! /* Operations */
FUNCTION: int cwiid_command ( cwiid_wiimote_t* wiimote, cwiid_command_enum command,
                  int flags ) ;
! FUNCTION: int cwiid_send_rpt( cwiid_wiimote_t* wiimote, uint8_t flags, uint8_t report,
!                    size_t len, const void* data ) ;
FUNCTION: int cwiid_send_rpt ( cwiid_wiimote_t* wiimote, uint8_t flags, uint8_t report,
                   size_t len, void* data ) ;
FUNCTION: int cwiid_request_status ( cwiid_wiimote_t* wiimote ) ;
FUNCTION: int cwiid_set_led ( cwiid_wiimote_t* wiimote, uint8_t led ) ;
FUNCTION: int cwiid_set_rumble ( cwiid_wiimote_t* wiimote, uint8_t rumble ) ;
FUNCTION: int cwiid_set_rpt_mode ( cwiid_wiimote_t* wiimote, uint8_t rpt_mode ) ;
FUNCTION: int cwiid_read ( cwiid_wiimote_t* wiimote, uint8_t flags, uint32_t offset,
               uint16_t len, void* data ) ;
! FUNCTION: int cwiid_write( cwiid_wiimote_t* wiimote, uint8_t flags, uint32_t offset,
!                 uint16_t len, const void* data ) ;
FUNCTION: int cwiid_write ( cwiid_wiimote_t* wiimote, uint8_t flags, uint32_t offset,
                uint16_t len, void* data ) ;
! /* int cwiid_beep( cwiid_wiimote_t *wiimote ); */

! /* HCI functions */
FUNCTION: int cwiid_get_bdinfo_array ( int dev_id, uint timeout, int max_bdinfo,
                            cwiid_bdinfo* *bdinfo, uint8_t flags ) ;
FUNCTION: int cwiid_find_wiimote ( bdaddr_t* bdaddr, int timeout ) ;


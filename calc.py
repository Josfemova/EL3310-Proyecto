
#valores generales
LOW= 0 
HIGH= 1
INPUT= 0
OUTPUT= 1

#Peatonal NS
PIN_PNS_RED= 0
PIN_PNS_GREEN= 1

#Semaforo NS 
PIN_SNS_RED= 2
PIN_SNS_YELLOW= 3
PIN_SNS_GREEN= 4

#Peatonal EW
PIN_PEW_RED= 8
PIN_PEW_GREEN= 9

#Semaforo EW
PIN_SEW_RED= 10
PIN_SEW_YELLOW= 11
PIN_SEW_GREEN= 12

#ESTIMULOS
PIN_IRNS= 14
PIN_IREW= 15
PIN_BNS= 16 
PIN_BEW= 17

output_pins = 0b1111100011111

def mask(desc, lista):
    num = 0;
    for x in lista:
        num = num | (1<<x)
    print(".equ {: <13}, {:#020b} // hexa: {:#08x}".format(desc, num, num)) 

mask("PINS",[PIN_PNS_RED, PIN_PNS_GREEN, PIN_SNS_RED, PIN_SNS_YELLOW, 
        PIN_SNS_GREEN, PIN_PEW_RED, PIN_PEW_GREEN, PIN_SEW_RED, 
        PIN_SEW_YELLOW, PIN_SEW_GREEN,PIN_IREW, PIN_IRNS, PIN_BNS, PIN_BEW])
mask("OUTPUT_PINS",[PIN_PNS_RED, PIN_PNS_GREEN, PIN_SNS_RED, PIN_SNS_YELLOW, 
        PIN_SNS_GREEN, PIN_PEW_RED, PIN_PEW_GREEN, PIN_SEW_RED, 
        PIN_SEW_YELLOW, PIN_SEW_GREEN])
mask("INPUT_PINS", [PIN_IREW, PIN_IRNS, PIN_BNS, PIN_BEW])
mask("MASK_GRRR", [PIN_SNS_GREEN, PIN_SEW_RED, PIN_PNS_RED, PIN_PEW_RED])
mask("MASK_YRRR", [PIN_SNS_YELLOW, PIN_SEW_RED, PIN_PNS_RED, PIN_PEW_RED])
mask("MASK_RGRG", [PIN_SNS_RED, PIN_SEW_GREEN, PIN_PNS_RED, PIN_PEW_GREEN])
mask("MASK_GRGR", [PIN_SNS_GREEN, PIN_SEW_RED, PIN_PNS_GREEN, PIN_PEW_RED])
mask("MASK_RYRR", [PIN_SNS_RED, PIN_SEW_YELLOW, PIN_PNS_RED, PIN_PEW_RED])
mask("MASK_RGRR", [PIN_SNS_RED, PIN_SEW_GREEN, PIN_PNS_RED, PIN_PEW_RED])


mask("MASK_PIN_IRNS",[PIN_IRNS]) 
mask("MASK_PIN_IREW",[PIN_IREW]) 
mask("MASK_PIN_BNS", [PIN_BNS ])
mask("MASK_PIN_BEW", [PIN_BEW ])
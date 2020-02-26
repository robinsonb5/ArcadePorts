#include "keyboard.h"
#include "ps2.h"
#include "interrupts.h"
#include "printf.h"

// Only need 2 bits per key in the keytable,
// so we'll use 32-bit ints to store the key statuses
// since that's more convienent for the ZPU.
// Keycode (0-255)>>4 -> Index
// Shift each 2-bit tuple by (keycode & 15)*2.
unsigned int keytable[16]={0};

void KeyboardHandler()
{
	static int keyup=0;
	static int extkey=0;
	int key;

	key=HW_PS2(REG_PS2_KEYBOARD);

	while(key & (1<<BIT_PS2_RECV))
	{
		key&=0xff;

		if(key==KEY_KEYUP)
			keyup=1;
		else if(key==KEY_EXT)
			extkey=1;
		else if(key==KEY_ACK) // response from keyboard to LED message
		{
		}
		else
		{
			int keyidx=extkey ? 128+key : key;
			if(keyup)
				keytable[keyidx>>4]&=~(1<<((keyidx&15)*2));  // Mask off the "currently pressed" bit.
			else
				keytable[keyidx>>4]|=3<<((keyidx&15)*2);	// Currently pressed and pressed since last test.
			extkey=0;
			keyup=0;
		}
		key=HW_PS2(REG_PS2_KEYBOARD);
	}
	GetInterrupts();	// Clear interrupt bit
}


__constructor(100) void ClearKeyboard()
{
	int i;
	puts("Keyboard init function\n");
	for(i=0;i<16;++i)
		keytable[i]=0;
	EnableInterrupts();
}

void AcknowledgeKey(int rawcode)
{
	// Mask off the "pressed since last test" bit.
	keytable[rawcode>>4]&=~(2<<((rawcode&15)*2));
}

int TestKey(int rawcode)
{
	int result;
	result=3&(keytable[rawcode>>4]>>((rawcode&15)*2));
	keytable[rawcode>>4]&=~(2<<((rawcode&15)*2));	// Mask off the "pressed since last test" bit.
	return(result);
}

int TestKeyStroke(int rawcode)
{
	int result;
	result=3&(keytable[rawcode>>4]>>((rawcode&15)*2)); // Test for "pressed and released" rather than "currently down".
	if(result==2)
		keytable[rawcode>>4]&=~(2<<((rawcode&15)*2));	// Mask off the "pressed since last test" bit.
	return(result==2);
}


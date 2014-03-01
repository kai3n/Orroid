package com.example.orroid;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import android.inputmethodservice.Keyboard.Key;

class encrypt {
	public byte[] vulnEncrypt(byte[] msg, Key k) {
		byte[] result = null;
		

		Cipher c;
		try {
			c = Cipher.getInstance("DES");
			c.init(Cipher.ENCRYPT_MODE, (java.security.Key) k);
			result = c.update(msg);
		} 
		catch (NoSuchAlgorithmException e){
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (NoSuchPaddingException e{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
		}
}

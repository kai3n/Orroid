package com.example.orroid;

import java.io.File;
/* race condition vulnerable*/
class FileDeleteThread extends Thread
{
	public void run()
	{
		
			File f = new File("kaien.txt");
			if(f.exists())
				f.delete();
	}
}

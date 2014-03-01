package com.example.orroid;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

class FileAccessThread extends Thread{
	public void run(){
		File f = new File("kaien.txt");
		if( f.exists()){
			try {
				BufferedReader br = new BufferedReader( new FileReader(f));
				br.close();
			}
			catch (IOException e) {
				// TODO Auto-generated catch block
				System.out.println(e.getMessage());
			}
		}
	}

}
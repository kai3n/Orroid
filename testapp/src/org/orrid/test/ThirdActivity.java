package com.example.orroid;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.net.UnknownHostException;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class ThirdActivity extends Activity{

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState){
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.third);
	    
		Button before = (Button)findViewById(R.id.button1);
			    
				before.setOnClickListener( new OnClickListener(){
				        	
							@Override
							public void onClick(View v) {
								Log.i("Multi Activity","Button click is occured..");
								Intent intent = new Intent(ThirdActivity.this, SecondActivity.class);
								startActivity(intent);
							}
				        }
						);
				
		int port = 443;
		String hostname = "127.0.0.1";
		
		try{
			/*
			 SocketFactory socketFactory = SSLSocketFactory,getDefault();
			 Socket socket = socketFactory.createSocket(hostname, port);
			 */
			Socket socket = new Socket(hostname,port);
			InputStream in = socket.getInputStream();
			OutputStream out = socket.getOutputStream();
			in.close();
			out.close();
		}
		catch (UnknownHostException e){
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (IOException e){
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    // TODO Auto-generated method stub
	}

}

package com.example.orroid;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends Activity {

	
	/*Path Traversal Vulnerable*/
	public String filename = "test.txt";
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		filename = "test.txt";
		
        Button button = (Button)findViewById(R.id.button1);
        button.setOnClickListener( new OnClickListener(){
        	
			@Override
			public void onClick(View v) {
				if(v.getId() == R.id.button1){
					EditText objET = (EditText)findViewById(R.id.editText1);
					filename = objET.getText().toString();
					
					File dir = getDir("testdir", Activity.MODE_PRIVATE );
					String path = dir.getAbsolutePath();
					/*vulnerable pattern*/
					File file = new File( path + '/' + filename);
					String Text = path + '/' + filename;
					
					try{
						file.createNewFile();
						FileOutputStream fos = new FileOutputStream(file);
						fos.write(Text.getBytes());
						fos.close();
						
					}
					catch ( IOException e){
						e.printStackTrace();
					}
					
					if(file.exists()){
						try{
							FileInputStream fis = new FileInputStream(file.getAbsoluteFile());
							long fileSizeInByte = file.length();
							byte[] bytes = new byte[(int) fileSizeInByte];
							fis.read(bytes);
							fis.close();
							
							TextView textview = (TextView) findViewById(R.id.textView2);
							textview.setText(new String(bytes));
							Log.v("complited!!","");
						}
						catch( IOException e){
							e.printStackTrace();
						}
					}
				}
			}
        });
        
        Button button2 = (Button)findViewById(R.id.button2);
        button2.setOnClickListener( new OnClickListener(){
        	
			@Override
			public void onClick(View v) {
				Log.i("Multi Activity","Button click is occured..");
				Intent intent = new Intent(MainActivity.this, SecondActivity.class);
				startActivity(intent);
			}
        });
		
        /*
		File dir = getDir("testdir", Activity.MODE_PRIVATE );
		String path = dir.getAbsolutePath();
		//vulnerable pattern
		File file = new File( path + filename);
		String Text = path + filename;
		
		try
		{
			file.createNewFile();
			FileOutputStream fos = new FileOutputStream(file);
			fos.write(Text.getBytes());
			fos.close();
			
		}
		catch ( IOException e)
		{
			e.printStackTrace();
		}
		
		if(file.exists())
		{
			try
			{
				FileInputStream fis = new FileInputStream(file.getAbsoluteFile());
				long fileSizeInByte = file.length();
				byte[] bytes = new byte[(int) fileSizeInByte];
				fis.read(bytes);
				fis.close();
				
				TextView textview = (TextView) findViewById(R.id.textView2);
				textview.setText(new String(bytes));
				Log.v("complited!!","");
			}
			catch( IOException e)
			{
				e.printStackTrace();
			}
		}*/
	    
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
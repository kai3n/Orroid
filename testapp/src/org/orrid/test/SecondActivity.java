package com.example.orroid;

import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class SecondActivity extends Activity {

	/** Called when the activity is first created. */
	@SuppressLint("WorldReadableFiles")
	@SuppressWarnings("deprecation")
	@Override
	public void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    setContentView(R.layout.second);
	    
	    try
	    {
			// use MODE_PRIVATE!!
	    	FileOutputStream out = openFileOutput("test",MODE_WORLD_READABLE);
	    	OutputStreamWriter out1 = new OutputStreamWriter(out);
	    	out1.write("Hello world!");
	    	out1.close();
	    	out.close();
	    }
	    catch ( Throwable a)
	    {
	    	
	    }
	    
	    Button before = (Button)findViewById(R.id.button2);
	    Button next = (Button)findViewById(R.id.button1);
	    
		before.setOnClickListener( new OnClickListener(){
		        	
					@Override
					public void onClick(View v) {
						Log.i("Multi Activity","Button click is occured..");
						Intent intent = new Intent(SecondActivity.this, MainActivity.class);
						startActivity(intent);
					}
		        });
	    
	    next.setOnClickListener( new OnClickListener(){
        	
			@Override
			public void onClick(View v) {
				Log.i("Multi Activity","Button click is occured..");
				Intent intent = new Intent(SecondActivity.this, ThirdActivity.class);
				startActivity(intent);
			}
        });

	    // TODO Auto-generated method stub
	}
	/*null vulnerable*/
	public boolean equals( Object object)
	{
		return (toString().equals(object.toString()));
	}
	
	/*
	public boolean equals( Object object)
	{
		if( object != null )
			return (toString().equals(object.toString()));
		else
			return false;
	} 
	*/
	
	/*
	public int hashCode()
	{
		return new HashCodeBuilder(17,37).toHashCode();
	 */
	public double roledice()
	{
		/*
		 Random r = new Random();
		 r.setSeed( new Data().getTime());
		 return (r.nextInt()%6)+1;
		 */
		return Math.random();
	}
	
	public int factorial(int n)
	{
		return n*factorial(n-1);
	}
	
	public void f(boolean b)
	{
			String cmd = System.getProperty("cmd");
			cmd = cmd.trim();
			System.out.println("cmd");
	}
	

}

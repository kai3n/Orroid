// 10. 17
/*
	주석 처리 루틴 이동 ( 파서 내부 -> 전처리기 )

	여러 줄에 걸쳐 한줄의 코드를 작성하는 케이스에 대한 처리

	'{' 을 줄 바꾸고 쓰는 케에스에 대한 처리
*/

public class SampleClass extends FooClass {
	public void func(){
		return Math.random();
	}

	public void func2(Object o){
		o.call();
	}

	public bool equals(Object obj)
	{
		if(obj != null)
		{
			return Cipher.getIns
				tance(
									"MD5");
		}
		else
			return false;
	}

	public void trytest(){
		try{
		}
		catch(Exception e){
			System.out.println("exception occured : " + e.printStackTrace());
		}
	}
}

//����һ���߳���ThreadB������1+2+...��ÿ�ۼ�һ����������200���룬���ۼӵ�N��>3000ʱ���������Nֵ�������̡߳�
//�ڲ��Է����У��������̶߳��󣬲������̡߳�
public class ThreadTest{
	
	public static void main(String[] args){
		
		//��һ�֣��̳�Thread
		Thread t = new ThreadB();
		t.start();
		
		//�ڶ��֣�ʵ��Runnable�ӿ�
		Thread t2 = new Thread(new MyRunnable());
		t2.start();
		
	}

}
class ThreadB extends Thread{

	public void run(){
		int i = 1,sum = 0;
		while(sum <= 5){
			sum += i;
			i++;
			Thread.sleep(200);
		}
		System.out.println(i-1);
	}
}

class MyRunnable implements Runnable{
	public void run(){
		int i = 1,sum = 0;
		while(sum <= 5){
			sum += i;
			i++;
			Thread.sleep(200);
		}
		System.out.println(i-1);
	}
	
}
public class RandomTest {
    public static void main(String[] args) {
        //�������������
        Random random = new Random();
        // �������һ��int����ȡֵ��Χ�ڵ�����
        int num1 = random.nextInt();
        System.out.println(num1);

        // ����[0~100]֮�������������ܲ���101��
        // nextInt����Ϊ����һ��int���͵�������101����ʾֻ��ȡ��100.
        int num2 = random.nextInt(101);//������101
        System.out.println(num2);
    }
}

public class GuessNum {
    public static void main(String[] args) {
        Random random = new Random();

		Scanner sc = new Scanner(System.in);


        //nextInt�����Ϊ����һ��int���͵�������100����ʾֻ��ȡ��99
        //random.nextInt(100)��ʾ����[0,99]�ڵ������
        int guessNum = random.nextInt(100) + 1;
        System.out.println("ϵͳ�Ѿ����������һ��1-100��������");

        int inputNum;
        do {
            System.out.print("������һ��������");
            inputNum = sc.nextInt();
            if (inputNum < guessNum) {
                System.out.println("��С�ˣ�");
            } else if (inputNum > guessNum) {
                System.out.println("�´��ˣ�");
            } else {
                System.out.println("�¶��ˣ�");
            }
        } while (inputNum != guessNum);
    }
}